package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

abstract class Powerup extends FlxSprite {
	public var powerupTime:Float;

	public function new(?x:Float, ?y:Float) {
		super(x, y);
	}

	public function onPowerup(player:Player) {
		new FlxTimer().start(powerupTime, _ -> {
			removePowerup(player);
		});
	}

	public function removePowerup(player:Player) {}
}

class SpeedIncrease extends Powerup {
	public function new(?x:Float, ?y:Float) {
		super(x, y);
		powerupTime = 15;
		loadGraphic('assets/images/speed_apple.png');
		updateHitbox();
	}

	public override function onPowerup(player:Player) {
		player.speed = 32 * 5;
		player.timeToEatLeaf = .1;
		player.color = FlxColor.BLUE;
		super.onPowerup(player);
	}

	public override function removePowerup(player:Player) {
		player.speed = 32 * 3;
		player.timeToEatLeaf = .35;
		player.color = FlxColor.WHITE;
	}
}

class ClearEverything extends Powerup {
	public function new(?x:Float, ?y:Float) {
		super(x, y);
		powerupTime = .5;
		loadGraphic('assets/images/clear_everything_blackhole.png');
	}

	public override function onPowerup(player:Player) {
		player.canMove = false;
		player.color = FlxColor.BLACK;
		// fuckery
		var st = cast(FlxG.state, PlayState);
		@:privateAccess
		st.tiles.forEach(function(t) {
			player.eatLeaf(t, true);
		});
		super.onPowerup(player);
	}

	public override function removePowerup(player:Player) {
		updateHitbox();
		player.color = FlxColor.WHITE;
		player.canMove = true;
	}
}

class SizeIncrease extends Powerup {
	public function new(?x:Float, y:Float) {
		super(x, y);
		powerupTime = 10;
		loadGraphic('assets/images/size_increase_mushroom.png');
	}

	public override function onPowerup(player:Player) {
		player.scale.set(6, 6);
		player.timeToEatLeaf = 0;
		player.big = true;
		super.onPowerup(player);
	}

	public override function removePowerup(player:Player) {
		player.scale.set(2, 2);
		player.timeToEatLeaf = .35;
		player.big = false;
		updateHitbox();
		super.removePowerup(player);
	}
}
