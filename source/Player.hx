import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.FlxG;

class Player extends Moveable {
	public var id:Int;
	public var levelWin = false;

	var upKey:FlxKey;
	var downKey:FlxKey;
	var leftKey:FlxKey;
	var rightKey:FlxKey;

	public function new(state:PlayState, id:Int, x:Float = 0, y:Float = 0) {
		super(state, x, y, "assets/images/player_" + id + ".png");
		this.id = id;

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

		canPush = true;
	}

	function getInput():FlxPoint {
		var input = new FlxPoint();

		if (FlxG.keys.anyPressed([upKey]))
			input.y -= 1;
		if (FlxG.keys.anyPressed([downKey]))
			input.y += 1;
		if (FlxG.keys.anyPressed([leftKey]))
			input.x -= 1;
		if (FlxG.keys.anyPressed([rightKey]))
			input.x += 1;

		return input;
	}

	function getDirection(input:FlxPoint):FlxPoint {
		if (input.x != 0)
			input.y = 0;
		return input;
	}

	override public function update(elapsed:Float):Void {
		var input = getInput();

		if (input.x != 0 || input.y != 0) {
			var dir = getDirection(input);
			move(dir);
		}

		if (levelWin)
			angularVelocity = 400 * (this.id == 1 ? -1 : 1);

		super.update(elapsed);
	}
}
