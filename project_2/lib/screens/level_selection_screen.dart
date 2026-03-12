import 'package:flutter/material.dart';
import '../models/maze_level.dart';
import '../utils/progress_manager.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  List<bool> completedLevels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final statuses = await ProgressManager.getAllLevelsStatus(3);
    setState(() {
      completedLevels = statuses;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final maxWidth = isWide ? 800.0 : double.infinity;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final levels = MazeLevel.getAllLevels();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.all(24.0),
          child: isWide
              ? _buildWideLayout(levels)
              : _buildNarrowLayout(levels),
        ),
      ),
    );
  }

  Widget _buildWideLayout(List<MazeLevel> levels) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: levels.length,
      itemBuilder: (context, index) => _buildLevelCard(levels[index]),
    );
  }

  Widget _buildNarrowLayout(List<MazeLevel> levels) {
    return ListView.builder(
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildLevelCard(levels[index]),
        );
      },
    );
  }

  Widget _buildLevelCard(MazeLevel level) {
    final isCompleted = completedLevels[level.levelNumber - 1];

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(level: level),
            ),
          );
          _loadProgress();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Level ${level.levelNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                level.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
