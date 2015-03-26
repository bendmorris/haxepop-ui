package haxepop.ui.entities;

import haxepop.Graphic;
import haxepop.ui.graphics.TiledBox;
import haxepop.ui.graphics.ScaledBox;


class Box extends UIEntity
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var source = fast.att.src;
		var width = Std.int(fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth),
			height = Std.int(fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight);
		var scale = fast.has.scale ? Unit.value(fast.att.scale) : 1;

		var e:UIEntity;
		if (fast.has.tileWidth && fast.has.tileHeight)
		{
			var tileWidth = Std.int(Unit.value(fast.att.tileWidth)),
				tileHeight = Std.int(Unit.value(fast.att.tileHeight));

			e = tiled(source, width, height, tileWidth, tileHeight, scale);
		}
		else if (fast.has.widthLeft && fast.has.widthRight &&
			fast.has.heightTop && fast.has.heightBottom)
		{
			var widthLeft = Std.int(Unit.value(fast.att.widthLeft)),
				widthRight = Std.int(Unit.value(fast.att.widthRight)),
				heightTop = Std.int(Unit.value(fast.att.heightTop)),
				heightBottom = Std.int(Unit.value(fast.att.heightBottom));

			e = scaled(source, width, height, widthLeft, widthRight, heightTop, heightBottom, scale);
		}
		else throw "Box should be either a tiled (tileWidth/tileHeight) or scaled (widthLeft/widthRight/heightTop/heightBottom) box.";

		return e;
	}

	public static function tiled(tileset:String, width:Int, height:Int, tileWidth:Int, tileHeight:Int, ?scale:Float=1)
	{
		var originalWidth = width;
		var originalHeight = height;
		width = Std.int(width / tileWidth) * tileWidth;
		height = Std.int(height / tileHeight) * tileHeight;

		var tiledBox = new TiledBox(tileset, width, height, tileWidth, tileHeight, scale);

		var box = new Box(tiledBox);

		tiledBox.x = (originalWidth - width) / 2;
		tiledBox.y = (originalHeight - height) / 2;

		box.width = originalWidth;
		box.height = originalHeight;

		return box;
	}

	public static function scaled(source:String, width:Int, height:Int, widthLeft:Int, widthRight:Int, heightTop:Int, heightBottom:Int, ?scale:Float=1)
	{
		var scaledBox = new ScaledBox(source, width, height, widthLeft, widthRight, heightTop, heightBottom, scale);
		var box = new Box(scaledBox);

		box.width = width;
		box.height = height;

		return box;
	}

	function new(g:Graphic) super(g);
}
