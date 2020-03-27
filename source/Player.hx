import flixel.input.keyboard.FlxKey;
import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public var speed:Float = 200;
	public var button:Button;
	public var id:Int;

	var upKey:FlxKey;
	var downKey:FlxKey;
	var leftKey:FlxKey;
	var rightKey:FlxKey;

	public function new(?X:Float = 0, ?Y:Float = 0, id:Int) {
		super(X, Y);
		this.id = id;

		loadGraphic("assets/images/player_" + id + ".png");

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
	}

	function movement():Void {
		var input = new FlxVector();

		if (FlxG.keys.anyPressed([upKey]))
			input.y -= 1;
		if (FlxG.keys.anyPressed([downKey]))
			input.y += 1;
		if (FlxG.keys.anyPressed([leftKey]))
			input.x -= 1;
		if (FlxG.keys.anyPressed([rightKey]))
			input.x += 1;

		if (input.lengthSquared > 0) {
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), input.degrees);

			if (input.x != 0)
				facing = input.x > 0 ? FlxObject.RIGHT : FlxObject.LEFT;
		}
	}

	override public function update(elapsed:Float):Void {
		movement();

		if (button != null && !FlxG.overlap(button))
			offButton();

		super.update(elapsed);
	}

	public function touchButton(b:Button):Void {
		button = b;
		button.isPressed = true;
	}

	public function offButton():Void {
		button.isPressed = false;
		button = null;
	}
}
