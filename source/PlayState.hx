package;

import Powerup.ClearEverything;
import Powerup.SizeIncrease;
import Powerup.SpeedIncrease;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import js.lib.intl.DateTimeFormat;

class PlayState extends FlxState {
	var player:Player;
	var tiles:FlxTypedGroup<Tile>;
	var walls:FlxGroup;

	var timeLeftText:FlxText;
	var scoreText:FlxText;

	var leafedSpawnCooldown:Float = 3;
	var leafSpawnTime:Float = 3;
	var powUps:FlxTypedGroup<Powerup>;

	override public function create() {
		trace('playing');
		player = new Player(0, 0);
		tiles = new FlxTypedGroup<Tile>();
		super.create();
		for (i in 0...8) {
			for (j in 0...8) {
				tiles.add(new Tile(i * 32, j * 32));
			}
		}

		timeLeftText = new FlxText(16, 16, 0, '02:00', 12);
		timeLeftText.alpha = .55;
		timeLeftText.borderSize = 1;
		timeLeftText.borderColor = FlxColor.BLACK;
		timeLeftText.borderStyle = FlxTextBorderStyle.OUTLINE;
		scoreText = new FlxText(0, 16, 0, '02:00', 12);
		scoreText.alpha = .55;
		scoreText.borderSize = 1;
		scoreText.borderColor = FlxColor.BLACK;
		scoreText.borderStyle = FlxTextBorderStyle.OUTLINE;

		add(tiles);
		add(player);
		walls = FlxCollision.createCameraWall(FlxG.camera, true, 1);
		add(walls);
		add(timeLeftText);
		add(scoreText);
		powUps = new FlxTypedGroup<Powerup>();
		add(powUps);
		#if debug
		FlxG.debugger.drawDebug = true;
		#end
		for (n in tiles.members) {
			n.y += 12;
			n.x += 12;
		}
		leafWeightsArr = [.75, .15, .10];
		FlxG.mouse.visible = false;
		// FlxG.camera.follow(player, LOCKON, 1);
		FlxG.sound.playMusic('assets/music/hoshi_hana_tough_fight.wav', 1.0, true);
		// FlxG.camera.setScrollBounds(0, 32 * 8, 0, 32 * 8);
	}

	var leafedTiles:Array<Tile> = [];

	var roundTime:Float = 60 * 2;
	var thing = 0;
	var leafWeightsArr = [.75, .15, .10];

	var timeBe4NextPowerup:Float = 20;
	var powerUpTimer = 0.0;
	var powUpsInts = [0, 1, 2];
	var powUpsWeights = [.40, .40, .20];

	override public function update(elapsed:Float) {
		#if debug
		if (FlxG.keys.justPressed.K) {
			openSubState(new GameEndSubstate(true));
		}
		else if (FlxG.keys.justPressed.L) {
			openSubState(new GameEndSubstate(false));
		}
		#end
		super.update(elapsed);
		FlxG.collide(player, walls);
		leafedTiles = tiles.members.filter(t -> {
			return t.hasLeaves;
		});

		powerUpTimer += elapsed;
		if (powerUpTimer >= timeBe4NextPowerup) {
			powerUpTimer = 0;
			timeBe4NextPowerup = FlxG.random.float(25, 35);
			var i = FlxG.random.getObject(powUpsInts, powUpsWeights);
			if (i == 0) {
				powUps.add(new SpeedIncrease(FlxG.random.float(0, FlxG.width - 1), FlxG.random.float(0, FlxG.height - 1)));
			}
			else if (i == 1) {
				powUps.add(new SizeIncrease(FlxG.random.float(0, FlxG.width - 1), FlxG.random.float(0, FlxG.height - 1)));
			}
			else if (i == 2) {
				powUps.add(new ClearEverything(FlxG.random.float(0, FlxG.width - 1), FlxG.random.float(0, FlxG.height - 1)));
			}
		}
		for (i in leafedTiles) {
			if (player.overlaps(i)) {
				player.eatLeaf(i);
			}
		}

		for (i in powUps.members) {
			if (FlxG.overlap(player, i)) {
				i.onPowerup(player);
				powUps.remove(i);
			}
		}

		leafSpawnTime += elapsed;
		if (leafSpawnTime >= leafedSpawnCooldown) {
			var tileNo = FlxG.random.getObject([1, 2, 3], leafWeightsArr);
			for (i in 0...tileNo) {
				var l = FlxG.random.getObject(tiles.members);
				// imlazy
				while (l.hasLeaves) {
					l = FlxG.random.getObject(tiles.members);
					if (leafedTiles.length == tiles.length) {
						break;
					}
				}

				l.addLeaves();
			}
			leafSpawnTime = 0;
		}

		roundTime -= elapsed;

		if (roundTime <= 90) {
			leafedSpawnCooldown = 2;
			leafWeightsArr = [.70, .20, .10];
		}
		if (roundTime <= 60) {
			leafedSpawnCooldown = 1.5;
			leafWeightsArr = [.60, .25, .15];
		}
		if (roundTime <= 30) {
			leafWeightsArr = [.50, .30, .20];
			leafedSpawnCooldown = .65;
		}
		if (leafedTiles.length == tiles.members.length) {
			openSubState(new GameEndSubstate(false));
		}
		if (roundTime <= 0) {
			openSubState(new GameEndSubstate(true));
		}

		timeLeftText.text = "Time Left: " + FlxStringUtil.formatTime(roundTime);
		scoreText.text = "Score: " + Game.currentGameScore;
		scoreText.x = FlxG.width - scoreText.width - 16;
	}

	var cooldownHit:Bool = false;
}
