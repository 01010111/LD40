import zerolib.ZBitmapText;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class WinSubState extends FlxSubState
{

    var type_timer:Int = 5;
    var text:ZBitmapText;
    var t1:String = '';
    var t2:String = 'hey snake...\ndo you think eggs can hatch...\neven on a battlefield?';
    var can_type:Bool = true;

    public function new()
    {
        super(0xff000000);

        text = new ZBitmapText(16, 100, ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@', FlxPoint.get(7, 7), 'assets/images/alphabet.png', null, Std.int(FlxG.width - 32));
        add(text);

        new FlxTimer().start(10).onComplete = function(t:FlxTimer){
            FlxTween.tween(text, {alpha:0}, 2);
            
            var t = new ZBitmapText(16, 200, ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@', FlxPoint.get(7, 7), 'assets/images/alphabet.png', null, Std.int(FlxG.width - 32));
            t.text = 'THANKS FOR PLAYING!\n@X01010111 2017';
            t.color = 0xffff004d;
            t.alpha = 0;
            add(t);
            FlxTween.tween(t, {alpha:1}, 8);
        }

        t2 = t2.toUpperCase();
    }

    override public function update(e)
    {
        super.update(e);
        if (!can_type) return;
        if (type_timer == 0)
        {
            type_timer = 5;

            t1 = t2.substr(0, t1.length + 1);
            if (t2.charAt(t1.length) == '.')
            {
                can_type = false;
                new FlxTimer().start(0.5).onComplete = function(t:FlxTimer) { can_type = true; }
            }
            text.text = t1;
        }
        else type_timer--;
    }

}