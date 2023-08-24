double playerXPosition(player){
  return (player.position.x + player.hitbox.offSetX).round();
}
double playerYPosition(player){
  return (player.position.y + player.hitbox.offSetY).round();
}