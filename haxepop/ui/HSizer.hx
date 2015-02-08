package haxepop.ui;


class HSizer extends UISizer
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var spacing = fast.has.spacing ? UIUnit.value(fast.att.spacing) : 0;
		var width = fast.has.width ? UIUnit.value(fast.att.width, parent.availableWidth) : parent.availableWidth,
			height = fast.has.height ? UIUnit.value(fast.att.height, parent.availableHeight) : parent.availableHeight;
		var center = fast.has.center && fast.att.center == 'true';

		var e = new HSizer(width, height, spacing, center);

		return e;
	}

	public function new(?width:Float=0, ?height:Float=0, ?spacing:Float=0, ?center:Bool=false)
		super(width, height, spacing, center);
}
