import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

class Moveable extends FlxSprite {
	public var canGoInWater = false;
	public var isMoving = false;

	var state:PlayState;
	var moveDur = .1;
	var moveDist = 16;
	var moveTween:VarTween;
	var canPush = false;
	var direction:FlxPoint;

	public function new(state:PlayState, x:Float = 0, y:Float = 0, imageLocation:String) {
		super(x, y, imageLocation);
		this.state = state;
	}

	function canMove(direction:FlxPoint, isOnIce = false):Bool {
		if (isMoving)
			return false;

		return state.isMoveableTo(this, direction, moveDist, isOnIce ? false : canPush);
	}

	public function move(direction:FlxPoint, isOnIce = false):Void {
		if (canMove(direction, isOnIce)) {
			this.direction = direction;
			isMoving = true;
			var moveTo = getMovedPos(direction);
			var tweenValues = {x: moveTo.x, y: moveTo.y};
			var tweenOptions = {ease: FlxEase.quadOut, onComplete: moveFinished};
			moveTween = FlxTween.tween(this, tweenValues, moveDur, tweenOptions);

			if (!isOnIce)
				state.move(this, getPosition(), canPush);

			state.pushBox(moveTo, direction);
		}
	}

	public function undoMove(lastPos:FlxPoint):Void {
		moveTween.cancel();
		isMoving = false;
		setPosition(lastPos.x, lastPos.y);
	}

	function getMovedPos(direction:FlxPoint):FlxPoint {
		return new FlxPoint(x + direction.x * moveDist, y + direction.y * moveDist);
	}

	function moveFinished(_):Void {
		isMoving = false;

		if (state.isOnIce(getPosition()))
			move(direction, true);
	}
}
