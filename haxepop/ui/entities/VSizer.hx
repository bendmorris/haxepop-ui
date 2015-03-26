package haxepop.ui.entities;


class VSizer extends Sizer
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var spacing = fast.has.spacing ? Unit.value(fast.att.spacing) : 0;
		var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : parent.availableWidth,
			height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : parent.availableHeight;
		var center = fast.has.center ? Unit.boolOptions(fast.att.center) : false;

		var e = new VSizer(width, height, spacing, center);

		return e;
	}

	public function new(?width:Float=0, ?height:Float=0, ?spacing:Float=0, ?center:Bool=false)
	{
		super(width, height, spacing, center);
		horizontal = false;
	}
}
