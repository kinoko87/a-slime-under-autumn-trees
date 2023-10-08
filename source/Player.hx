package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Player extends FlxSprite {
	public var timeToEatLeaf:Float = 0.35;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/player.png", true, 12, 7);
		animation.add('front', [0], 0);
		animation.add('right', [1], 0);
		animation.add('back', [2], 0);
		animation.add('left', [3], 0);
		animation.add('spin', [0, 1, 2, 3], 12);
		scale.set(2, 2);
		updateHitbox();
	}

	inline static var FFRONT = 0;
	inline static var FRIGHT = 1;
	inline static var FBACK = 2;
	inline static var FLEFT = 3;

	public var speed:Float = 32 * 3;
	public var canMove:Bool = true;

	var dir:Int;

	override function update(elapsed:Float) {
		movement();
		animate();
		super.update(elapsed);
	}

	function movement() {
		if (!canMove) {
			velocity.set(0, 0);
			return;
		}
		if (FlxG.keys.anyPressed([DOWN, S])) {
			dir = FFRONT;
			velocity.set(0, speed);
		}
		else if (FlxG.keys.anyPressed([RIGHT, D])) {
			dir = FRIGHT;
			velocity.set(speed, 0);
		}
		else if (FlxG.keys.anyPressed([UP, W])) {
			dir = FBACK;
			velocity.set(0, -speed);
		}
		else if (FlxG.keys.anyPressed([LEFT, A])) {
			dir = FLEFT;
			velocity.set(-speed, 0);
		}
		else {
			velocity.set(0, 0);
		}
	}

	function animate() {
		if (dir == FFRONT)
			animation.play('front');
		else if (dir == FRIGHT)
			animation.play('right');
		else if (dir == FBACK)
			animation.play('back');
		else if (dir == FLEFT)
			animation.play('left');
	}

	var eatingLeaf:Bool = false;

	public function eatLeaf(t:Tile, ?insta:Bool = false) {
		if (!t.hasLeaves)
			return;
		canMove = false;
		if (insta) {
			// canMove = true;
			t.removeLeaves();
			eatingLeaf = false;
			trace('eated leaf');
			Game.currentGameScore += 15;
			return;
		}
		if (!eatingLeaf) {
			eatingLeaf = true;
			new FlxTimer().start(timeToEatLeaf, _ -> {
				canMove = true;
				t.removeLeaves();
				eatingLeaf = false;
				trace('eated leaf');
				Game.currentGameScore += 15;
			});
		}
	}
}
