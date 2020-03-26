package;

import flixel.FlxObject;
import openfl.net.NetConnection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState {
	var _player:Player;
	var _button:FlxSprite;
	var _block:FlxSprite;
	var _buttonBlock:FlxSprite;

	override public function create():Void {
		bgColor = FlxColor.GRAY;
	

		_block = new FlxSprite(70, 50);
		_block.loadGraphic(AssetPaths.block__png);
		_block.immovable = true;
		add(_block);

		_button = new FlxSprite(50, 90);
		_button.loadGraphic(AssetPaths.button__png);
		_button.setSize(8, 8);
		_button.centerOffsets(false);
		add(_button);

		_player = new Player(50, 50);
		add(_player);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(_player, _block);

		FlxG.overlap(_player, _button, playerTouchButton);
		if (!FlxG.overlap(_player, _player.button)) {
			playerOffButton();
		}
	}

	function playerTouchButton(p:Player, b:FlxSprite):Void {
		p.button = b;
		_block.visible = false;
		_block.allowCollisions = FlxObject.NONE;
	}

	function playerOffButton():Void {
		_player.button = null;
		_block.visible = true;
		_block.allowCollisions = FlxObject.ANY;
	}
}
