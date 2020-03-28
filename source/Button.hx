import flixel.FlxSprite;

class Button extends FlxSprite {
	public var block:FlxSprite;

	var pressedBy:Array<Moveable>;

	public function new(X:Float, Y:Float, ?block:FlxSprite) {
		super(X, Y, "assets/images/button.png");
		this.block = block;

		pressedBy = new Array<Moveable>();
	}

	public function pressed(obj:Moveable):Void {
		if (pressedBy.indexOf(obj) < 0) {
			pressedBy.push(obj);
			updateBlock();
		}
	}

	function checkStillPressed():Void {
		for (obj in pressedBy) {
			if (!obj.overlaps(this)) {
				pressedBy.remove(obj);
				updateBlock();
			}
		}
	}

	function updateBlock():Void {
		if (block != null)
			block.visible = pressedBy.length == 0;
	}

	override public function update(elapsed:Float):Void {
		checkStillPressed();
		super.update(elapsed);
	}
}
