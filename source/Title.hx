import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxState;
//import zerolib.ZBitmapText;
//import zero.flixel.
import zero.flixel.ui.BitmapText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextAlign;
import flixel.system.FlxSound;

class Title extends FlxState
{

	var graphic:FlxSprite;
	var start_text:BitmapText;
	var under_layer:FlxGroup;

	override public function create()
	{
		FlxG.sound.play('assets/sounds/title.mp3');

		under_layer = new FlxGroup();
		add(under_layer);

		graphic = new FlxSprite(0, 12);
		graphic.loadGraphic('assets/images/title.png', true, 256, 224);
		graphic.alpha = 0;
		add(graphic);
		FlxTween.tween(graphic, {alpha:1}, 0.5);

		var red:FlxSprite = new FlxSprite();
		red.makeGraphic(256, 244, 0xffff004d);
		FlxSpriteUtil.flicker(red,0);
		red.alpha = 0;
		under_layer.add(red);
		FlxTween.tween(red, {alpha:1}, 1);
		FlxTween.tween(red.scale, {y:0}, 2).onComplete = function(t:FlxTween)
		{
			FlxG.camera.flash(0xffffffff, 0.1);
			graphic.animation.frameIndex = 1;
			red.kill();

			start_text = new BitmapText({
				//16, 200, ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@', FlxPoint.get(7, 7), 'assets/images/alphabet.png', FlxTextAlign.CENTER, Std.int(FlxG.width - 32));
				charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@',
				position: FlxPoint.get(16, 200),
				graphic: 'assets/images/alphabet.png',
				align: FlxTextAlign.CENTER,
				letter_size: FlxPoint.get(7, 7),
				width: FlxG.width - 32
			});
			start_text.text = 'press x + c'.toUpperCase();
			start_text.color = 0xffff004d;
			add(start_text);
			FlxSpriteUtil.flicker(start_text, 0, 0.5);
		}

	}

	override public function update(e)
	{
		super.update(e);

		if (FlxG.keys.pressed.X && FlxG.keys.pressed.C) start_game();
	}

	function start_game()
	{
		CMGAPI.event(START);
		FlxG.sound.playMusic('assets/music/level.mp3', 1, true);
		FlxG.switchState(new PlayState());
	}

}