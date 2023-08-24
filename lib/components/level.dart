import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pc_activity/components/collision_block.dart';
import 'package:pc_activity/components/player.dart';
import 'package:pc_activity/components/spikes.dart';
import 'package:pc_activity/game_activity.dart';

class Level extends World with HasGameRef<GameActivity>{

  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks=[];


  @override
  FutureOr<void> onLoad() async{
    level= await TiledComponent.load('Level-01.tmx', Vector2(16, 16));
    add(level);
    final spawnPointsLayer= level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null){
      for(final spawnPoint in spawnPointsLayer.objects){
        switch(spawnPoint.class_){
          case 'Player':
            player.position= Vector2(spawnPoint.x, spawnPoint.y);
            player.priority= 1;
            add(player);
            break;
          case 'Spikes':
            final spikes= Spikes(
              Vector2(spawnPoint.x, spawnPoint.y), 
              Vector2(spawnPoint.width, spawnPoint.height)
            );
            add(spikes);
            break;
          case 'Top_Obstacles':
            String name= spawnPoint.name;
            final image= SpriteComponent.fromImage(
              game.images.fromCache('$name.png'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(16, 16)
            );
            image.priority=2;
            add(image);
            break;
          case 'Down_Obstacles':
            String name= spawnPoint.name;
            final image= SpriteComponent.fromImage(
              game.images.fromCache('$name.png'),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(16, 16)
            );
            add(image);
            break;
          default:
        }
      }
    }

    final collisionsLayer= level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null){
      for(final collision in collisionsLayer.objects){
        switch(collision.class_){
          case 'Wall':
            final block= CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              type: collision.name,
            );

            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks= collisionBlocks;
    return super.onLoad();
  }
}