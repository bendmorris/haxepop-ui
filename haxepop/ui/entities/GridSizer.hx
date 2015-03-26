package haxepop.ui.entities;

import haxepop.HXP;
import haxepop.utils.Math;


class GridSizer extends Sizer
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth,
			height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight;
		var cols = fast.has.cols ? Std.parseInt(fast.att.cols) : 1,
			rows = fast.has.height ? Std.parseInt(fast.att.rows) : 1;
		var horizontal = fast.has.orientation ? Unit.options(fast.att.orientation, ["horizontal" => true, "vertical" => false]) : true;

		var e = new GridSizer(width, height, cols, rows, horizontal);

		return e;
	}

	public var rows:Int = 1;
	public var cols:Int = 1;
	public var cellWidth:Int = 0;
	public var cellHeight:Int = 0;

	var cx:Float = 0;
	var cy:Float = 0;

	override function get_availableWidth() return cellWidth;
	override function get_availableHeight() return cellHeight;

	var totalWidth(get, never):Float;
	function get_totalWidth() return width - paddingLeft - paddingRight;
	var totalHeight(get, never):Float;
	function get_totalHeight() return height - paddingTop - paddingBottom;

	function new(?width:Float=0, ?height:Float=0, ?cols:Int=0, ?rows:Int=0, ?horizontal:Bool=true)
	{
		super(width, height);
		this.cols = cols;
		this.rows = rows;
		this.cellWidth = Std.int(totalWidth / cols);
		this.cellHeight = Std.int(totalHeight / rows);
		this.horizontal = horizontal;
	}

	override public function addChild(e:UIEntity, ?localX:Float=0, ?localY:Float=0)
	{
		var cell = new UIEntity();
		cell.width = cellWidth;
		cell.height = cellHeight;

		cell.parent = this;
		cell.localX = cx * cellWidth;
		cell.localY = cy * cellHeight;
		children.push(cell);

		cell.addChild(e);

		if (horizontal)
		{
			width = Std.int(cy > 0 ? cols * cellWidth : (cx + 1) * cellWidth);
			height = Std.int((cy + 1) * cellHeight);
		}
		else
		{
			width = Std.int((cx + 1) * cellWidth);
			height = Std.int((cx > 0) ? rows * cellHeight : (cy + 1) * cellHeight);
		}

		skipCell();
	}

	public function skipCell()
	{
		if (horizontal)
		{
			if (++cx >= cols)
			{
				cx = 0;
				++cy;
			}
		}
		else
		{
			if (++cy >= rows)
			{
				cy = 0;
				++cx;
			}
		}
	}

	override public function clearChildren()
	{
		super.clearChildren();
		cx = cy = 0;
	}
}
