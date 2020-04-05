import flixel.FlxG;
import flixel.FlxSprite;

class AnimatedSprite extends FlxSprite {
	public function new(X:Float, Y:Float, imageLocation:String, randomFrame = false) {
		super(X, Y);
		loadGraphic(imageLocation, true, 16, 16);
		animation.add("", [for (i in 0...numFrames) i], 5);
		animation.play("", randomFrame ? FlxG.random.int(0, numFrames) : 0);
	}
}
