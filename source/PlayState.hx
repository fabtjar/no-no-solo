package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState {
	var players = new FlxTypedGroup<Player>(2);
	var button:Button;
	var _block:FlxSprite;
	var _buttonBlock:FlxSprite;

	override public function create():Void {
		bgColor = FlxColor.GRAY;

		_block = new FlxSprite(70, 50);
		_block.loadGraphic(AssetPaths.block__png);
		_block.immovable = true;
		add(_block);

		button = new Button(50, 90, _block);
		button.loadGraphic(AssetPaths.button__png);
		button.setSize(8, 8);
		button.centerOffsets(false);
		add(button);

		players.add(new Player(50, 50, 1));
		players.add(new Player(80, 80, 2));
		add(players);

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(players, _block);

		FlxG.overlap(players, button, (p, b) -> p.touchButton(b));
	}
}
