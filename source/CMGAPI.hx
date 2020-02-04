@:native('parent') extern class CoolMathGamesAPI {
	public static function cmgGameEvent(event:String, ?id:String):Void;
}

class CMGAPI {
	public static function event(type:EventType, ?meta:Dynamic) {
		var t = switch type {
			case START: 'start';
		}
		try {
			meta != null ? CoolMathGamesAPI.cmgGameEvent(t, meta.string()) : CoolMathGamesAPI.cmgGameEvent(t);
		} catch(e:Dynamic) {
			trace(e);
			trace(t, meta);
		}
	}
}

enum EventType {
	START;
}