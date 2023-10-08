package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Intro extends FlxState {
	var textBlocks:FlxSpriteGroup;

	public function new() {
		super();
	}

	override function create() {
		textBlocks = new FlxSpriteGroup();
		add(textBlocks);
		textBlocks.add(addLetter('s', 16, 16));
		textBlocks.add(addLetter('h', 32 + 2, 16));
		textBlocks.add(addLetter('i', 48 + 4, 16));
		textBlocks.add(addLetter('m', 64 + 6, 16));
		textBlocks.add(addLetter('e', 80 + 8, 16));
		textBlocks.add(addLetter('j', 96 + 10, 16));
		textBlocks.add(addLetter('i', 112 + 12, 16));
		textBlocks.add(addLetter('8', 128 + 14, 16));
		textBlocks.add(addLetter('7', 144 + 16, 16));

		textBlocks.add(fallJamSprite(144 + 16 + 32, 16, 'fall'));
		textBlocks.add(fallJamSprite(144 + 16 + 32, 32 + 2, 'jam'));
		textBlocks.add(fallJamSprite(144 + 16 + 32, 48 + 4, '23'));

		var ti = 0.0;
		for (t in textBlocks.members) {
			var ogy = t.y;
			t.y = -ogy;
			FlxTween.tween(t, {y: ogy}, .5 + ti, {ease: FlxEase.bounceOut});
			ti += .03;
		}
		FlxG.mouse.visible = false;
		new FlxTimer().start(.5 + .03 * textBlocks.length + .4, _ -> {
			var o = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			o.alpha = 0;
			add(o);
			FlxTween.tween(o, {alpha: 1}, 1, {
				onComplete: _ -> {
					FlxG.switchState(new MenuState());
				}
			});
		});

		super.create();
	}

	function addLetter(l:String, ?x:Float, ?y:Float) {
		var s = shimejiSprite();
		s.setPosition(x, y);
		s.animation.play(l.toLowerCase());
		return s;
	}

	function fallJamSprite(?x:Float, ?y:Float, a:String) {
		var s = new FlxSprite(x, y);
		s.antialiasing = false;
		s.updateHitbox();
		s.loadGraphic('assets/pre/fallJamMotifThing.png', true, 8, 8);
		s.animation.add('fall', [0], 0);
		s.animation.add('jam', [1], 0);
		s.animation.add('23', [2], 0);
		s.scale.set(2, 2);
		s.updateHitbox();
		s.animation.play(a);
		return s;
	}

	function shimejiSprite() {
		var s = new FlxSprite();
		s.antialiasing = false;
		s.loadGraphic('assets/pre/introname_x8.png', true, 8, 8);
		s.animation.add('b1', [0], 0);
		s.animation.add('b2', [1], 0);
		s.animation.add('s', [2], 0);
		s.animation.add('h', [3], 0);
		s.animation.add('i', [4], 0);
		s.animation.add('m', [5], 0);
		s.animation.add('e', [6], 0);
		s.animation.add('j', [7], 0);
		s.animation.add('8', [8], 0);
		s.animation.add('7', [9], 0);
		s.scale.set(2, 2);
		s.updateHitbox();
		return s;
	}
}
