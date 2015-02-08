package haxepop.ui;


@:enum
abstract Color(Int) from Int to Int
{
	var White = 0xFFFFFF;
	var Offwhite = 0xE0E0E0;
	var Grey = 0xA0A0A0;
	var Black = 0x000000;
	var Red = 0xFF0000;
	var Blue = 0x000080;
	var Green = 0x00FF00;
	var Yellow = 0xFFFF00;
	var Orange = 0xFFa500;
	var Cyan = 0x00F0F0;
	var Gold = 0xBBAA88;

	public static var colors:Map<String, Color> = [
		"white" => White,
		"offwhite" => Offwhite,
		"grey" => Grey,
		"black" => Black,
		"red" => Red,
		"blue" => Blue,
		"green" => Green,
		"yellow" => Yellow,
		"orange" => Orange,
		"cyan" => Cyan,
		"gold" => Gold,
	];
}
