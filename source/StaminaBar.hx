import flixel.text.FlxText.FlxTextAlign;
import flixel.math.FlxPoint;
import zero.flixel.ui.BitmapText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

class StaminaBar extends flixel.group.FlxGroup {

	var bar:FlxBar;
	public var stamina:Float = 100;
	var wait_time:Float = 0;

	public static var i:StaminaBar;

	public function new() {
		super();
		i = this;
		bar = new FlxBar(8, 8, FlxBarFillDirection.LEFT_TO_RIGHT, 80, 3, this, 'stamina', 0, 100);
		bar.scrollFactor.set(0, 0);
		bar.alpha = Chicken.age > 1 ? 0.75 : 0;
		bar.createGradientBar([0x80000020], [0xFF0080FF, 0xFF00FF80], 1, 0);
		add(bar);

		var text = new BitmapText({
            position: FlxPoint.get(-64, 8), 
            charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@',
            letter_size: FlxPoint.get(7, 7), 
			graphic: 'assets/images/alphabet.png',
			align: FlxTextAlign.LEFT,
		});
		text.text = 'STAMINA';
		text.scale.set(0.5, 0.5);
		text.scrollFactor.set();
		if (Chicken.age > 1) add(text);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (wait_time > 0) wait_time -= elapsed;
		if (wait_time > 0) return;
		if (stamina < 100) stamina += elapsed * 20;
	}

	public function use_stamina() {
		stamina -= 2;
		if (stamina <= 0) wait_time = 2;
	}

	public function has_stamina():Bool {
		return stamina > 0;
	}

}