package haxepop;

import haxe.xml.Fast;
import haxepop.ui.UIObject;
import haxepop.ui.UIEntity;


typedef EntityParser = Fast -> UIObject -> Null<UIEntity>;

class UI
{
	public static function init()
	{
		registerEntityType("div", haxepop.ui.entities.Div.parse);
		registerEntityType("hsizer", haxepop.ui.entities.HSizer.parse);
		registerEntityType("vsizer", haxepop.ui.entities.VSizer.parse);
		registerEntityType("vscroll", haxepop.ui.entities.VScroll.parse);
		registerEntityType("gridsizer", haxepop.ui.entities.GridSizer.parse);
		registerEntityType("label", haxepop.ui.entities.Label.parse);
		registerEntityType("img", haxepop.ui.entities.Img.parse);
		registerEntityType("box", haxepop.ui.entities.Box.parse);
	}

	public static var entityTypes:Map<String, EntityParser> = new Map();

	/**
	 * This function is called to register XML node types and the corresponding
	 * parser function which will parse them. The parser function will take the
	 * haxe.xml.Fast representation of the XML node and the entity's parent,
	 * and generate a new UIEntity (or null if none.)
	 */
	public static function registerEntityType(name:String, parser:EntityParser)
	{
		entityTypes[name] = parser;
	}
}
