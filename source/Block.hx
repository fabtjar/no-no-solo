import flixel.FlxSprite;

class Block extends FlxSprite {

	public function new(X:Float, Y:Float) {
		super(X, Y, "assets/images/block.png");
		immovable = true;
	}
}
