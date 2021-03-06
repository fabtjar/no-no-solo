package;

import haxe.ds.GenericStack;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
	var buttons:FlxTypedGroup<Button>;
	var water:FlxTypedGroup<AnimatedSprite>;
	var blocks:FlxTypedGroup<Block>;
	var moveables:FlxTypedGroup<Moveable>;
	var boxes:FlxTypedGroup<Box>;
	var levelWin = false;

	var map:FlxOgmo3Loader;
	var tiles:FlxTilemap;

	var player1:Player;
	var player2:Player;

	var moves:GenericStack<{obj:Moveable, pos:FlxPoint, canPush:Bool}>;

	var levelNum:Int;
	var levelTitles = [
		"simple_boxes", "simple_same_buttons", "cant_go_on_water", "water_one_box", "show_box_on_water", "two_small_islands", "use_box_on_button",
		"blocks_stopping_box_for_water", "get_around_water_corners", "simple_ice_level", "use_walls_on_ice",
	];

	public function new(levelNum:Int = 1) {
		super();
		this.levelNum = levelNum;
	}

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		moves = new GenericStack();

		FlxG.camera.flash();

		var currentLevel = levelTitles[levelNum - 1];

		map = new FlxOgmo3Loader("assets/data/no_no_solo.ogmo", "assets/data/" + currentLevel + ".json");
		tiles = map.loadTilemap("assets/images/tiles.png");
		tiles.setTileProperties(8, FlxObject.NONE);
		tiles.setTileProperties(9, FlxObject.NONE);
		add(tiles);

		water = new FlxTypedGroup<AnimatedSprite>();
		add(water);

		blocks = new FlxTypedGroup<Block>();
		add(blocks);

		buttons = new FlxTypedGroup<Button>();
		add(buttons);

		boxes = new FlxTypedGroup<Box>();
		add(boxes);

		moveables = new FlxTypedGroup<Moveable>();
		add(moveables);

		loadObjectsFromTiles();

		// Add after other moveables to view on top
		moveables.add(player1);
		moveables.add(player2);

		player1.setPicked(true);
		player2.setPicked(false);

		var levelText = new FlxText(0, 0, "Level " + levelNum);
		levelText.borderColor = FlxColor.BLACK;
		levelText.borderSize = 1;
		levelText.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(levelText);

		super.create();
	}

	function loadObjectsFromTiles():Void {
		for (i in 0...tiles.totalTiles) {
			var tile = tiles.getTileByIndex(i);

			// Ignore walls and empty spaces
			if (tile <= 1 || tile == 9)
				continue;

			var x = i % tiles.widthInTiles * 16;
			var y = Math.floor(i / tiles.widthInTiles) * 16;

			switch (tile) {
				case 2:
					player1 = new Player(this, 1, x, y);
				case 3:
					player2 = new Player(this, 2, x, y);
				case 4:
					var box = new Box(this, x, y);
					moveables.add(box);
					boxes.add(box);
				case 5:
					buttons.add(new Button(x, y, "green"));
				case 6:
					blocks.add(new Block(x, y, "green"));
				case 7:
					water.add(new AnimatedSprite(x, y, "assets/images/water.png", true));
				case 13:
					buttons.add(new Button(x, y, "blue"));
				case 14:
					blocks.add(new Block(x, y, "blue"));
				case 21:
					buttons.add(new Button(x, y, "red"));
				case 22:
					blocks.add(new Block(x, y, "red"));
				case 29:
					buttons.add(new Button(x, y, "yellow"));
				case 30:
					blocks.add(new Block(x, y, "yellow"));
			}

			// Remove the tile
			tiles.setTileByIndex(i, 8);
		}
	}

	public function isMoveableTo(obj:Moveable, dir:FlxPoint, dist:Float, canPush:Bool = false):Bool {
		var solids = new FlxGroup();
		solids.add(tiles);

		blocks.forEach(b -> if (b.visible) solids.add(b));

		if (!obj.canGoInWater)
			solids.add(water);

		if (canPush)
			moveables.forEach(b -> if (!isMoveableTo(b, dir, dist)) solids.add(b));
		else
			solids.add(moveables);

		var newPos = new FlxPoint(obj.x + dir.x * dist, obj.y + dir.y * dist);

		if (newPos.x < 0 || newPos.x >= tiles.width || newPos.y < 0 || newPos.y >= tiles.height)
			return false;

		return !obj.overlapsAt(newPos.x, newPos.y, solids);
	}

	public function pushBox(pos:FlxPoint, dir:FlxPoint):Void {
		moveables.forEach(b -> if (b.x == pos.x && b.y == pos.y) b.move(dir));
	}

	public function isOnIce(pos:FlxPoint):Bool {
		var index = tiles.getTileIndexByCoords(pos);
		var tile = tiles.getTileByIndex(index);
		return tile == 9;
	}

	public function move(obj:Moveable, pos:FlxPoint, canPush:Bool):Void {
		moves.add({obj: obj, pos: pos, canPush: canPush});
	}

	function undoMove():Void {
		var lastMove = moves.pop();
		if (lastMove != null) {
			// If not visible it was a box in water so create it again and add a water
			if (!lastMove.obj.visible) {
				water.add(new AnimatedSprite(lastMove.obj.x, lastMove.obj.y, "assets/images/water.png"));
				lastMove.obj.visible = true;
				moveables.add(lastMove.obj);
				boxes.add(cast(lastMove.obj, Box));
			}
			lastMove.obj.undoMove(lastMove.pos);
			if (!lastMove.canPush)
				undoMove();
		}
	}

	public function getOverlappingButtonAt(object:FlxSprite, x:Float, y:Float):Button {
		if (object.overlapsAt(x, y, buttons)) {
			var button:Button;
			buttons.forEach(b -> if (b.x == x && b.y == y) button = b);
			return button;
		}
		return null;
	}

	function checkLevelComplete():Void {
		if (player1.getPosition().distanceTo(player2.getPosition()) <= 16) {
			levelWin = true;

			player1.setPicked(true);
			player2.setPicked(true);

			player1.levelWin = true;
			player2.levelWin = true;

			var winText = new FlxText(0, 0, "Level\nComplete", 48);
			winText.alignment = FlxTextAlign.CENTER;
			winText.borderColor = FlxColor.BLACK;
			winText.borderSize = 2;
			winText.borderStyle = FlxTextBorderStyle.OUTLINE;
			winText.screenCenter();
			add(winText);

			// Next level delay
			new FlxTimer().start(2, _ -> {
				levelNum += 1;
				// Show end screen when out of levels
				if (levelNum > levelTitles.length)
					FlxG.switchState(new EndState());
				else
					FlxG.switchState(new PlayState(levelNum));
			});
		}
	}

	function isAnyButtonPressed():Bool {
		var anyOverlaps:Bool = false;
		moveables.forEach(obj -> {
			if (obj.overlaps(buttons)) {
				anyOverlaps = true;
				return;
			}
		});
		return anyOverlaps;
	}

	function getPressedButtons():Map<String, Bool> {
		var buttonsPress = ["green" => false, "blue" => false, "red" => false, "yellow" => false];
		buttons.forEach(b -> {
			if (b.overlaps(moveables))
				buttonsPress[b.colour] = true;
		});
		return buttonsPress;
	}

	function changeBlocksVisibilty():Void {
		var buttonsPressed = getPressedButtons();
		blocks.forEach(b -> {
			b.visible = !buttonsPressed[b.colour];
		});
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			player1.swapPicked();
			player2.swapPicked();
		}

		changeBlocksVisibilty();

		FlxG.overlap(boxes, water, (b:Box, w:AnimatedSprite) -> {
			// Removing is when it's not moving so it doesn't get removed instantly
			if (!b.isMoving) {
				moveables.remove(b);
				boxes.remove(b);
				water.remove(w);
				w.destroy();

				// Making box invisible is a cheap way to know it went into water while undoing
				b.visible = false;
			}
		});

		if (FlxG.keys.justReleased.R)
			FlxG.switchState(new PlayState(levelNum));

		if (FlxG.keys.justPressed.BACKSPACE)
			undoMove();

		// Auto win level
		if (FlxG.keys.justPressed.END) {
			player1.x = player2.x;
			player1.y = player2.y;
		}

		if (!levelWin)
			checkLevelComplete();
	}
}
