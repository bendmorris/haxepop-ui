package haxepop.ui.entities;

import haxepop.ui.UIEntity;


class Div extends UIEntity
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth,
			height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight;
		if (width == 0) width = parent.availableWidth;
		if (height == 0) height = parent.availableHeight;

		var e = new Div();
		e.width = Std.int(width);
		e.height = Std.int(height);

		return e;
	}
}
