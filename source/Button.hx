import flixel.FlxObject;
import flixel.FlxSprite;

class Button extends FlxSprite {
	public var block:FlxSprite;
	public var isPressed:Bool = false;

	public function new(X:Float, Y:Float, ?block:FlxSprite) {
		super(X, Y);
		this.block = block;

		loadGraphic(AssetPaths.block__png);

		flixel.FlxG.watch.add(this, "isPressed");
	}

	override public function update(elapsed:Float):Void {
		if (block.visible == isPressed) {
			block.visible = !isPressed;
			block.allowCollisions = isPressed ? FlxObject.NONE : FlxObject.ANY;
		}

		super.update(elapsed);
	}
}
