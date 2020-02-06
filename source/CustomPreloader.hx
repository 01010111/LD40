class CustomPreloader extends flixel.system.FlxBasePreloader {
	public function new() {
		super();
		allowedURLs = [
			'https://www.coolmathgames.com',
			'www.coolmathgames.com',
			'edit.coolmathgames.com',
			'www.stage.coolmathgames.com',
			'edit-stage.coolmathgames.com',
			'dev.coolmathgames.com',
			'm.coolmathgames.com',
			'https://www.coolmath-games.com',
			'www.coolmath-games.com',
			'edit.coolmath-games.com',
			'edit-stage.coolmath-games.com',
			'dev.coolmath-games.com',
			'm.coolmath-games.com',
			#if debug 'http://127.0.0.1/' #end
		];
	}
}