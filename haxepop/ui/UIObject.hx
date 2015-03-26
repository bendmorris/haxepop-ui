package haxepop.ui;


interface UIObject
{
	public var width:Int;
	public var height:Int;

	public var visible(get, set):Bool;

	public var worldX(get, set):Float;
	public var worldY(get, set):Float;

	public var paddingTop:Float;
	public var paddingBottom:Float;
	public var paddingLeft:Float;
	public var paddingRight:Float;
	public var padding(never, set):Float;

	public var availableWidth(get, never):Float;
	public var availableHeight(get, never):Float;

	public function addChild(child:UIEntity, ?localX:Float=0, ?localY:Float=0):Void;
}
