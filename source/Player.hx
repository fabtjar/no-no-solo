import flixel.FlxObject;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public var speed:Float = 200;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		loadGraphic(AssetPaths.player_1__png);

		drag.x = drag.y = 1600;
	}

	function movement():Void {
		var input = new FlxVector();

		if (FlxG.keys.anyPressed([UP, W])) // Up
			input.y -= 1;
		if (FlxG.keys.anyPressed([DOWN, S])) // Down
			input.y += 1;
		if (FlxG.keys.anyPressed([LEFT, A])) // Left
			input.x -= 1;
		if (FlxG.keys.anyPressed([RIGHT, D])) // Right
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
		super.update(elapsed);
	}
}
