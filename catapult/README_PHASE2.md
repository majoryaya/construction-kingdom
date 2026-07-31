Phase 2 notes:

This branch contains Slingshot and Projectile scenes plus AudioManager.

How to test Phase 2:
1. Add catapult/scripts/AudioManager.gd to Autoload as 'AudioManager' in Project Settings.
2. Assign audio streams for sfx_slingshot_stretch, sfx_bird_launch and optional music_background.
3. Create the project scenes: open catapult/scenes/Slingshot.tscn and catapult/scenes/Projectile.tscn in the editor.
4. Ensure the Projectile.tscn has a CollisionShape2D and Sprite texture assigned; set a reasonable mass (1.0).
5. In Slingshot node inspector, set projectile_scene to preload("res://catapult/scenes/Projectile.tscn").
6. Run the Slingshot scene: you should hear background music (if assigned), see predicted trajectory while dragging, and the same behaviors from Phase 1.

If you want, I can also create a minimal main scene that instantiates Slingshot and sets it as the default run scene.
