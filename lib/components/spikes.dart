import 'dart:async';

import 'package:flame/components.dart';
import 'package:pc_activity/game_activity.dart';

class Spikes extends SpriteAnimationComponent with HasGameRef<GameActivity>{
  
  Spikes(position, size) : super(position: position, size: size);

  final double stepTime= 0.1;

  @override
  FutureOr<void> onLoad() {
    

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('spikes.png'),
      SpriteAnimationData.sequenced(
        amount: 10, 
        stepTime: stepTime, 
        textureSize: Vector2.all(16)
      )
    );
    debugMode= false;
    return super.onLoad();
  }
}