package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState {
	var players = new FlxTypedGroup<Player>(2);
	var button:Button;
	var block:FlxSprite;

	override public function create():Void {
		bgColor = FlxColor.GRAY;

		block = new FlxSprite(70, 50, "assets/images/block.png");
		block.immovable = true;
		add(block);

		button = new Button(50, 90, block);
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

		FlxG.collide(players, block);

		FlxG.overlap(players, button, (p, b) -> p.touchButton(b));
	}
}
