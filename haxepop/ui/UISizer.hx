package haxepop.ui;

import haxepop.HXP;
import haxepop.utils.Math;


class UISizer extends UIEntity
{
	var spacing:Float = 0;
	var horizontal:Bool = true;
	var center:Bool = false;

	var childSize:Float = 0;

	override function get_availableWidth()
	{
		return width - paddingLeft - paddingRight - (horizontal ? childSize : 0);
	}
	override function get_availableHeight()
	{
		return height - paddingTop - paddingBottom - (horizontal ? 0 : childSize);
	}

	function new(?width:Float=0, ?height:Float=0, ?spacing:Float=0, ?center:Bool=false)
	{
		super();
		this.width = Std.int(width);
		this.height = Std.int(height);
		this.spacing = spacing;
		this.center = center;
	}

	override public function addChild(e:UIEntity, ?localX:Float=0, ?localY:Float=0)
	{
		childSize = Lambda.fold(children, function (a,b) return (horizontal?a.width:a.height)+b, 0);
		if (children.length > 1) childSize += spacing * (children.length - 1);

		var x = localX;
		var y = localY;
		if (horizontal) x += childSize + (children.length > 0 ? spacing : 0);
		else y += childSize + (children.length > 0 ? spacing : 0);

		super.addChild(e, x, y);

		if (horizontal)
		{
			childSize = Std.int(x + e.width);
			height = Math.imax(height, e.height);
			if (center) centerChildren();
		}
		else
		{
			childSize = Std.int(y + e.height);
			width = Math.imax(width, e.width);
			if (center) centerChildren();
		}
	}

	function centerChildren()
	{
		if (horizontal)
		{
			var x = width/2 - childSize/2;
			for (child in children)
			{
				child.x = x;
				child.y = paddingTop + (height - paddingTop - paddingBottom)/2 - child.height/2;
				x += child.width + spacing;
			}
		}
		else
		{
			var y = height/2 - childSize/2;
			for (child in children)
			{
				child.y = y;
				child.x = paddingLeft + (width - paddingLeft - paddingRight)/2 - child.width/2;
				y += child.height + spacing;
			}
		}
	}
}
