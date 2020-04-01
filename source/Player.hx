import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxG;

class Player extends Moveable {
	public var id:Int;
	public var levelWin = false;

	var isPicked = false;

	public function new(state:PlayState, id:Int, x:Float = 0, y:Float = 0) {
		super(state, x, y, "assets/images/player_" + id + ".png");
		this.id = id;

		canPush = true;
	}

	function getInput():FlxPoint {
		var input = new FlxPoint();

		if (FlxG.keys.pressed.UP)
			input.y -= 1;
		if (FlxG.keys.pressed.DOWN)
			input.y += 1;
		if (FlxG.keys.pressed.LEFT)
			input.x -= 1;
		if (FlxG.keys.pressed.RIGHT)
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

		if (!isPicked)
			input = new FlxPoint();

		if (input.x != 0 || input.y != 0) {
			var dir = getDirection(input);
			move(dir);
		}

		if (levelWin)
			angularVelocity = 400 * (this.id == 1 ? -1 : 1);

		super.update(elapsed);
	}

	public function setPicked(isPicked:Bool):Void {
		if (levelWin)
			return;

		this.isPicked = isPicked;

		color = isPicked ? FlxColor.WHITE : FlxColor.GRAY;

		isPicked ? scale.set(2, 2) : scale.set(1, 1);

		if (isPicked)
			FlxTween.tween(scale, {x: 1, y: 1}, 0.1, {ease: FlxEase.quadOut});
	}

	public function swapPicked():Void {
		setPicked(!isPicked);
	}
}
