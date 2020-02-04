package;

import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.math.FlxMath;
import flixel.util.FlxSort;
import openfl.Assets;
//import zerolib.ZMath;

using Math;

class PlayState extends FlxState
{
	public static var l:Int = 0;
	public static var i:PlayState;

	public var map:FlxTilemap;
	public var patrol_nodes:Array<Node> = [];
	public var chicken:Chicken;
	public var objects:FlxTypedGroup<GameSprite>;
	public var pig_queue:Array<FlxPoint> = [];

	var splat_layer:FlxSprite;

	var level_data:Array<Array<Int>>;

	public function new()
	{
		load();
		save();
		CMGAPI.event(START, l + 1);
		i = this;
		level_data = get_level_data();
		super();
	}

	function load() {
		var save = new FlxSave();
		save.bind('escape_hatch_cmg');
		if (save.data.level == null) return;
		var nl = save.data.level;
		if (l > nl && nl >= 0) return;
		l = nl.max(0).int(); 
	} 

	function save() {
		var save = new FlxSave();
		save.bind('escape_hatch_cmg');
		save.data.level = l;
		save.flush();
	}

	function get_level_data():Array<Array<Int>>
	{
		var a = [];

		var csv = Assets.getText('assets/data/' + PlayState.l + '.csv');
		var rows = csv.split('\n');

		for (row in rows)
		{
			var r = [];
			var v = row.split(',');
			for (n in v)
			{
				r.push(Std.parseInt(n));
			}
			a.push(r);
		}

		return a;
	}

	override public function create():Void
	{
		create_callback();
		bgColor = 0xff1d1d28;

		super.create();

		map = new FlxTilemap();
		map.loadMapFrom2DArray(get_level_array(level_data), 'assets/images/tiles.png', 16, 16, FlxTilemapAutoTiling.AUTO);
		map.follow();

		objects = new FlxTypedGroup();

		add_objects(level_data);

		splat_layer = new FlxSprite(0, 0);
		splat_layer.makeGraphic(Std.int(map.width), Std.int(map.height), 0x00ffffff);
		add(splat_layer);
		add(map);
		add(objects);

		openSubState(new IntroSubState());
	}

	function create_callback()
	{
		if (PlayState.l < 3) Chicken.age = 1;
		else if (PlayState.l < 6) Chicken.age = 2;
		else Chicken.age = 3;
		switch(PlayState.l)
		{
			case 1: Piggie.PATROL_MODE = Piggie.PATROL_MODE_PING_PONG_NEAREST;
			case 2, 5: Piggie.PATROL_MODE = Piggie.PATROL_MODE_LOOP_FORWARD_NEAREST;
			case 3, 4, 6, 7, 8: Piggie.PATROL_MODE = Piggie.PATROL_MODE_NEAREST;
		}
	}

	public function loaded_callback()
	{
		switch(PlayState.l)
		{
			case 1: openSubState(new Dialog('hi there! welcome to the world! don"t get turned into a little chicken nugget!'));
			case 3: openSubState(new Dialog('you"re growing so fast! must be all the hormones :) \nnow you can run by pressing the x key!'));
			case 6: openSubState(new Dialog('now you can lay eggs by holding down the c key! your clucks will alert nearby piggies!'));
		}
	}

	function get_level_array(_level_data:Array<Array<Int>>):Array<Array<Int>>
	{
		var a = [];
		for (y in 0..._level_data.length)
		{
			a.push([]);
			for (x in 0..._level_data[y].length)
			{
				var ld = _level_data[y][x];
				if (ld > 1 || ld < 0) a[y][x] = 0;
				else a[y][x] = ld;
			}
		}
		return a;
	}

	function add_objects(_level_data:Array<Array<Int>>)
	{
		for (y in 0..._level_data.length)
		{
			for (x in 0..._level_data[y].length)
			{
				if (_level_data[y][x] == 2) add_chicken(x, y);
				if (_level_data[y][x] == 3) add_piggie(x, y);
				if (_level_data[y][x] >= 4) add_patrol_node(x, y, level_data[y][x] - 4);
				if (_level_data[y][x] == -1) add_egg(FlxPoint.get(x * 16 + 8, y * 16 + 8), false);
				if (_level_data[y][x] == -2) add_egg(FlxPoint.get(x * 16 + 8, y * 16 + 8), false, true);
			}
		}
		for (p in pig_queue)
		{
			objects.add(new Piggie(p));
		}
	}

	function add_chicken(x, y)
	{
		chicken = new Chicken(FlxPoint.get(x * 16, y * 16));
		objects.add(chicken);
		FlxG.camera.follow(chicken);
	}

	function add_piggie(x, y)
	{
		pig_queue.push(FlxPoint.get(x * 16, y * 16));
	}

	function add_patrol_node(x, y, i)
	{
		patrol_nodes[i] = new Node(x * 16 + 8, y * 16 + 8);
	}

	public function add_egg(p:FlxPoint, pop:Bool = false, has_chick:Bool = false)
	{
		objects.add(new Egg(p, pop, has_chick));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R) FlxG.resetState();

		objects.sort(sort_by_y, FlxSort.ASCENDING);

		FlxG.collide(objects, map);
		FlxG.overlap(objects, objects, check_objects);
	}

	function check_objects(o1:GameSprite, o2:GameSprite)
	{
		if (o1.type == 'none' || o2.type == 'none' || o1.type == o2.type) return;
		if (o1.type == 'egg') o1.kill();
		if (o2.type == 'egg') o2.kill();
		if (o1.type == 'chicken' && o2.type == 'piggie' || o2.type == 'chicken' && o1.type == 'piggie') game_over();
	}

	function game_over()
	{
		openSubState(new GameOverSubState(false));
	}

	function sort_by_y(i:Int, s1:GameSprite, s2:GameSprite):Int
	{
		return FlxMath.signOf(s1.get_midpoint_y() - s2.get_midpoint_y());
	}

	public function win()
	{
		if (PlayState.l == 8) 
		{
			openSubState(new WinSubState());
			l = -1;
			save();
			return;
		}
		complete_callback();
		openSubState(new GameOverSubState(true));
	}

	public function complete_callback()
	{
		/* switch(PlayState.l)
		{
			
		} */
		PlayState.l++;
	}

	public function splat(p:FlxPoint)
	{
		for (i in 0...4)
		{
			var s = new GameSprite();
			s.loadGraphic('assets/images/splats/' + Math.floor(Math.random() * 14) + '.png');
			s.alpha = Math.random() * 0.5 + 0.5;
			var sc = Math.random() * 0.15 + 0.1;
			s.scale.set(sc, sc);
			splat_layer.stamp(s, Std.int(p.x - s.width * 0.5) + 8.get_random(-8).int(), Std.int(p.y - s.height * 0.5) + 8.get_random(-8).int());
		}
	}
}
