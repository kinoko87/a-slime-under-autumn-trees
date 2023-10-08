package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameEndSubstate extends FlxSubState {
	var won:Bool;

	public function new(win:Bool) {
		super();
		trace("LOL!");
		won = win;
	}

	var bg:FlxSprite;
	var header:FlxText;
	var highscore:FlxText;
	var playAgain:FlxText;
	var backToMenu:FlxText;

	override function create() {
		if (Game.currentGameScore > Game.highscore) {
			Game.highscore = Game.currentGameScore;
		}
		bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		bg.alpha = .75;
		header = new FlxText(0, 0, 0, "You win!", 32);
		if (!won)
			header.text = "You lost!";
		header.setPosition(FlxG.width / 2 - header.width / 2, 40);
		highscore = new FlxText(header.x, header.y + header.height + 24, 0, "Score: " + Game.currentGameScore + " | Highscore: " + Game.highscore, 12);
		playAgain = new FlxText(highscore.x, highscore.y + highscore.height + 24, 0, "Play Again", 12);
		backToMenu = new FlxText(playAgain.x, playAgain.y + playAgain.height + 24, 0, "Back to Menu", 12);
		header.borderSize = 1;
		header.antialiasing = false;
		header.borderColor = FlxColor.BLACK;
		header.borderStyle = FlxTextBorderStyle.OUTLINE;
		playAgain.borderSize = 1;
		playAgain.borderColor = FlxColor.BLACK;
		playAgain.borderStyle = FlxTextBorderStyle.OUTLINE;
		backToMenu.borderSize = 1;
		backToMenu.borderColor = FlxColor.BLACK;
		backToMenu.borderStyle = FlxTextBorderStyle.OUTLINE;
		highscore.borderSize = 1;
		highscore.borderColor = FlxColor.BLACK;
		highscore.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(bg);
		add(header);
		add(highscore);
		add(playAgain);
		add(backToMenu);
		FlxG.sound.music.stop();
		if (!won)
			FlxG.sound.play('assets/music/the_bizniss_scratch_4.wav');
		else
			FlxG.sound.play('assets/music/MLAudio_game_win_success.wav');
		Game.currentGameScore = 0;
		FlxG.mouse.visible = true;
		super.create();
	}

	override function update(elapsed:Float) {
		if (FlxG.mouse.overlaps(playAgain) && FlxG.mouse.justPressed) {
			FlxG.resetState();
			trace('playagain');
			close();
		}
		else if (FlxG.mouse.overlaps(backToMenu) && FlxG.mouse.justPressed) {
			FlxG.switchState(new MenuState());
			trace('backtomenu');
			close();
		}
		super.update(elapsed);
	}
}
