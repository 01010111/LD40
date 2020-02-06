import zero.utilities.Vec2;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxPath;
//import zerolib.ZMath;

using Math;

class Piggie extends GameSprite
{

	public static var PATROL_MODE:Int = 0;
	public static var PATROL_MODE_NONE:Int = -1;
	public static var PATROL_MODE_RANDOM:Int = 0;
	public static var PATROL_MODE_LOOP_FORWARD:Int = 1;
	public static var PATROL_MODE_LOOP_BACKWARD:Int = 2;
	public static var PATROL_MODE_LOOP_FORWARD_NEAREST:Int = 3;
	public static var PATROL_MODE_PING_PONG:Int = 4;
	public static var PATROL_MODE_PING_PONG_NEAREST:Int = 5;
	public static var PATROL_MODE_NEAREST:Int = 6;

	var STATE_IDLE:Int = 0;
	var STATE_PATROL:Int = 1;
	var STATE_STUNNED:Int = 2;
	var STATE_HUNT:Int = 3;

	var is_stunned:Bool = false;
	var state:Int = 0;
	var prev_state:Int = -1;
	var next_state:Int = 0;
	var target:Node;
	var last_target:Int = 0;
	var recent_velocity:FlxPoint;
	var new_target = true;
	var ping_pong_value = 1;

	var hunt_timer:Int = 0;
	var idle_timer:Int = 0;
	var stun_timer:Int = 0;

	public function new(p:FlxPoint)
	{
		super();

		loadGraphic('assets/images/piggie.png', true, 18, 28);
		make_anchored_hitbox(12, 6);
		setPosition(p.x + 2, p.y + 5);

		animation.add('idle', [0]);
		animation.add('walk', [1, 2, 3, 4, 5, 6], 10);
		animation.add('stun', [7, 8]);

		set_facing_flip_horizontal(true);
		path = new FlxPath();

		maxVelocity.set(130, 130);
		recent_velocity = FlxPoint.get();

		elasticity = 1;

		type = 'piggie';

		if (Piggie.PATROL_MODE == Piggie.PATROL_MODE_LOOP_FORWARD || Piggie.PATROL_MODE == Piggie.PATROL_MODE_PING_PONG) last_target--;
		if (Piggie.PATROL_MODE == Piggie.PATROL_MODE_LOOP_FORWARD_NEAREST || Piggie.PATROL_MODE == Piggie.PATROL_MODE_PING_PONG_NEAREST) 
		{
			for (i in 0...PlayState.i.patrol_nodes.length)
			{
				var d1 = getMidpoint().distanceTo(PlayState.i.patrol_nodes[last_target]); //ZMath.distance(getMidpoint(), PlayState.i.patrol_nodes[last_target]);
				var d2 = getMidpoint().distanceTo(PlayState.i.patrol_nodes[i]); //ZMath.distance(getMidpoint(), PlayState.i.patrol_nodes[i]);
				if (d2 < d1) last_target = i;
			}
			last_target--;
		}
	}

	override public function update(e)
	{
		controls();
		animations();
		super.update(e);

		if (velocity.x != 0 || velocity.y != 0) recent_velocity = FlxPoint.get(velocity.x, velocity.y);
	}

	function controls()
	{
		switch(state)
		{
			case 0: idle();
			case 1: patrol();
			case 2: stunned();
			case 3: hunt();
		}
		search();
	}

	function idle()
	{
		if (prev_state != state) idle_start();
		if (idle_timer == 0)
		{
			state = STATE_PATROL;
			return;
		}
		idle_timer--;
	}

	function idle_start()
	{
		prev_state = state;
		idle_timer = Std.int(Math.random() * 10 + 50);
	}

	function patrol()
	{
		if (Piggie.PATROL_MODE == Piggie.PATROL_MODE_NONE) return;
		if (prev_state != state) patrol_start();
	}

	function patrol_start()
	{
		prev_state = state;
		if (new_target) 
		{
			var nt = PlayState.i.patrol_nodes[get_target_node()];
			if (target != null) target.occupied = false;
			target = nt;
			target.occupied = true;
		}
		path = new FlxPath();
		path.start(PlayState.i.map.findPath(getMidpoint(), target), 50).onComplete = function(p:FlxPath){
			state = STATE_IDLE;
		};
		new_target = true;
	}

	function get_target_node():Int
	{
		switch(Piggie.PATROL_MODE)
		{
			case 0: 
				var t = Math.floor(Math.random() * PlayState.i.patrol_nodes.length);
				while (PlayState.i.patrol_nodes[t].occupied)
				{
					t = Math.floor(Math.random() * PlayState.i.patrol_nodes.length);
				}
				return t;
			case 1:
				last_target = (last_target + 1) % PlayState.i.patrol_nodes.length;
				return last_target;
			case 2:
				last_target = (last_target - 1) % PlayState.i.patrol_nodes.length;
				return last_target;
			case 3:
				last_target = (last_target + 1) % PlayState.i.patrol_nodes.length;
				return last_target;
			case 4, 5:
				if (last_target + ping_pong_value >= PlayState.i.patrol_nodes.length || last_target + ping_pong_value < 0) ping_pong_value *= -1;
				last_target += ping_pong_value;
				return last_target;
			case 6:
				var n = -1;
				for (i in 0...PlayState.i.patrol_nodes.length)
				{
					if (PlayState.i.patrol_nodes[i].occupied) 
					{
						trace('' + i + ' occupied!');
						continue;
					}
					var d1 = n < 0 ? 999 : getMidpoint().distanceTo(PlayState.i.patrol_nodes[n]); //ZMath.distanceTo(getMidpoint(), PlayState.i.patrol_nodes[n]);
					var d2 = getMidpoint().distanceTo(PlayState.i.patrol_nodes[i]);
					if (d2 < d1) n = i;
				}
				trace(n);
				return n;
		}
		return 0;
	}

	function stunned()
	{
		if (prev_state != state) stunned_start();
		if (stun_timer == 0)
		{
			is_stunned = false;
			state = STATE_HUNT;
			return;
		}
		stun_timer--;
	}

	function stunned_start()
	{
		prev_state = state;
		is_stunned = true;
		stun_timer = 60;
	}

	function hunt()
	{
		if (prev_state != state) hunt_start();
		var mp:Vec2 = [x + width/2, y + height/2];
		var cmp:Vec2 = [PlayState.i.chicken.getMidpoint().x, PlayState.i.chicken.getMidpoint().y];
		var a = (cmp - mp);
		a.length = mp.distance(cmp).map(0, 100, 2400, 500).max(400);
		//var a = getMidpoint().get_angle_between(PlayState.i.chicken.getMidpoint()).vector_from_angle(800); //ZMath.velocityFromAngle(ZMath.angleBetween(getMidpoint(), PlayState.i.chicken.getMidpoint()), 800);
		acceleration.set(a.x, a.y);
		if (hunt_timer == 0)
		{
			acceleration.set();
			velocity.set();
			state = STATE_IDLE;
		}
		else hunt_timer--;
		mp.put();
		cmp.put();
		a.put();
	}

	function hunt_start()
	{
		if (target != null) target.occupied = false;
		prev_state = state;
		//path.start(PlayState.i.map.findPath(getMidpoint(), target), 140);
	}

	function animations()
	{
		if (is_stunned)
		{
			animation.play('stun');
			return;
		}
		if (velocity.x == 0 && velocity.y == 0) animation.play('idle');
		else 
		{
			animation.play('walk');
			animation.curAnim.frameRate = Std.int(Math.max(Math.abs(velocity.x), Math.abs(velocity.y)) / 3);
		}
		if (velocity.x > 0) facing = FlxObject.RIGHT;
		if (velocity.x < 0) facing = FlxObject.LEFT;
	}

	function search()
	{
		if (!PlayState.i.map.ray(getMidpoint(), PlayState.i.chicken.getMidpoint())) return;
		var pp:Vec2 = [x + width/2, y + height/2];
		var cp:Vec2 = [PlayState.i.chicken.x + PlayState.i.chicken.width/2, PlayState.i.chicken.y + PlayState.i.chicken.height/2];
		var ca = getMidpoint().get_angle_between(PlayState.i.chicken.getMidpoint()).get_relative_degree();
		var va = recent_velocity.vector_angle();
		var to_chicken_vec:Vec2 = [1, 0];
		var facing_vec:Vec2 = [1, 0];
		to_chicken_vec.angle = ca;
		facing_vec.angle = va;
		if (to_chicken_vec.dot(facing_vec) < 0.5 || pp.distance(cp) > 100) {
			pp.put();
			cp.put();
			to_chicken_vec.put();
			facing_vec.put();
			return;
		}
		next_state = STATE_HUNT;
		if (state != STATE_HUNT) state = STATE_STUNNED;
		if (path.active) path.cancel();
		hunt_timer = 120;
		pp.put();
		cp.put();
		to_chicken_vec.put();
		facing_vec.put();
		/*if (PlayState.i.map.ray(getMidpoint(), PlayState.i.chicken.getMidpoint()))
		{
			var chicken_angle = getMidpoint().angleBetween(PlayState.i.chicken.getMidpoint()).get_relative_degree(); //ZMath.toRelativeAngle(ZMath.angleBetween(getMidpoint(), PlayState.i.chicken.getMidpoint()));
			var velocity_angle = recent_velocity.vector_angle(); //ZMath.angleFromVelocity(recent_velocity.x, recent_velocity.y);
			if (Math.abs(chicken_angle - velocity_angle) > 180)
			{
				if (chicken_angle < velocity_angle) chicken_angle += 360;
				else velocity_angle += 360;
			}
			var diff = state == STATE_IDLE ? 90 : 60;

			if (Math.abs(chicken_angle - velocity_angle) < diff && getMidpoint().distance(PlayState.i.chicken.getMidpoint()) < 100 )//ZMath.distance(getMidpoint(), PlayState.i.chicken.getMidpoint()) < 100)
			{
				next_state = STATE_HUNT;
				if (state != STATE_HUNT) state = STATE_STUNNED;
				if (path.active) 
				{
					path.cancel();
				}
				hunt_timer = 120;
			}
		}*/
	}

	override public function alert()
	{
		var pp:Vec2 = [x + width/2, y + height/2];
		var cp:Vec2 = [PlayState.i.chicken.x + PlayState.i.chicken.width/2, PlayState.i.chicken.y + PlayState.i.chicken.height/2];
		var d = pp.distance(cp);
		if (d > 120 || state == STATE_HUNT || state == STATE_STUNNED) {
			pp.put();
			cp.put();
			return;
		}
		next_state = STATE_PATROL;
		state = STATE_STUNNED;
		target.occupied = false;
		if (path.active) path.cancel();
		target = new Node(cp.x, cp.y);
		new_target = false;
		pp.put();
		cp.put();
		/*var d = getMidpoint().distance(PlayState.i.chicken.getMidpoint());
		if (d > 120 || state == STATE_HUNT || state == STATE_STUNNED) return;
		next_state = STATE_PATROL;
		state = STATE_STUNNED;
		target.occupied = false;
		if (path.active)
		{
			path.cancel();
		}
		target = new Node(PlayState.i.chicken.getMidpoint().x, PlayState.i.chicken.getMidpoint().y);
		new_target = false;*/
	}

}