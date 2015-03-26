package haxepop.ui.entities;

import haxepop.graphics.Image;
import haxepop.ui.UIEntity;


class Img extends UIEntity
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var width:Null<Float> = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : null,
			height:Null<Float> = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : null;
		var center = fast.has.center ? Unit.boolOptions(fast.att.center) : false;

		var img = new Image(fast.att.src);
		if (center) img.centerOrigin();

		var e = new Img(img);
		e.width = Std.int(width == null ? (height == null ? img.width : img.width * e.height / img.height) : width);
		e.height = Std.int(height == null ? (width == null ? img.height : img.height * e.width / img.width) : height);
		img.scaleX = e.width / img.width;
		img.scaleY = e.height / img.height;

		return e;
	}

	public var image:Image;

	override public function new(image:Image)
	{
		super(image);
		this.image = image;
	}
}
