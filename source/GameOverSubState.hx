import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class GameOverSubState extends FlxSubState
{

    public function new(win:Bool)
    {
        var c = win ? 0x00000000 : 0xff000000;
        super(c);

        if (win) do_win();
        else do_lose();
    }

    function do_win()
    {
        var s = new FlxSprite(-FlxG.width, 0);
        s.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        add(s);

        FlxTween.tween(s, {x:0}, 0.2).onComplete = function(t:FlxTween){
            FlxG.switchState(new PlayState());
        }
    }

    function do_lose()
    {
        FlxG.sound.music.stop();

        FlxG.sound.play('assets/sounds/bok.mp3');
        FlxG.sound.play('assets/sounds/gameover.mp3');

        var f = new FlashingScreen();
        add(f);

        var p = PlayState.i.chicken.getMidpoint();
        var c = new FlxSprite();
        c.loadGraphic('assets/images/chicken.png', true, 16, 16);
        c.setPosition(p.x - 8, p.y - 10);
        var i = 2;
        if (Chicken.age == 2) i = 7;
        if (Chicken.age == 3) i = 15;
        c.animation.frameIndex = i;
        c.scale.x = PlayState.i.chicken.facing == FlxObject.LEFT ? -1 : 1;
        add(c);

        new FlxTimer().start(1).onComplete = function(t:FlxTimer)
        {
            FlxTween.tween(f, {alpha:0}, 0.2);
            FlxTween.tween(c, {alpha:0}, 0.2).onComplete = function(t:FlxTween)
            {
                FlxG.sound.playMusic('assets/music/level.mp3', 1, true);
                FlxG.resetState();
            }
        }
    }

}

class FlashingScreen extends FlxSprite
{

    var colors = [
        0xfffff1e8,
        0xffff004d,
        0xff000000
    ];

    var cur_color = 0;
    var color_timer = 3;

    public function new()
    {
        super();
        makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
        scrollFactor.set();
    }

    override public function update(e)
    {
        super.update(e);

        color = colors[cur_color];
        if (color_timer == 0)
        {
            cur_color = (cur_color + 1) % colors.length;
            color_timer = 3;
        }
        else color_timer--;
    }

}