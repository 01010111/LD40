import flixel.FlxSprite;
import flixel.FlxObject;

class GameSprite extends FlxSprite
{

    public var type:String = 'none';

    public function new()
    {
        super();
    }

    /**
     *  Resizes an object and centers its hitbox on the animation frame (ex: for flying objects)
     *  
     *  @param   _width     The width of the hitbox
     *  @param   _height    The height of the hitbox
     */
    public function make_centered_hitbox(_width: Float, _height: Float)
    {
        offset.set(width * 0.5 - _width * 0.5, height * 0.5 - _height * 0.5);
		setSize(_width, _height);
    }


    /**
     *  Resizes an object and moves its hitbox to be centered horizontally and anchored vertically on the animation frame (ex: for standing objects)
     *  
     *  @param   _width     The width of the hitbox
     *  @param   _height    The height of the hitbox
     */
    public function make_anchored_hitbox(_width: Float, _height: Float)
    {
        offset.set(width * 0.5 - _width * 0.5, height - _height);
		setSize(_width, _height);
    }

    /**
     *  Sets the sprite to flip when facing Left or Right 
     *  
     *  @param   _facing_right  Wheter or not the sprite artwork is facing right
     */
    public function set_facing_flip_horizontal(_facing_right: Bool = true)
    {
        setFacingFlip(FlxObject.LEFT, _facing_right, false);
        setFacingFlip(FlxObject.RIGHT, !_facing_right, false);
    }

    public function get_midpoint_y():Float
    {
        return y + height * 0.5;
    }

    public function alert()
    {

    }

}