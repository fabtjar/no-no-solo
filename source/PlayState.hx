package;

import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState
{
	var _player:Player;

	override public function create():Void
	{
		bgColor = FlxColor.GRAY;

		_player = new Player(50, 50);
		add(_player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
