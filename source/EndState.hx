import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class EndState extends FlxState {
	override public function create():Void {
		bgColor = 0xff2d2d2d;

		var text = new FlxText(0, 0, "Thanks for playing my game!\n\nSorry I didn't finish it ;-)", 16);
		text.alignment = FlxTextAlign.CENTER;
		text.borderColor = FlxColor.BLACK;
		text.borderSize = 2;
		text.borderStyle = FlxTextBorderStyle.OUTLINE;
		text.screenCenter();
		add(text);

		super.create();
	}
}
