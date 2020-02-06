import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class IntroSubState extends FlxSubState
{

    public function new()
    {
        super();

        for (x in 0...8)
        {
            for (y in 0...7)
            {
                var s = new FlxSprite(x * 32, y * 36);
                s.makeGraphic(32, 36, 0xff000000);
                add(s);

                FlxTween.tween(s.scale, { y:0 }, 0.2, { startDelay: (x + y) * 0.05, ease:FlxEase.quadIn });
                FlxTween.tween(s, { angle:90 }, 0.2, { startDelay: (x + y) * 0.05, ease:FlxEase.quadIn });
            }
        }

        new FlxTimer().start(1).onComplete = function(t:FlxTimer)
        {
            FlxG.state.add(new MiniMap(FlxG.width - 16, 16));
            close();
            PlayState.i.loaded_callback();
        }
    }

}