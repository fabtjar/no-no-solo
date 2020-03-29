package;

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

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		FlxG.camera.flash();

		map = new FlxOgmo3Loader("assets/data/no_no_solo.ogmo", "assets/data/level_1.json");
		tiles = map.loadTilemap("assets/images/tiles.png");
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

		super.create();
	}

	function loadObjectsFromTiles():Void {
		for (i in 0...tiles.totalTiles) {
			var tile = tiles.getTileByIndex(i);

			// Ignore walls and empty spaces
			if (tile <= 1)
				continue;

			var x = i % tiles.widthInTiles * 16;
			var y = Math.floor(i / tiles.widthInTiles) * 16;

			switch (tile) {
				case 2:
					player1 = new Player(this, 1, x, y);
					moveables.add(player1);
				case 3:
					player2 = new Player(this, 2, x, y);
					moveables.add(player2);
				case 4:
					var box = new Box(this, x, y);
					moveables.add(box);
					boxes.add(box);
				case 5:
					buttons.add(new Button(x, y));
				case 6:
					blocks.add(new Block(x, y));
				case 7:
					water.add(new AnimatedSprite(x, y, "assets/images/water.png"));
			}

			// Remove the tile
			tiles.setTileByIndex(i, 0);
		}
	}

	public function isMoveableTo(obj:Moveable, dir:FlxPoint, dist:Float, canPush:Bool = false):Bool {
		var solids = new FlxGroup();
		solids.add(tiles);

		if (blocks.visible)
			solids.add(blocks);

		if (!obj.canGoInWater)
			solids.add(water);

		if (canPush)
			moveables.forEach(b -> if (!isMoveableTo(b, dir, dist)) solids.add(b));
		else
			solids.add(moveables);

		var newPos = new FlxPoint(obj.x + dir.x * dist, obj.y + dir.y * dist);
		return !obj.overlapsAt(newPos.x, newPos.y, solids);
	}

	public function pushBox(pos:FlxPoint, dir:FlxPoint):Void {
		moveables.forEach(b -> if (b.x == pos.x && b.y == pos.y) b.move(dir));
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
			player1.levelWin = true;
			player2.levelWin = true;

			var winText = new FlxText(0, 0, "Level\nComplete", 48);
			winText.alignment = FlxTextAlign.CENTER;
			winText.borderColor = FlxColor.BLACK;
			winText.borderSize = 2;
			winText.borderStyle = FlxTextBorderStyle.OUTLINE;
			winText.screenCenter();
			add(winText);

			new FlxTimer().start(2, _ -> FlxG.switchState(new PlayState()));
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

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		blocks.visible = !isAnyButtonPressed();

		FlxG.overlap(boxes, water, (b:Box, w:AnimatedSprite) -> {
			if (!b.isMoving) {
				moveables.remove(b);
				boxes.remove(b);
				water.remove(w);
			}
		});

		if (!levelWin)
			checkLevelComplete();
	}
}
