package haxepop.ui;

import flash.geom.Rectangle;
import haxepop.HXP;
import haxepop.Entity;
import haxepop.Input;
import haxepop.utils.Math;
import haxepop.input.Mouse;


class UIEntity extends Entity implements UIObject
{
	public var id:String;
	public var value:Null<Dynamic>;

	public var showHand:Bool = true;
	public var handOffsetX:Int = 0;
	public var handOffsetY:Int = 0;

	public var parent:UIObject;
	public var children:Array<UIEntity> = new Array();

	override function get_visible():Bool
	{
		return visible && (parent == null || parent.visible);
	}

	public var paddingTop:Float = 0;
	public var paddingBottom:Float = 0;
	public var paddingLeft:Float = 0;
	public var paddingRight:Float = 0;
	public var padding(never, set):Float;
	function set_padding(p:Float) return paddingTop = paddingBottom = paddingLeft = paddingRight = p;

	public var localX:Float = 0;
	public var localY:Float = 0;

	public var worldX(get, set):Float;
	function get_worldX():Float return localX + (parent == null ? 0 : (parent.worldX + parent.paddingLeft));
	inline function set_worldX(x:Float) return localX = x - (parent.worldX + parent.paddingLeft);
	public var worldY(get, set):Float;
	function get_worldY():Float return localY + (parent == null ? 0 : (parent.worldY + parent.paddingTop));
	inline function set_worldY(y:Float) return localY = y - (parent.worldY + parent.paddingTop);

	public var availableWidth(get, never):Float;
	public var availableHeight(get, never):Float;
	function get_availableWidth() return width - paddingLeft - paddingRight;
	function get_availableHeight() return height - paddingTop - paddingBottom;

	override function get_x():Float return worldX + (followCamera ? HXP.camera.x : 0);
	override function set_x(x:Float):Float return localX = x;
	override function get_y():Float return worldY + (followCamera ? HXP.camera.y : 0);
	override function set_y(y:Float):Float return localY = y;

	override function get_top():Float return localY;
	override function set_top(y:Float):Float return localY = y;
	override function get_bottom():Float return localY + height;
	override function set_bottom(y:Float):Float return localY = (parent == null ? height : (parent.height - parent.paddingBottom - parent.paddingTop)) - y - height;
	override function get_left():Float return localX;
	override function set_left(x:Float):Float return localX = x;
	override function get_right():Float return localX + width;
	override function set_right(x:Float):Float return localX = (parent == null ? width : (parent.width - parent.paddingRight - parent.paddingLeft)) - x - width;

	public var selectable(default, set):Bool = false;
	function set_selectable(s:Bool)
	{
		type = s ? "ui" : "";
		return selectable = s;
	}

	public function setParent(parent:UIObject, ?localX:Float=0, ?localY:Float=0)
	{
		parent.addChild(this, localX, localY);
	}

	public function addChild(child:UIEntity, ?localX:Float=0, ?localY:Float=0)
	{
		child.parent = this;
		child.localX = localX;
		child.localY = localY;
		children.push(child);
	}

	public function clearChildren()
	{
		while (children.length > 0)
		{
			var child = children.pop();
			if (child.scene == scene) scene.remove(child);
		}
	}

	public var mouseOver(get, never):Bool;
	function get_mouseOver()
	{
		return cast(scene, UIScene).mouseOver == this;
	}
	public var mouseOverAbsolute(get, never):Bool;
	function get_mouseOverAbsolute()
	{
		return Mouse.mouseX >= x && Mouse.mouseX <= x + width &&
			Mouse.mouseY >= y && Mouse.mouseY <= y + height;
	}
	public var clicked(get, never):Bool;
	function get_clicked()
	{
		return cast(scene, UIScene).clicked == this;
	}
	public var selected(get, never):Bool;
	function get_selected()
	{
		return cast(scene, UIScene).selected == this;
	}

	public function new(graphic=null, selectable=false)
	{
		super(0, 0, graphic);
		this.selectable = selectable;
	}

	public function apply(f:UIEntity->Void)
	{
		f(this);
		for (child in children)
		{
			child.apply(f);
		}
	}
}
