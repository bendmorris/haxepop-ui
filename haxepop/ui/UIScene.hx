package haxepop.ui;

import haxe.xml.Fast;
import haxepop.HXP;
import haxepop.Entity;
import haxepop.Scene;
import haxepop.Input;
import haxepop.Graphic;
import haxepop.graphics.atlas.AtlasData;
import haxepop.graphics.Image;
import haxepop.input.Mouse;
import haxepop.input.Key;
import haxepop.utils.Draw;
import haxepop.UI;
import openfl.Assets;


class UIScene extends Scene implements UIObject
{
	var entities:Array<UIEntity> = new Array();
	var entityMap:Map<String, UIEntity> = new Map();
	public function get(id:String):UIEntity return entityMap[id];

	/**
	 * Given the path to an XML layout file (e.g. "data/layouts.myscene.xml"),
	 * parses the XML and generates/lays out the UIEntities.
	 */
	public function layout(layoutXML:String)
	{
		var layoutXml = Assets.getText(layoutXML);
#if (cpp || neko)
		// these platforms don't handle escaped characters in XML attributes correctly
		var escaped = [
			"&lt;" => "<",
			"&gt;" => ">",
		];
		for (from in escaped.keys())
		{
			var to = escaped[from];
			layoutXml = StringTools.replace(layoutXml, from, to);
		}
#end
		var xml = Xml.parse(layoutXml);
		var sceneNode = xml.firstElement();
		var fast = new Fast(sceneNode);

		// parse the scene node
		bgColor = fast.has.color ? Color.colors[fast.att.color] : Color.Black;
		if (fast.has.padding) padding = UIUnit.value(fast.att.padding);
		if (fast.has.transition)
		{
			switch (fast.att.transition)
			{
				case "slide":
					var tx = fast.has.transitionX ? Std.parseInt(fast.att.transitionX) : -1;
					var ty = fast.has.transitionY ? Std.parseInt(fast.att.transitionY) : 0;
					transition = Slide(tx, ty);
				case "fade":
					var tc = fast.has.transitionColor ? Color.colors[fast.att.transitionColor] : bgColor;
					transition = Fade(tc);
			}
		}
		if (fast.has.transitionTime)
			transitionTime = UIUnit.value(fast.att.transitionTime);

		// parse entities
		var entityTracker = {entityList:entities, entityMap:entityMap, counter:0};
		parseEntities(sceneNode, entityTracker, this);

		for (entity in entities) add(entity);
	}

	function parseEntities(node:Xml, entityTracker:EntityTracker, parent:UIObject)
	{
		for (child in node.elements())
		{
			var fast = new Fast(child);
			var e:UIEntity = null;

			if (UI.entityTypes.exists(child.nodeName))
			{
				e = UI.entityTypes[child.nodeName](fast, parent);
			}
			else
			{
				throw "Unrecognized node type: " + child.nodeName;
			}

			if (e != null)
			{
				if (fast.has.padding) e.padding = UIUnit.value(fast.att.padding);
				e.paddingTop += fast.has.paddingTop ? UIUnit.value(fast.att.paddingTop, parent.height) : 0;
				e.paddingBottom += fast.has.paddingBottom ? UIUnit.value(fast.att.paddingBottom, parent.height) : 0;
				e.paddingLeft += fast.has.paddingLeft ? UIUnit.value(fast.att.paddingLeft, parent.width) : 0;
				e.paddingRight += fast.has.paddingRight ? UIUnit.value(fast.att.paddingRight, parent.width) : 0;

				var x:Float = 0;
				var y:Float = 0;
				if (fast.has.x)
					x = UIUnit.value(fast.att.x, parent.width);
				else if (fast.has.right)
					x = parent.width - UIUnit.value(fast.att.right, parent.width) - parent.paddingLeft - parent.paddingRight - e.width;
				if (fast.has.y)
					y = UIUnit.value(fast.att.y, parent.height);
				else if (fast.has.bottom)
					y = parent.height - UIUnit.value(fast.att.bottom, parent.height) - parent.paddingTop - parent.paddingBottom - e.height;
				parent.addChild(e, x, y);


				e.selectable = fast.has.selectable ? fast.att.selectable == 'true' : false;
				e.visible = fast.has.visible ? fast.att.visible == 'true' : true;

				var id = fast.has.id ? fast.att.id : Std.string(++entityTracker.counter);
				entityTracker.entityList.push(e);
				entityTracker.entityMap[id] = e;
				e.id = id;

				parseEntities(child, entityTracker, e);
			}
		}
	}

	public var width:Int = HXP.width;
	public var height:Int = HXP.height;

	public var paddingTop:Float = 0;
	public var paddingBottom:Float = 0;
	public var paddingLeft:Float = 0;
	public var paddingRight:Float = 0;
	public var padding(never, set):Float;
	function set_padding(p:Float)
	{
		return paddingTop = paddingBottom = paddingLeft = paddingRight = p;
	}

	var _worldX:Float = 0;
	var _worldY:Float = 0;
	public var worldX(get, set):Float;
	function get_worldX() return _worldX;
	function set_worldX(x:Float) return _worldX = x;
	public var worldY(get, set):Float;
	function get_worldY() return _worldY;
	function set_worldY(y:Float) return _worldY = y;

	public var availableWidth(get, never):Float;
	public var availableHeight(get, never):Float;
	function get_availableWidth()
	{
		return HXP.width - paddingLeft - paddingRight;
	}
	function get_availableHeight()
	{
		return HXP.height - paddingTop - paddingBottom;
	}


	static inline var DEFAULT_TRANSITION_TIME=0.5;
	static inline var DEFAULT_TRANSITION_WAIT=0;
	static inline var POPUP_TIME=0.25;

	public var bgColor(default, set):Color = Color.Black;
	function set_bgColor(c:Color)
	{
		if (HXP.scene == this) HXP.screen.color = c;
		return bgColor = c;
	}

	public var mouseOver:UIEntity;
	public var clicked:UIEntity;
	public var selected(default, set):UIEntity;
	function set_selected(e:UIEntity)
	{
		selected = e;
		if (e != null)
			onSelected(e);
		return e;
	}
	public var tabOrder:Array<UIEntity>;
	public var transition(default, set):Transition = Transition.Fade(Color.Black);
	function set_transition(t:Transition)
	{
		overlay = null;
		return transition = t;
	}
	public var transitionTime:Float = DEFAULT_TRANSITION_TIME;
	public var transitionWait:Float = DEFAULT_TRANSITION_WAIT;
	public var prevScene:UIScene = null;
	public var nextScene(default, set):UIScene = null;
	function set_nextScene(s:UIScene)
	{
		//if (s != null && s == prevScene) s.restart();
		return nextScene = s;
	}
	public var transitionFunc:Null<(Void -> Bool)> = null;
	var transitionProgress:Float = -1;
	var transitionBackwards:Bool = false;
	var transitionWaited:Float = 0;
	var overlay:Null<Color>;

	var currentPopup:Entity;
	var popupProgress:Float = 0;

	var updating(get, never):Bool;
	function get_updating()
	{
		return transitionProgress == 0 && currentPopup == null && popupProgress == 0 && nextScene == null && transitionFunc == null;
	}

	override public function begin()
	{
		super.begin();

		transitionProgress = -1;
		transitionBackwards = false;
		transitionWaited = 0;
		nextScene = null;

		transitionIn(false);
		Key.keyStringSuppressKeyEvent = false;
		HXP.screen.color = bgColor;
	}

	override public function update()
	{
		if (transitionProgress == 0)
		{
			if (Platform.mobile && !Mouse.mousePressed) mouseOver = null
			else mouseOver = cast collidePoint("ui", Mouse.mouseX + HXP.camera.x, Mouse.mouseY + HXP.camera.y);

			clicked = Mouse.mousePressed ? mouseOver : null;
			if (clicked != null) selected = clicked;
			if (Mouse.mousePressed && (mouseOver == null)) clicked = selected = null;
		}

		if (transitionProgress < 0)
		{
			super.update();
			transitionIn();
		}
		else if (nextScene == null && transitionFunc == null)
		{
			super.update();
		}
		else
		{
			super.update();
			transitionOut();
		}
	}

	function transitionIn(advance:Bool=true)
	{
		if (advance) transitionProgress = Math.min(0, transitionProgress + HXP.elapsed/transitionTime);

		switch(transition)
		{
			case Transition.Slide(x, y):
				HXP.camera.x = Std.int(HXP.width * x * transitionProgress * -1);
				HXP.camera.y = Std.int(HXP.height * y * transitionProgress * -1);

			case Transition.Fade(c):
				overlay = c;
		}
	}

	function transitionOut()
	{
		if (transitionProgress >= 1)
		{
			if (transitionWaited >= 1)
			{
				if (nextScene != null)
					HXP.scene = nextScene;
				else if (transitionFunc != null)
				{
					if (transitionFunc())
					{
						transitionFunc = null;
						transitionProgress = -1;
						transitionWaited = 0;
					}
				}
			}
			else
			{
				transitionWaited += HXP.elapsed / transitionWait;
			}
			return;
		}

		transitionProgress = Math.min(1, transitionProgress + HXP.elapsed/transitionTime);

		switch(transition)
		{
			case Transition.Slide(x, y):
				var b = (transitionBackwards ? -1 : 1);
				HXP.camera.x = Std.int(HXP.width * x * transitionProgress * -1 * b);
				HXP.camera.y = Std.int(HXP.height * y * transitionProgress * -1 * b);

			case Transition.Fade(c):
				overlay = c;
		}
	}

	/**
	 * Performed by the game loop, renders all contained Entities.
	 * If you override this to give your Scene render code, remember
	 * to call super.render() or your Entities will not be rendered.
	 */
	override public function render()
	{
#if hardware
		AtlasData.startScene(this);
#end

		// render the entities in order of depth
		for (layer in _layerList)
		{
			if (!layerVisible(layer)) continue;
			for (e in _layers.get(layer))
			{
				if (e.visible) e.render();
			}
		}

		if (overlay != null)
		{
			drawOverlay(haxepop.utils.Math.clamp(Math.abs(transitionProgress), 0, 1));
		}

		HXP.drawCursor();

		// draw scene overlays
		for (overlay in overlays) overlay.render();

#if hardware
		AtlasData.active = null; // forces the last active atlas to flush
#end
	}

	function drawOverlay(alpha:Float)
	{
		if (overlay != null && alpha > 0)
		{
			Draw.rect(HXP.screen.x, HXP.screen.y, HXP.screen.width, HXP.screen.height, overlay, alpha, true);
		}
	}

	public function onSelected(e:UIEntity)
	{
	}

	function tabSwap(dir:Int=1)
	{
		var i = (tabOrder.indexOf(selected) + dir);
		if (dir < 0 && i < 0)
			i = tabOrder.length - 1;
		i %= tabOrder.length;
		selected = tabOrder[i];
	}

	public function addUIGraphic(g:Graphic):UIEntity
	{
		var e = new UIEntity(g, false);

		var instanceFields = Type.getInstanceFields(Type.getClass(g));
		if (instanceFields.indexOf("width") > -1)
			e.width = Reflect.getProperty(g, "width");
		if (instanceFields.indexOf("height") > -1)
			e.height = Reflect.getProperty(g, "height");
		if (instanceFields.indexOf("paddingTop") > -1)
			e.paddingTop = Reflect.getProperty(g, "paddingTop");
		if (instanceFields.indexOf("paddingBottom") > -1)
			e.paddingBottom = Reflect.getProperty(g, "paddingBottom");
		if (instanceFields.indexOf("paddingLeft") > -1)
			e.paddingLeft = Reflect.getProperty(g, "paddingLeft");
		if (instanceFields.indexOf("paddingRight") > -1)
			e.paddingRight = Reflect.getProperty(g, "paddingRight");

		e.setParent(this);
		return add(e);
	}

	public function addChild(child:UIEntity, ?localX:Float=0, ?localY:Float=0)
	{
		child.parent = this;
		child.localX = localX;
		child.localY = localY;
	}
}
