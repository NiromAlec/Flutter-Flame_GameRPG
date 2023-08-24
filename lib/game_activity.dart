import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:pc_activity/components/level.dart';
import 'package:pc_activity/components/player.dart';

class GameActivity extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{
  
  @override
  Color backgroundColor()=> Color.fromARGB(255, 37, 19, 26);
  late final CameraComponent cam;
  Player player= Player(movementInstructions: ['derecha', 'derecha', 'derecha', 'arriba', 'abajo'],);
  
  @override
  FutureOr<void> onLoad() async{

    //Carga todas las imagenes en cache
    await images.loadAllImages();
    final world = Level(levelName: 'Level-01', player: player);

    cam = CameraComponent.withFixedResolution(world: world, width: 192, height: 192);
    cam.viewfinder.anchor= Anchor.topLeft;
    addAll([cam, world]);
    return super.onLoad();
  }

}