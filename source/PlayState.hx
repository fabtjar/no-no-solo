package;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
	var players = new FlxTypedGroup<Player>(2);
	var button:Button;
	var block:FlxSprite;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		map = new FlxOgmo3Loader("assets/data/no_no_solo.ogmo", "assets/data/level_1.json");
		walls = map.loadTilemap("assets/images/tiles.png", "walls");
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		block = new FlxSprite(70, 50, "assets/images/block.png");
		block.immovable = true;
		add(block);

		button = new Button(16 * 8, 16 * 4, block);
		button.centerOffsets(false);
		add(button);

		add(players);

		map.loadEntities(data -> {
			if (data.name == "player_1") {
				players.add(new Player(data.x, data.y, 1));
			} else if(data.name == "player_2") {
				players.add(new Player(data.x, data.y, 2));
			}
		});

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(players, walls);
		FlxG.collide(players, block);

		FlxG.overlap(players, button, (p, b) -> p.touchButton(b));
	}
}
