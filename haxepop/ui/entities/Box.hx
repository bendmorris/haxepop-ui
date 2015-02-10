package haxepop.ui.entities;

import haxepop.ui.graphics.TiledBox;


class Box extends UIEntity
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var source = fast.att.src;
		var width = Std.int(fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth),
			height = Std.int(fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight);
		var tileWidth = Std.int(Unit.value(fast.att.tileWidth)),
			tileHeight = Std.int(Unit.value(fast.att.tileHeight));

		var e = new Box(source, width, height, tileWidth, tileHeight);

		return e;
	}

	public function new(tileset:String, width:Int, height:Int, tileWidth:Int, tileHeight:Int)
	{
		var originalWidth = width;
		var originalHeight = height;
		width = Std.int(width / tileWidth) * tileWidth;
		height = Std.int(height / tileHeight) * tileHeight;

		var tiledBox = new TiledBox(tileset, width, height, tileWidth, tileHeight);

		super(tiledBox);

		tiledBox.x = (originalWidth - width) / 2;
		tiledBox.y = (originalHeight - height) / 2;

		this.width = originalWidth;
		this.height = originalHeight;
	}
}
