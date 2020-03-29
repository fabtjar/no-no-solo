class Box extends Moveable {
	public function new(state:PlayState, x:Float, y:Float) {
		super(state, x, y, "assets/images/box.png");
		canGoInWater = true;
	}
}
