package;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
	var players:FlxTypedGroup<Player>;
	var buttons:FlxTypedGroup<Button>;
	var blocks:FlxTypedGroup<Block>;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		map = new FlxOgmo3Loader("assets/data/no_no_solo.ogmo", "assets/data/level_1.json");
		walls = map.loadTilemap("assets/images/tiles.png", "walls");
		walls.setTileProperties(1, FlxObject.ANY);
		add(walls);

		blocks = new FlxTypedGroup<Block>();
		add(blocks);

		buttons = new FlxTypedGroup<Button>();
		add(buttons);

		players = new FlxTypedGroup<Player>(2);
		add(players);

		map.loadEntities(data -> {
			switch (data.name) {
				case "player_1": players.add(new Player(data.x, data.y, 1));
				case "player_2": players.add(new Player(data.x, data.y, 2));
				case "button": buttons.add(new Button(data.x, data.y));
				case "block": blocks.add(new Block(data.x, data.y));
				case _:
			}
		});

		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(players, walls);
		FlxG.collide(players, blocks);

		FlxG.overlap(players, buttons, (p, b) -> p.touchButton(b));
	}
}
