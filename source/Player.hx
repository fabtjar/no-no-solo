import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public var speed:Float = 200;
	public var button:Button;
	public var id:Int;
	public var levelWin = false;
	public var freeSpaces = {
		up: false,
		down: false,
		left: false,
		right: false
	};

	var canMove = true;

	var state:PlayState;
	var upKey:FlxKey;
	var downKey:FlxKey;
	var leftKey:FlxKey;
	var rightKey:FlxKey;

	public function new(state:PlayState, ?X:Float = 0, ?Y:Float = 0, id:Int) {
		super(X, Y, "assets/images/player_" + id + ".png");
		this.id = id;
		this.state = state;

		if (id == 1) {
			upKey = UP;
			downKey = DOWN;
			leftKey = LEFT;
			rightKey = RIGHT;
		} else {
			upKey = W;
			downKey = S;
			leftKey = A;
			rightKey = D;
		}

		drag.x = drag.y = 1600;
		FlxG.watch.add(this, "freeSpaces");
	}

	function movement():Void {
		var input = new FlxPoint();

		if (FlxG.keys.anyPressed([upKey]))
			input.y -= 1;
		if (FlxG.keys.anyPressed([downKey]))
			input.y += 1;
		if (FlxG.keys.anyPressed([leftKey]))
			input.x -= 1;
		if (FlxG.keys.anyPressed([rightKey]))
			input.x += 1;

		if (input.x != 0 || input.y != 0) {
			if (input.x != 0)
				input.y = 0;

			var newPos = {x: x + input.x * 16, y: y + input.y * 16};

			if (button != null)
				offButton();
			button = state.getOverlappingButton(this, newPos.x, newPos.y);
			if (button != null)
				touchButton();

			if (state.isOverlappingSolid(this, newPos.x, newPos.y)) {
				canMove = false;
				var options = {ease: FlxEase.quadOut, onComplete: moveFinished};
				FlxTween.tween(this, newPos, .1, options);
			}
		}
	}

	function moveFinished(_) {
		canMove = true;
	}

	override public function update(elapsed:Float):Void {
		if (canMove)
			movement();

		if (levelWin)
			angularVelocity = 400 * (this.id == 1 ? -1 : 1);

		super.update(elapsed);
	}

	public function touchButton():Void {
		button.isPressed = true;
	}

	public function offButton():Void {
		button.isPressed = false;
		button = null;
	}
}
