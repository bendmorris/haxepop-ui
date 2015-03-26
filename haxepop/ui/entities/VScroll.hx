package haxepop.ui.entities;

import haxepop.HXP;
import haxepop.utils.Math;
import haxepop.input.Mouse;


class VScroll extends VSizer
{
	static inline var gradualScroll = 2;

	var scrollSpeed:Float = 1;
	var goalPaddingTop:Int = 0;
	var scrollBar:VScrollBar;

	public var contentSize(get, never):Float;
	function get_contentSize()
	{
		var childSize = Lambda.fold(children, function (a,b) return (horizontal?a.width:a.height)+b, 0);
		if (children.length > 0) childSize += Std.int(spacing * (children.length - 1));
		return childSize;
	}

	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var spacing = fast.has.spacing ? Unit.value(fast.att.spacing) : 0;
		var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth,
			height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight;
		var center = fast.has.center ? Unit.boolOptions(fast.att.center) : false;
		var scrollSpeed = fast.has.scrollSpeed ? Unit.value(fast.att.scrollSpeed, parent.availableHeight) : 1;

		var e = new VScroll(width, height, spacing, center, scrollSpeed);

		if (fast.has.scrollBar)
		{
			var src = fast.att.scrollBar;
			var tileWidth = Std.int(Unit.value(fast.att.scrollBarTileWidth));
			var tileHeight = Std.int(Unit.value(fast.att.scrollBarTileHeight));
			var scrollBar = new VScrollBar(e, src, tileWidth, tileHeight);
		}

		return e;
	}

	public function new(?width:Float=0, ?height:Float=0, ?spacing:Float=0, ?center:Bool=false, ?scrollSpeed:Float=1)
	{
		super(width, height, spacing, center);
		this.scrollSpeed = scrollSpeed;
	}

	override function get_availableHeight()
	{
		return height;
	}

	override public function update()
	{
		if (paddingTop != goalPaddingTop)
		{
			var move = Math.ceil(scrollSpeed * HXP.elapsed * (1 + Math.abs(paddingTop - goalPaddingTop)/gradualScroll));
			if (move >= Math.abs(paddingTop - goalPaddingTop))
				paddingTop = goalPaddingTop;
			else paddingTop += move * (goalPaddingTop > paddingTop ? 1 : -1);
		}
		if (mouseOverAbsolute)
		{
			if (Mouse.mouseWheel)
			{
				scroll(Mouse.mouseWheelDelta);
			}
		}
		// TODO: handle gesture scrolls on mobile

		super.update();
	}

	function scroll(magnitude:Float)
	{
		goalPaddingTop = Std.int(Math.clamp(goalPaddingTop + magnitude * scrollSpeed, Math.min(height - contentSize - y, 0), 0));
	}

	public function addScrollBar(scrollBar:VScrollBar)
	{
		this.scrollBar = scrollBar;
		scrollBar.y = 0;
		scrollBar.x = width - scrollBar.width;
	}

	override public function added()
	{
		super.added();
		if (scrollBar != null) scene.add(scrollBar);
	}

	override public function removed()
	{
		super.removed();
		if (scrollBar != null) scene.remove(scrollBar);
	}
}
