import flixel.FlxSprite;

class AnimatedSprite extends FlxSprite {
	public function new(X:Float, Y:Float, imageLocation:String) {
		super(X, Y);
		loadGraphic(imageLocation, true, 16, 16);
		animation.add("", [for (i in 0...numFrames) i], 5);
		animation.play("");
	}
}
