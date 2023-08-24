import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pc_activity/game_activity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final GameActivity game = GameActivity();
  runApp(GameWidget(game: kDebugMode ? GameActivity(): game));


}

