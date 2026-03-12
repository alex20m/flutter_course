import 'package:flutter/material.dart';
import '../models/maze_level.dart';
import '../utils/progress_manager.dart';
import 'level_selection_screen.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final MazeLevel level;
  final bool won;

  const ResultScreen({super.key, required this.level, required this.won});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.won) {
      ProgressManager.markLevelCompleted(widget.level.levelNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final maxWidth = isWide ? 800.0 : double.infinity;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.won ? Icons.emoji_events : Icons.refresh,
                size: isWide ? 120 : 80,
                color: widget.won ? Colors.amber : Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                widget.won ? 'Level Complete!' : 'Try Again!',
                style: TextStyle(
                  fontSize: isWide ? 48 : 36,
                  fontWeight: FontWeight.bold,
                  color: widget.won ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 40),
              if (widget.won) ...[
                ElevatedButton(
                  onPressed: () {
                    final nextLevel = widget.level.levelNumber + 1;
                    final allLevels = MazeLevel.getAllLevels();
                    
                    if (nextLevel <= allLevels.length) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            level: allLevels[nextLevel - 1],
                          ),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LevelSelectionScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 50 : 30,
                      vertical: isWide ? 16 : 12,
                    ),
                    textStyle: TextStyle(fontSize: isWide ? 20 : 18),
                  ),
                  child: Text(
                    widget.level.levelNumber < MazeLevel.getAllLevels().length
                        ? 'Next Level'
                        : 'Back to Levels',
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(level: widget.level),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 50 : 30,
                    vertical: isWide ? 16 : 12,
                  ),
                  textStyle: TextStyle(fontSize: isWide ? 20 : 18),
                ),
                child: const Text('Retry Level'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectionScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 50 : 30,
                    vertical: isWide ? 16 : 12,
                  ),
                  textStyle: TextStyle(fontSize: isWide ? 20 : 18),
                ),
                child: const Text('Back to Levels'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
