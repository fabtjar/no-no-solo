package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
	var players:FlxTypedGroup<Player>;
	var buttons:FlxTypedGroup<Button>;
	var blocks:FlxTypedGroup<Block>;
	var levelWin = false;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		FlxG.camera.flash();

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

		var blockNodes = new Map<Block, Array<FlxPoint>>();

		map.loadEntities(data -> {
			switch (data.name) {
				case "player_1": players.add(new Player(this, data.x, data.y, 1));
				case "player_2": players.add(new Player(this, data.x, data.y, 2));
				case "button": buttons.add(new Button(data.x, data.y));
				case "block":
					var block = new Block(data.x, data.y);
					blocks.add(block);
					blockNodes[block] = convertNodeToPoints(data.nodes);
				case _:
			}
		});

		setBlocksToButtons(blockNodes);

		super.create();
	}

	function convertNodeToPoints(nodes:Array<{x:Float, y:Float}>):Array<FlxPoint> {
		var points = new Array<FlxPoint>();

		// Add 8 for middle of 16px grid
		for (node in nodes)
			points.push(new FlxPoint(node.x + 8, node.y + 8));

		return points;
	}

	function setBlocksToButtons(blockNodes:Map<Block, Array<FlxPoint>>):Void {
		/**
			Set blocks to buttons.
			Loop through button points on blocks to see if a button overlaps with it.
			If it does set it to the button's block.
		**/
		for (block => buttonPoints in blockNodes) {
			for (buttonPoint in buttonPoints) {
				buttons.forEach(button -> {
					if (button.overlapsPoint(buttonPoint)) {
						button.block = block;
					}
				});
			}
		}
	}

	public function isOverlappingSolid(object:FlxSprite, x:Float, y:Float):Bool {
		var solids = new FlxGroup();
		solids.add(walls);
		blocks.forEach(b -> if (b.visible) solids.add(b));
		return !object.overlapsAt(x, y, solids);
	}

	public function getOverlappingButton(object:FlxSprite, x:Float, y:Float):Button {
		if (object.overlapsAt(x, y, buttons)) {
			var button:Button;
			buttons.forEach(b -> if (b.x == x && b.y == y) button = b);
			return button;
		}
		return null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (!levelWin) {
			FlxG.overlap(players, players, (a, b) -> {
				levelWin = true;
				a.levelWin = true;
				b.levelWin = true;

				var winText = new FlxText(0, 0, "Level\nComplete", 48);
				winText.alignment = FlxTextAlign.CENTER;
				winText.borderColor = FlxColor.BLACK;
				winText.borderSize = 2;
				winText.borderStyle = FlxTextBorderStyle.OUTLINE;
				winText.screenCenter();
				add(winText);

				new FlxTimer().start(2, _ -> FlxG.switchState(new PlayState()));
			});
		}
	}
}
