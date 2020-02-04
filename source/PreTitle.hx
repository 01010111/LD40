import flixel.util.FlxTimer;
import flixel.FlxG;
import zero.utilities.Timer;
import flixel.FlxSprite;

class PreTitle extends zero.flixel.states.State {

	override function create() {
		super.create();
		var s = new FlxSprite(0, 0, 'assets/images/cmg.png');
		s.scale.set(0.5, 0.5);
		s.screenCenter();
		add(s);
		new FlxTimer().start(2, (_) -> FlxG.switchState(new Title()));
	}

}