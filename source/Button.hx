import flixel.FlxSprite;

class Button extends FlxSprite {
	public var block:FlxSprite;
	public var isPressed:Bool = false;

	public function new(X:Float, Y:Float, ?block:FlxSprite) {
		super(X, Y, "assets/images/button.png");
		this.block = block;
	}

	override public function update(elapsed:Float):Void {
		if (block != null && block.visible == isPressed)
			block.visible = !isPressed;

		super.update(elapsed);
	}
}
