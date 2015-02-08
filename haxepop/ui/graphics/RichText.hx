package haxepop.ui.graphics;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import haxepop.HXP;
import haxepop.Camera;
import haxepop.graphics.Text;
import haxepop.graphics.BitmapText;
import haxepop.graphics.atlas.AtlasRegion;
import haxepop.graphics.atlas.BitmapFontAtlas;
import haxepop.ui.Color;


@:enum
abstract Tag(String) from String to String
{
	var ColorTag = "color";
	var EndTag = "";
}

/**
 * BitmapText which supports simple formatting tags.
 **/
class RichText extends BitmapText
{
	/**
	 * Loops through the text, drawing each character on each line.
	 * @param renderFunction    Function to render each character.
	 */
	override private function renderFont(?renderFunction:RenderFunction)
	{
		// loop through the text one character at a time, calling the supplied
		// rendering function for each character
		var fontScale = size/_font.fontSize;

		var lineHeight:Int = Std.int(_font.lineHeight + lineSpacing);

		var rx:Int = 0, ry:Int = 0;
		var sx:Float = scale * scaleX * fontScale,
			sy:Float = scale * scaleY * fontScale;

		var literal:Bool = false;
		var tag:String = null;
		var originalColor = this.color;

		for (y in 0 ... lines.length)
		{
			var line = lines[y];

			for (x in 0 ... line.length)
			{
				var letter = line.charAt(x);
				if (!literal)
				{
					if (tag == null)
					{
						switch(letter)
						{
							case '\\':
								literal = true;
								continue;
							case '[':
								tag = "";
								continue;
							case '\r':
								ry += Std.int(lineHeight/2);
								continue;
							default: {}
						}
					}
					else
					{
						if (letter == ']')
						{
							// process tag
							var key:Tag = EndTag;
							var val:String = "";
							if (tag.indexOf('=') > -1)
							{
								var parts = tag.split('=');
								key = cast parts[0];
								val = parts[1].toLowerCase();
							}
							else
							{
								key = cast tag;
							}
							switch(key)
							{
								case ColorTag:
									color = Color.colors[val];
								case EndTag:
									color = originalColor;
							}
							tag = null;
						}
						else
						{
							tag += letter;
						}

						continue;
					}
				}
				literal = false;

				var region = _font.getChar(letter);
				var gd = _font.glyphData.get(letter);

				// if a character isn't in this font, display a space
				if (gd == null)
				{
					letter = ' ';
					gd = _font.glyphData.get(' ');
				}

				if (letter==' ')
				{
					// it's a space, just move the cursor
					rx += Std.int(gd.xAdvance);
				}
				else
				{
					// draw the character
					if (renderFunction != null)
					{
						renderFunction(region, gd,
							(rx + gd.xOffset),
							(ry + gd.yOffset)
						);
					}
					// advance cursor position
					rx += Math.ceil((gd.xAdvance + charSpacing));
					if (width != 0 && rx > width/sx)
					{
						if (Std.int(rx*sx) > textWidth) textWidth = Std.int(rx*sx);
						rx = 0;
						ry += lineHeight;
					}
				}

				// longest line so far
				if (Std.int(rx*sx) > textWidth) textWidth = Std.int(rx*sx);
			}

			// next line
			rx = 0;
			ry += lineHeight;
			if (Std.int(ry*sy) > textHeight) textHeight = Std.int(ry*sy);
		}

		this.color = originalColor;
	}

	/**
	 * Automatically wraps text by figuring out how many words can fit on a
	 * single line, and splitting the remainder onto a new line.
	 */
	override public function wordWrap():Void
	{
		lines = wrapped(text);
	}

	function wrapped(text:String):Array<String>
	{
		// subdivide lines
		var lines = text.split('\n');
		var newLines:Array<String> = [];
		var fontScale = size / _font.fontSize;
		var spaceWidth = _font.glyphData.get(' ').xAdvance * fontScale;

		var literal:Bool = false;
		var tag:Bool = false;

		for (line in lines)
		{
			var subLines:Array<String> = [];
			var words:Array<String> = [];
			// split this line into words
			var thisWord = "";
			for (n in 0 ... line.length)
			{
				var char:String = line.charAt(n);
				switch(char)
				{
					case ' ', '-': {
						words.push(thisWord + char);
						thisWord = "";
					}
					default: {
						thisWord += char;
					}
				}
			}
			if (thisWord != "") words.push(thisWord);
			if (words.length > 1)
			{
				var w:Int = 0, lastBreak:Int = 0, lineWidth:Float = 0;
				while (w < words.length)
				{
					var wordWidth:Float = 0;
					var word = words[w];
					for (letter in word.split(''))
					{
						if (tag)
						{
							if (letter == ']')
							{
								tag = false;
								continue;
							}
						}
						else
						{
							switch (letter)
							{
								case '\\':
									if (!literal)
									{
										literal = true;
										continue;
									}
								case '\r':
									continue;
								case '[':
									tag = true;
									continue;
								default: {}
							}
							var letterWidth = _font.glyphData.exists(letter) ?
								_font.glyphData.get(letter).xAdvance : 0;
							wordWidth += (letterWidth + charSpacing) * fontScale;
							literal = false;
						}
					}
					lineWidth += wordWidth;
					// if the word ends in a space, don't count that last space
					// toward the line length for determining overflow
					var endsInSpace = word.charAt(word.length - 1) == ' ';
					if ((lineWidth - (endsInSpace ? spaceWidth : 0)) > width)
					{
						// line is too long; split it before this word
						subLines.push(words.slice(lastBreak, w).join(''));
						lineWidth = wordWidth;
						lastBreak = w;
					}
					w += 1;
				}
				subLines.push(words.slice(lastBreak).join(''));
			}
			else
			{
				subLines.push(line);
			}

			for (subline in subLines)
			{
				newLines.push(subline);
			}
		}

		return newLines;
	}

	override public function updateBuffer(?oldLines:Array<String>)
	{
		var oldColor = _colorTransform;
		var oldAlpha = alpha;
		_colorTransform = new ColorTransform();
		alpha = 1;

		super.updateBuffer(oldLines);

		_colorTransform = oldColor;
		alpha = oldAlpha;
	}

	override function drawToBuffer(region:AtlasRegion,gd:GlyphData,x:Float,y:Float)
	{
		_matrix.b = _matrix.c = 0;
		_matrix.a = _matrix.d = 1;
		_matrix.tx = x - gd.rect.x;
		_matrix.ty = y - gd.rect.y;
		_rect.x = x;
		_rect.y = y;
		_rect.width = gd.rect.width;
		_rect.height = gd.rect.height;

		_buffer.draw(_set, _matrix, _colorTransform, null, _rect, false);
	}
}
