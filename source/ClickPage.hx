import flixel.util.FlxSave;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextAlign;
import zero.flixel.ui.BitmapText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class ClickPage extends FlxState {

	override function create() {
		super.create();
		FlxG.mouse.visible = true;
		var s = new FlxSprite(0, 0);
		s.loadGraphic('assets/images/chicken.png', true, 16, 16);
		s.animation.add('play', [0, 1], 8);
		s.animation.play('play');
		s.setPosition(FlxG.width - 32, FlxG.height - 32);
		add(s);

		var text = new BitmapText({
            position: FlxPoint.get(FlxG.width - 192, FlxG.height - 24), 
            charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@',
            letter_size: FlxPoint.get(7, 7), 
            graphic: 'assets/images/alphabet.png',
		});
		text.text = 'CLICK ANYWHERE TO PLAY';
		add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		#if debug if (FlxG.keys.justPressed.R) reset(); #end
		if (!FlxG.mouse.justPressed) return;
		FlxG.switchState(new Title());
	}

	function reset() {
		var save = new FlxSave();
		save.bind('escape_hatch_cmg');
		save.data.level = -1;
		save.flush();
		trace('reset');
	}

}