package haxepop.ui.graphics;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxepop.HXP;
import haxepop.Graphic;
import haxepop.Camera;
import haxepop.graphics.Spritemap;
import haxepop.graphics.Graphiclist;


class VScrollBarGraphic extends Graphiclist
{
	var topImg:Spritemap;
	var midImg:Spritemap;
	var btmImg:Spritemap;

	public var height(default, set):Float;
	function set_height(h:Float)
	{
		var midHeight = Std.int(h - topImg.height - btmImg.height);
		midImg.scaleY = midHeight / midImg.height;
		btmImg.y = topImg.height + midHeight;
		return height = h;
	}

	public var alpha(default, set):Float = 1;
	function set_alpha(a:Float)
	{
		return topImg.alpha = midImg.alpha = btmImg.alpha = alpha = a;
	}

	public function new(source:TileType, tileWidth:Int, tileHeight:Int, ?topTile:Int=0, ?midTile:Int=1, ?btmTile:Int=2)
	{
		super();

		topImg = new Spritemap(source, tileWidth, tileHeight);
		topImg.frame = topTile;
		add(topImg);

		midImg = new Spritemap(source, tileWidth, tileHeight);
		midImg.y = tileHeight;
		midImg.frame = midTile;
		add(midImg);

		btmImg = new Spritemap(source, tileWidth, tileHeight);
		btmImg.y = tileHeight*2;
		btmImg.frame = btmTile;
		add(btmImg);
	}
}
