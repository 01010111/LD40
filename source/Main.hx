package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(256, 224, PreTitle, 2, 60, 60, true));
		FlxG.mouse.visible = false;
	}
}
