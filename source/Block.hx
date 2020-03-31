import flixel.FlxSprite;

class Block extends FlxSprite {
	public var colour:String;

	public function new(x:Float, y:Float, colour:String) {
		super(x, y, "assets/images/" + colour + "_block.png");
		immovable = true;
		this.colour = colour;
	}
}
