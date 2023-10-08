package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class Cutscene extends FlxState {
	public function new() {
		super();
	}

	public override function create() {
		add(new FlxSprite().loadGraphic('assets/images/cutscene.png'));
		super.create();
		FlxG.mouse.visible = false;
		FlxG.sound.music.stop();
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.ANY || FlxG.mouse.justPressed || FlxG.mouse.justPressedRight || FlxG.mouse.justPressedMiddle) {
			Game.cutsceneNeverPlayedBefore = false;
			FlxG.switchState(new PlayState());
		}
		super.update(elapsed);
	}
}
