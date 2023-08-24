import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:pc_activity/components/collision_block.dart';
import 'package:pc_activity/components/custom_hitbox.dart';
import 'package:pc_activity/components/utils.dart';
import 'package:pc_activity/game_activity.dart';

enum PlayerState{
  idleR, idleL, idleU, idleD, runningR, runningL, runningU, runningD, deathD
}

class Player extends SpriteAnimationGroupComponent with HasGameRef<GameActivity>, KeyboardHandler{

  final List<String> movementInstructions;

  Player({position, priority, required this.movementInstructions}) : super(position: position, priority: priority);

  int currentInstructionIndex = 0;
  late final SpriteAnimation idleRightAnimation;
  late final SpriteAnimation idleLeftAnimation;
  late final SpriteAnimation idleUpAnimation;
  late final SpriteAnimation idleDownAnimation;
  late final SpriteAnimation runningRightAnimation;
  late final SpriteAnimation runningLeftAnimation;
  late final SpriteAnimation runningUpAnimation;
  late final SpriteAnimation runningDownAnimation;
  late final SpriteAnimation downDeathAnimation;
  late final SpriteAnimation rightDeathAnimation;
  late final SpriteAnimation leftDeathAnimation;
  late final SpriteAnimation upDeathAnimation;

  late final double startPositionX;
  late final double startPositionY;

  final double stepTime= 0.2;

  List<CollisionBlock> collisionBlocks=[];

  CustomHitbox hitbox= CustomHitbox(
    offSetX: 8,
    offSetY: 10,
    width: 16,
    height: 16
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    add(RectangleHitbox(
      position: Vector2(hitbox.offSetX, hitbox.offSetY),
      size: Vector2(hitbox.width, hitbox.height)
    ));
    startPositionX=position.x;
    startPositionY=position.y;
    debugMode= false;
    return super.onLoad();
  }
  
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

    final isLeftKeyPressed= keysPressed.contains(LogicalKeyboardKey.keyA) ||
                            keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed= keysPressed.contains(LogicalKeyboardKey.keyD) ||
                            keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed= keysPressed.contains(LogicalKeyboardKey.keyW) ||
                            keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed= keysPressed.contains(LogicalKeyboardKey.keyS) ||
                            keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isSecuenceKeyPressed= keysPressed.contains(LogicalKeyboardKey.keyQ);

    if((isLeftKeyPressed && isUpKeyPressed) || (isRightKeyPressed && isUpKeyPressed)
    || (isLeftKeyPressed && isDownKeyPressed) || (isRightKeyPressed && isDownKeyPressed)){
      
    }else{
      if(isSecuenceKeyPressed){
        _execute();
      }
      if(isLeftKeyPressed){
        _executeInstruction('izquierda');
      }
      if(isRightKeyPressed){
        _executeInstruction('derecha');
      }
      if(isUpKeyPressed){
        _executeInstruction('arriba');
      }
      if(isDownKeyPressed){
        _executeInstruction('abajo');
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  Future<void> _executeInstruction(String instruction) async{
    final block= _checkNextBlockForCollision(instruction);
    if (block.type=='err') {
      print('Hubo un error');
    }
    if(instruction=='derecha'){
      if(block.type=='null'){
        current= PlayerState.runningR;
        add(MoveByEffect(Vector2(16, 0), EffectController(duration: 0.333)));
        await Future.delayed(const Duration(milliseconds: 333));
        current= PlayerState.idleR;
      }
    }
    if(instruction=='izquierda'){
      if(block.type=='null'){
        current= PlayerState.runningL;
        add(MoveByEffect(Vector2(-16, 0), EffectController(duration: 0.333)));
        await Future.delayed(const Duration(milliseconds: 333));
        current= PlayerState.idleL;
      }
    }
    if(instruction=='arriba'){
      
      if(block.type=='null'){
        current= PlayerState.runningU;
        add(MoveByEffect(Vector2(0, -16), EffectController(duration: 0.333)));
        await Future.delayed(const Duration(milliseconds: 333));
        current= PlayerState.idleU;
      }
    }
    if(instruction=='abajo'){
      if(block.type=='null'){
        current= PlayerState.runningD;
        add(MoveByEffect(Vector2(0, 16), EffectController(duration: 0.333)));
        await Future.delayed(const Duration(milliseconds: 333));
        current= PlayerState.idleD;
      }
      
      /*print(position.y);
      if(position.y>=55){
        _hitSpikes();
      }*/
    }
    currentInstructionIndex+=1;
    
  }

  void _loadAllAnimations() {
    idleRightAnimation= _spriteAnimationsGenerator('right', 'idle', 2);
    idleLeftAnimation= _spriteAnimationsGenerator('left', 'idle', 2);
    idleUpAnimation= _spriteAnimationsGenerator('up', 'idle', 2);
    idleDownAnimation= _spriteAnimationsGenerator('down', 'idle', 2);
    runningRightAnimation= _spriteAnimationsGenerator('right', 'run', 4);
    runningLeftAnimation= _spriteAnimationsGenerator('left', 'run', 4);
    runningUpAnimation= _spriteAnimationsGenerator('up', 'run', 4);
    runningDownAnimation= _spriteAnimationsGenerator('down', 'run', 4);
    downDeathAnimation= _spriteAnimationsGenerator('down', 'death', 7);
    /*rightDeathAnimation= _spriteAnimationsGenerator('right', 'death', 7);
    leftDeathAnimation= _spriteAnimationsGenerator('left', 'death', 7);
    upDeathAnimation= _spriteAnimationsGenerator('up', 'death', 6);*/
    //Lista de todas las animaciones
    animations= {
      PlayerState.idleR: idleRightAnimation,
      PlayerState.idleL: idleLeftAnimation,
      PlayerState.idleU: idleUpAnimation,
      PlayerState.idleD: idleDownAnimation,
      PlayerState.runningR: runningRightAnimation,
      PlayerState.runningL: runningLeftAnimation,
      PlayerState.runningU: runningUpAnimation,
      PlayerState.runningD: runningDownAnimation,
      PlayerState.deathD: downDeathAnimation,
      
    };
    current= PlayerState.idleR;
  }

  SpriteAnimation _spriteAnimationsGenerator(String direction, String state, int amount) {

    SpriteAnimation spriteAnimation= SpriteAnimation.fromFrameData(
      game.images.fromCache('character/$state-$direction.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),

      )
    );
    return spriteAnimation;
  }
  
  void _execute() async{
    for (var movement in movementInstructions) {
          final instruction= movement;
          await _executeInstruction(instruction);
        }
  }
  
  void _hitSpikes() {
    const hitDuration= Duration(milliseconds: 1200);
    current= PlayerState.deathD;
    
    Future.delayed(hitDuration, ()  {
      scale.x=1;
      current= PlayerState.idleR;
      position=Vector2(40, 24);
    });
  }
  CollisionBlock _checkNextBlockForCollision(String direction){
    final playerX = playerXPosition(this);
    final playerY = playerYPosition(this);
    List<CollisionBlock> sortedCollidables = collisionBlocks.toList()
    ..sort((a, b) {
      int distanceComparison = a.distanceTo(this).compareTo(b.distanceTo(this));
      
      if(distanceComparison==0){
        String directionA = a.getDirectionRelativeToPlayer(this);
        String directionB = b.getDirectionRelativeToPlayer(this);
    
        if (direction == directionA && direction != directionB) {
          return -1; // Bloque A tiene prioridad sobre bloque B

        } else if (direction == directionB && direction != directionA) {
          return 1; // Bloque B tiene prioridad sobre bloque A

        }
      }
      return distanceComparison;
    });

    for (final block in sortedCollidables) {
      switch(direction){
        case 'derecha':
        
          if(playerX+16==block.x && playerY==block.y){
            print('Colision a la derecha');
            return block;
          }else{
            return CollisionBlock();
          }
        case 'izquierda':
          if(playerX==block.x+block.width && playerY==block.y){
            print('Colision a la izquierda');
            return block;
          }else{
            return CollisionBlock();
          }
        case 'arriba':
          if(playerY==block.y+block.height && playerX==block.x){
            print('Colision a la arriba');
            return block;
          } else{
            return CollisionBlock();
          }
        case 'abajo':
          if(playerY+16==block.y && playerX==block.x){
            print('Colision a la abajo');
            return block;
          } else{
            return CollisionBlock();
          }
      }
    }

    return CollisionBlock(type: 'err');
  }
}