package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class MenuState extends FlxState {
	var credsTxt:FlxText;
	var playTxt:FlxText;

	var header:FlxText;

	public function new() {
		trace('at menu');
		super();
		// play();
	}

	var bg:FlxSprite;

	override function create() {
		if (Game.currentGameScore > Game.highscore) {
			Game.highscore = Game.currentGameScore;
		}
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.ORANGE);
		header = new FlxText(0, 0, 0, "a slime\nunder autumn trees", 16);
		header.setPosition(FlxG.width / 2 - header.width / 2, 40);
		playTxt = new FlxText(header.x, header.y + header.height + 16 * 2, 0, "Play", 12);
		credsTxt = new FlxText(playTxt.x, playTxt.y + playTxt.height + 16, 0, Assets.getText('assets/data/CREDITS.txt'), 8);
		header.borderSize = 1;
		header.antialiasing = false;
		header.borderColor = FlxColor.BLACK;
		header.borderStyle = FlxTextBorderStyle.OUTLINE;
		playTxt.borderSize = 1;
		playTxt.borderColor = FlxColor.BLACK;
		playTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		credsTxt.borderSize = 1;
		credsTxt.borderColor = FlxColor.BLACK;
		credsTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
		FlxG.sound.playMusic('assets/music/mebequack_short_chiptune_loop.wav', 1.0, true);

		add(bg);
		add(header);
		add(playTxt);
		add(credsTxt);
		FlxG.mouse.visible = true;

		super.create();
	}

	override function update(elapsed:Float) {
		if (FlxG.mouse.overlaps(playTxt) && FlxG.mouse.pressed) {
			if (Game.cutsceneNeverPlayedBefore) {
				FlxG.switchState(new Cutscene());
			}
			else
				play();
		}
		super.update(elapsed);
	}

	function play() {
		FlxG.switchState(new PlayState());
	}

	function settings() {}
}
