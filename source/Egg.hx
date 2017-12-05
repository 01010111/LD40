import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import zerolib.ZMath;

class Egg extends GameSprite
{

    var has_chick:Bool;
    var break_timer:Int = 180;
    var offset_holder:FlxPoint;

    public function new(p:FlxPoint, pop_in:Bool = false, _has_chick:Bool = false)
    {
        super();

        has_chick = _has_chick;

        loadGraphic('assets/images/egg.png');
        make_centered_hitbox(2, 2);
        setPosition(p.x, p.y);

        if (pop_in)
        {
            scale.set();
            FlxTween.tween(scale, {x:1,y:1}, 0.2, {ease:FlxEase.backOut});
        }

        type = 'egg';
        offset_holder = FlxPoint.get(offset.x, offset.y);
    }

    override public function update(e)
    {
        super.update(e);

        if (has_chick)
        {
            if (FlxG.keys.pressed.ANY)
            {
                break_timer--;
                offset.set(offset_holder.x + ZMath.randomRange(-1, 1), offset_holder.y + ZMath.randomRange(-1, 1));
                if (break_timer == 0)
                {
                    var p = getMidpoint();
                    p.x -= 8;
                    p.y -= 4;
                    PlayState.i.objects.add(new Chicken(p));
                    kill();
                    new FlxTimer().start(0.5).onComplete = function(t:FlxTimer)
                    {
                        PlayState.i.openSubState(new Dialog('kept u waiting huh?'));
                    }
                }
            }
        }
    }

    override public function kill()
    {
        PlayState.i.splat(getMidpoint());
        super.kill();
    }

}