package;

import flixel.FlxG;
import flixel.FlxSprite;

class Tile extends FlxSprite {
	public var hasLeaves:Bool;

	static var angles = [0, 90, 180, 270];

	public function new(?x:Float, ?y:Float) {
		super(x, y);
		loadGraphic('assets/images/tiles.png', true, 16, 16);
		animation.add('default', [0], 0);
		animation.add('leaves', [1], 0);
		scale.set(.75, .75);
		updateHitbox(); // lazy fuckery
		scale.set(2, 2);
		angle = angles[FlxG.random.int(0, 3)];
	}

	public function addLeaves() {
		hasLeaves = true;
		animation.play('leaves');
	}

	public function removeLeaves() {
		hasLeaves = false;
		animation.play('default');
	}
}
