class MazeLevel {
  final int levelNumber;
  final String name;
  final List<List<int>> grid;
  final int startX;
  final int startY;
  final int endX;
  final int endY;

  MazeLevel({
    required this.levelNumber,
    required this.name,
    required this.grid,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  static List<MazeLevel> getAllLevels() {
    return [
      MazeLevel(
        levelNumber: 1,
        name: 'Easy Start',
        grid: [
          [0, 0, 0, 0, 0],
          [1, 1, 1, 1, 0],
          [0, 0, 0, 0, 0],
          [0, 1, 1, 1, 1],
          [0, 0, 0, 0, 0],
        ],
        startX: 0,
        startY: 0,
        endX: 4,
        endY: 4,
      ),
      MazeLevel(
        levelNumber: 2,
        name: 'Medium Challenge',
        grid: [
          [0, 1, 0, 0, 0, 0, 0],
          [0, 1, 0, 1, 1, 1, 0],
          [0, 0, 0, 1, 0, 0, 0],
          [1, 1, 0, 1, 0, 1, 1],
          [0, 0, 0, 0, 0, 0, 0],
          [0, 1, 1, 1, 1, 1, 0],
          [0, 0, 0, 0, 0, 0, 0],
        ],
        startX: 0,
        startY: 0,
        endX: 6,
        endY: 6,
      ),
      MazeLevel(
        levelNumber: 3,
        name: 'Hard Maze',
        grid: [
          [0, 1, 0, 0, 0, 0, 0, 0, 0],
          [0, 1, 0, 1, 1, 1, 1, 1, 0],
          [0, 0, 0, 1, 0, 0, 0, 0, 0],
          [1, 1, 0, 1, 0, 1, 1, 1, 0],
          [0, 0, 0, 0, 0, 1, 0, 0, 0],
          [0, 1, 1, 1, 0, 1, 0, 1, 1],
          [0, 0, 0, 1, 0, 0, 0, 0, 0],
          [1, 1, 0, 1, 1, 1, 1, 1, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0],
        ],
        startX: 0,
        startY: 0,
        endX: 8,
        endY: 8,
      ),
    ];
  }
}
