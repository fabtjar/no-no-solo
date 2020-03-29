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
	var buttons:FlxTypedGroup<Button>;
	var blocks:FlxTypedGroup<Block>;
	var moveables:FlxTypedGroup<Moveable>;
	var levelWin = false;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var player1:Player;
	var player2:Player;

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

		moveables = new FlxTypedGroup<Moveable>();
		add(moveables);

		map.loadEntities(data -> {
			switch (data.name) {
				case "player_1":
					player1 = new Player(this, 1, data.x, data.y);
					moveables.add(player1);
				case "player_2":
					player2 = new Player(this, 2, data.x, data.y);
					moveables.add(player2);
				case "button": buttons.add(new Button(data.x, data.y));
				case "block": blocks.add(new Block(data.x, data.y));
				case "box": moveables.add(new Moveable(this, data.x, data.y, "assets/images/box.png"));
				case _:
			}
		});

		super.create();
	}

	public function isMoveableTo(obj:Moveable, dir:FlxPoint, dist:Float, canPush:Bool = false):Bool {
		var solids = new FlxGroup();
		solids.add(walls);

		if (blocks.visible)
			solids.add(blocks);

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

		if (!levelWin)
			checkLevelComplete();
	}
}
