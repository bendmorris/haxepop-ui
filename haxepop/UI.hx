package haxepop;

import haxepop.ui.UIScene;


class UI
{
	public static function init()
	{
		UIScene.registerEntityType("div", haxepop.ui.UIEntity.parseDiv);
		UIScene.registerEntityType("hsizer", haxepop.ui.HSizer.parse);
		UIScene.registerEntityType("vsizer", haxepop.ui.VSizer.parse);
	}
}
