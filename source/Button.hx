import flixel.FlxSprite;

class Button extends FlxSprite {
	public var block:FlxSprite;

	var pressedBy:Array<Moveable>;

	public function new(X:Float, Y:Float, ?block:FlxSprite) {
		super(X, Y, "assets/images/button.png");
	}
}
