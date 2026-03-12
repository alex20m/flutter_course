import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../models/maze_level.dart';
import '../game/maze_game.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final MazeLevel level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MazeGame game;

  @override
  void initState() {
    super.initState();
    game = MazeGame(
      level: widget.level,
      onGameEnd: (won) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              level: widget.level,
              won: won,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final maxWidth = isWide ? 800.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level.levelNumber}'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tap adjacent cells to move to the green goal!',
                  style: TextStyle(
                    fontSize: isWide ? 18 : 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: GameWidget(game: game),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
