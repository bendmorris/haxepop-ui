package haxepop.ui;


class UIUnit
{
	public static var units:Map<String, Float> = [
		"px" => 1,
	];

	public static function defineUnit(suffix:String, unitValue:Float)
	{
		units[suffix] = unitValue;
	}

	public static function parse(s:String):Null<Float>
	{
		for (unit in units.keys())
		{
			if (StringTools.endsWith(s, unit))
			{
				var value = Std.parseFloat(s.substr(0, s.length - unit.length));
				if (Math.isNaN(value))
					return value;
			}
		}
		return null;
	}

	public static function value(v:String, ?relative:Float=0):Float
	{
		v = v.toLowerCase();

		if (StringTools.endsWith(v, '%'))
		{
			// percentage of parent's remaining area
			return relative * (Std.parseFloat(v.substr(0, v.length - 1)) / 100);
		}
		else
		{
			// check if this string matches any defined units; otherwise, use pixels
			var value = parse(v);

			if (value == null)
				return Std.parseFloat(v);
			else return value;
		}
	}
}
