import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:pc_activity/game_activity.dart';

class TopObstacles extends SpriteAnimationComponent with HasGameRef<GameActivity>{
  
  String name;
  TopObstacles(position, size, this.name) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    animation= Sprite(
      game.images.fromCache('$name.png'),
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(16, 16)
    ) as SpriteAnimation?;
    return super.onLoad();
  }
} 