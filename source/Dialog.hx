//import zerolib.BitmapText;
import zero.flixel.ui.BitmapText;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Dialog extends FlxSubState
{

    var bg:FlxSprite;
    var text:BitmapText;
    var t1:String = '';
    var t2:String;
    var can_type:Bool = false;

    public function new(_text:String)
    {
        super();

        bg = new FlxSprite(32, 24);
        bg.makeGraphic(FlxG.width - 64, 64, 0x00ffffff);
        FlxSpriteUtil.drawRect(bg, 0, 0, bg.width, bg.height, 0xff000000);
        FlxSpriteUtil.drawRect(bg, 2, 2, bg.width - 4, bg.height - 4, 0xff29adff);
        FlxSpriteUtil.drawRect(bg, 4, 4, bg.width - 8, bg.height - 8, 0xff000000);
        bg.scrollFactor.set();
        add(bg);

        bg.scale.y = 0;
        FlxTween.tween(bg.scale, {y:1}, 0.1).onComplete = function(t:FlxTween)
        {
            can_type = true;
        }

        text = new BitmapText({
            position: FlxPoint.get(bg.x + 16, bg.y + 16), 
            charset: ' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:/%?!,"-_+=()@',
            letter_size: FlxPoint.get(7, 7), 
            graphic: 'assets/images/alphabet.png', 
            width: Std.int(bg.width - 32)
        });
        add(text);

        t2 = _text.toUpperCase();
    }

    override public function update(e)
    {
        super.update(e);
        if (FlxG.keys.justPressed.ANY)
        {
            if (t1.length == t2.length) close();
            else t1 = t2;
        }
        if (can_type) t1 = t2.substr(0, t1.length + 1);
        text.text = t1;
    }

}