import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class Chicken extends GameSprite
{

    var laying:Bool = false;
    var stunned:Bool = false;
    public static var age:Int = 0;

    var egg_timer:Float = 0;
    var stun_timer:Int = 0;

    public function new(p:FlxPoint)
    {
        super();
        loadGraphic('assets/images/chicken.png', true, 16, 16);
        make_anchored_hitbox(12, 6);
        setPosition(p.x + 2, p.y + 5);

        animation.add('1_idle', [1]);
        animation.add('1_walk', [0, 1]);
        animation.add('1_stun', [2]);
        animation.add('2_idle', [5]);
        animation.add('2_walk', [3, 4, 5, 6, 5, 4]);
        animation.add('2_stun', [7]);
        animation.add('3_idle', [10]);
        animation.add('3_walk', [8, 9, 10, 11, 10, 9]);
        animation.add('3__lay', [12, 13, 14, 13]);
        animation.add('3_stun', [15]);

        set_facing_flip_horizontal(true);

        type = 'chicken';
    }

    override public function update(e)
    {
        controls();
        animations();
        super.update(e);
        if (!isOnScreen()) PlayState.i.win();
    }

    function controls()
    {
        velocity.set();

        if (Chicken.age == 3) lay_check();

        if (laying || stun_timer > 0) return;

        var speed = FlxG.keys.pressed.X && Chicken.age > 1 ? FlxPoint.get(120, 120) : FlxPoint.get(60, 60);
        var delta = FlxPoint.get();

        if (FlxG.keys.pressed.UP)       delta.y -= 1;
        if (FlxG.keys.pressed.DOWN)     delta.y += 1;
        if (FlxG.keys.pressed.LEFT)     delta.x -= 1;
        if (FlxG.keys.pressed.RIGHT)    delta.x += 1;

        velocity.set(delta.x * speed.x, delta.y * speed.y);
    }

    function lay_check()
    {
        laying = false;
        if (FlxG.keys.justPressed.C) egg_timer = 60;
        if (FlxG.keys.pressed.C && egg_timer > 0)
        {
            laying = true;
            egg_timer--;
            if (egg_timer == 0) lay_egg();
        }
    }

    function lay_egg()
    {
        FlxG.sound.play('assets/sounds/bok.mp3');
        stun_timer = 15;
        var eggp = getMidpoint();
        eggp.x += facing == FlxObject.RIGHT ? -8 : 8;
        PlayState.i.add_egg(eggp, true);
        for (object in PlayState.i.objects)
        {
            object.alert();
        }
    }

    function animations()
    {
        if (laying) 
        {
            animation.play('3__lay');
            return;
        }
        if (stun_timer > 0)
        {
            stun_timer--;
            animation.play('' + Chicken.age + '_stun');
            return;
        }
        if (velocity.x == 0 && velocity.y == 0) animation.play('' + Chicken.age + '_idle');
        else 
        {
            animation.play('' + Chicken.age + '_walk');
            animation.curAnim.frameRate = Std.int(Math.max(Math.abs(velocity.x), Math.abs(velocity.y)) / 3);
        }
        if (velocity.x > 0) facing = FlxObject.RIGHT;
        if (velocity.x < 0) facing = FlxObject.LEFT;
    }

}