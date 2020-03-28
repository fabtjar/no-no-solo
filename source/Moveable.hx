import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class Moveable extends FlxSprite {
	var state:PlayState;
	var isMoving = false;
	var moveDur = .1;
	var moveDist = 16;

	public function new(state:PlayState, x:Float = 0, y:Float = 0, imageLocation:String) {
		super(x, y, imageLocation);
		this.state = state;
	}

	function canMove(direction:FlxPoint):Bool {
		if (isMoving)
			return false;

		return state.isOverlappingSolidAt(this, getMovedPos(direction));
	}

	function move(direction:FlxPoint):Void {
		if (canMove(direction)) {
			isMoving = true;
			var moveTo = getMovedPos(direction);
			var tweenValues = {x: moveTo.x, y: moveTo.y};
			var tweenOptions = {ease: FlxEase.quadOut, onComplete: moveFinished};
			FlxTween.tween(this, tweenValues, moveDur, tweenOptions);
		}
	}

	function getMovedPos(direction:FlxPoint):FlxPoint {
		return new FlxPoint(x + direction.x * moveDist, y + direction.y * moveDist);
	}

	function moveFinished(_):Void {
		isMoving = false;
	}
}
