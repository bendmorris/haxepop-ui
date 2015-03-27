package haxepop.ui.entities;

import haxepop.ui.UIEntity;
import haxepop.ui.graphics.RichText;


class Label extends UIEntity
{
	public static function parse(fast:haxe.xml.Fast, parent:haxepop.ui.UIObject)
	{
		var text = fast.has.text ? fast.att.text : null;
		if (text == null)
		{
			try
			{
				text = fast.innerData;
			}
			catch (e:Dynamic) text = "";
		}
		var color = fast.has.color ? Color.colors[fast.att.color] : Color.Black;
		var wordWrap = fast.has.wordWrap ? Unit.boolOptions(fast.att.wordWrap) : false;
		var size = fast.has.size ? Unit.value(fast.att.size) : 1;
		var width = fast.has.width ? Unit.value(fast.att.width, parent.availableWidth) : 0,
			height = fast.has.height ? Unit.value(fast.att.height, parent.availableHeight) : 0;
		var font = fast.att.font;
		var size = Std.int(fast.has.size ? Unit.value(fast.att.size) : 12);

		var label = new RichText(text, 0, 0, width, height, {font: font, size: size, color: color, wordWrap: wordWrap});
		label.computeTextSize();

		var e = new Label(label);
		if (!fast.has.width)
			e.width = label.textWidth;
		if (!fast.has.height)
			e.height = label.textHeight;

		return e;
	}

	public var label:RichText;

	public var text(get, set):String;
	function get_text() return label.text;
	function set_text(text:String) return label.text = text;

	override public function new(label:RichText)
	{
		super(label);
		this.label = label;
	}
}
