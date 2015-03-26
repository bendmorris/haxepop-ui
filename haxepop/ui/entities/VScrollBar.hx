package haxepop.ui.entities;

import haxepop.HXP;
import haxepop.Graphic;
import haxepop.utils.Math;
import haxepop.input.Mouse;
import haxepop.ui.UIEntity;
import haxepop.ui.graphics.VScrollBarGraphic;


class VScrollBar extends UIEntity
{
	static inline var FADE_TIME:Float = 1.5;

	var scroll:VScroll;
	var scrollBar:VScrollBarGraphic;
	var scrolled:Float = 1;

	override function get_visible():Bool return scroll.visible;
	override function get_worldY():Float return localY + (scroll == null ? 0 : (scroll.worldY));

	public function new(parent:VScroll, source:TileType, tileWidth:Int, tileHeight:Int)
	{
		this.scroll = parent;
		scrollBar = new VScrollBarGraphic(source, tileWidth, tileHeight);

		super(scrollBar);

		width = tileWidth;
		parent.addScrollBar(this);
		selectable = true;
	}

	override public function update()
	{
		var parentHeight = scroll.contentSize;
		scrollBar.height = Std.int(scroll.height * Math.clamp(scroll.height / parentHeight, 0, 1));
		height = Std.int(scrollBar.height);

		var newY = Std.int(Math.clamp(-scroll.paddingTop / (parentHeight - scroll.height + scroll.y), 0, 1) * (scroll.height - height));
		if (localY != newY)
		{
			localY = newY;
			scrolled = 1;
		}
		else if (mouseOver)
		{
			scrolled = 1;
		}
		else if (scrolled > 0)
		{
			scrolled -= HXP.elapsed / FADE_TIME;
			if (scrolled <= 0)
			{
				scrolled = 0;
			}
		}

		scrollBar.alpha = Math.min(scrolled * 2, 1);

		super.update();
	}
}
