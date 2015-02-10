package haxepop.ui.graphics;

import haxepop.Graphic;
import haxepop.graphics.Tilemap;
import haxepop.utils.Math;


class TiledBox extends Tilemap
{
	public function new(tileset:TileType, width:Int, height:Int, tileWidth:Int, tileHeight:Int)
	{
		super(tileset, width, height, tileWidth, tileHeight);

		setTiles();
	}

	public inline function setTiles()
	{
		setTile(0, 0, getIndex(0, 0));
		setTile(columns - 1, 0, getIndex(2, 0));
		setTile(0, rows - 1, getIndex(0, 2));
		setTile(columns - 1, rows - 1, getIndex(2, 2));

		if (columns > 2) {
			for (x in 1 ... columns - 1) {
				setTile(x, 0, getIndex(1, 0));
				setTile(x, rows - 1, getIndex(1, 2));
				if (rows > 2) {
					for (y in 1 ... rows - 1) {
						setTile(x, y, getIndex(4, 1));
					}
				}
			}
		}

		if (rows > 2) {
			for (y in 1 ... rows - 1) {
				setTile(0, y, getIndex(0, 1));
				setTile(columns - 1, y, getIndex(2, 1));
			}
		}
	}
}
