import flixel.FlxSprite;

class Button extends FlxSprite {
	public var colour:String;

	public function new(x:Float, y:Float, colour:String) {
		super(x, y, "assets/images/" + colour + "_button.png");
		this.colour = colour;
	}
}
