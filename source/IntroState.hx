import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class IntroState extends FlxState {
	var gap = 20;

	override public function create():Void {
		bgColor = 0xff2d2d2d;

		var text = new FlxText(0, 0, "No No Solo", 32);
		text.alignment = FlxTextAlign.CENTER;
		text.borderColor = FlxColor.BLACK;
		text.borderSize = 2;
		text.borderStyle = FlxTextBorderStyle.OUTLINE;
		text.screenCenter();
		text.y -= gap;
		add(text);

		var button = new FlxButton("Play", () -> FlxG.switchState(new PlayState()));
		button.screenCenter();
		button.y += gap;
		add(button);

		super.create();
	}
}
