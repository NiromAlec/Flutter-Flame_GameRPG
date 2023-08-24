import 'dart:math';

import 'package:flame/components.dart';
import 'package:pc_activity/components/player.dart';
import 'package:pc_activity/components/utils.dart';

class CollisionBlock extends PositionComponent{

  String type;
  CollisionBlock({
    position, 
    size,
    this.type= 'null',
  }) : super(
        position: position, 
        size: size
      ) {
        debugMode= false;
      }
  
  double distanceTo(Player player) {
    double deltaX = x - playerXPosition(player);
    double deltaY = y - playerYPosition(player);
    double distance = sqrt(deltaX * deltaX + deltaY * deltaY);
    return distance;
  }

  // Método para obtener la dirección del bloque en relación con la posición del jugador
  String getDirectionRelativeToPlayer(Player player) {
    if (x < playerXPosition(player) && y == playerYPosition(player)) {
      return 'izquierda';
    } else if (x > playerXPosition(player) && y == playerYPosition(player)) {
      return 'derecha';
    } else if (y < playerYPosition(player) && x == playerXPosition(player)) {
      return 'arriba';
    } else if (y > playerYPosition(player) && x == playerXPosition(player)) {
      return 'abajo';
    }
    return ''; // Dirección por defecto si el bloque está en la misma posición que el jugador
  }

  // Método para priorizar el bloque adecuado en caso de empate
  double getPriority(String instruction){
    switch (instruction) {
      case 'arriba':
      print(-y);
        return -y; // Prioriza bloque arriba si el jugador se mueve hacia arriba
      case 'abajo':
      print(y);
        return y; // Prioriza bloque abajo si el jugador se mueve hacia abajo
      case 'izquierda':
      print(-x);
        return -x; // Prioriza bloque a la izquierda si el jugador se mueve hacia la izquierda
      case 'derecha':
      print(x);
        return x; // Prioriza bloque a la derecha si el jugador se mueve hacia la derecha
    }
    return 0; // No prioriza si el jugador no se mueve
  }

}