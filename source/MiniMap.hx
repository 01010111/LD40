import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;

class MiniMap extends FlxGroup
{   

    var base:FlxSprite;

    public function new(x:Float, y:Float)
    {
        super();

        base = new FlxSprite(x, y);
        base.makeGraphic(Std.int(PlayState.i.map.width / 8), Std.int(PlayState.i.map.height / 8), 0x00ffffff);
        base.x -= base.width;
        base.scrollFactor.set();
        add(base);

        FlxSpriteUtil.drawRect(base, 0, 0, base.width, base.height, 0x80008751);

        for (y in 0...PlayState.i.map.heightInTiles)
        {
            for (x in 0...PlayState.i.map.widthInTiles)
            {
                var i = PlayState.i.map.getTileByIndex(y * PlayState.i.map.widthInTiles + x);
                if (i >= 1)
                {
                    FlxSpriteUtil.drawRect(base, x * 2, y * 2, 2, 2, 0x8000e756);
                }
            }
        }

        base.alpha = 0.75;
        base.scale.y = 0;

        FlxSpriteUtil.flicker(base);

        FlxTween.tween(base.scale, {y:1}, 1.05).onComplete = function(t:FlxTween)
        {
            add_blips();
        }

    }

    function add_blips()
    {
        for (object in PlayState.i.objects)
        {
            if (object.type == 'egg') return;
            add(new Blip(base.getPosition(), object));
        }
    }

    override public function update(e)
    {
        super.update(e);
    }

}

class Blip extends FlxSprite
{

    var origin_point:FlxPoint;
    var parent:GameSprite;

    public function new(_op:FlxPoint, _parent:GameSprite)
    {
        parent = _parent;
        super(origin_point.x + parent.x / 8, origin_point.y + parent.y / 8);

        origin_point = _op;

        var c = parent.type == 'chicken' ? 0xfffff1e8 : 0xffff004d;
        makeGraphic(2, 2, c);
        scrollFactor.set();
    }

    override public function update(e)
    {
        super.update(e);
        setPosition(origin_point.x + parent.x / 8, origin_point.y + parent.y / 8);
    }

}