# Maze Game

## Application Idea and Purpose
This is a maze navigation game built with Flutter and Flame engine. The player controls a blue ball and must navigate through a maze by tapping on adjacent cells to reach the green goal square. The game features three levels of increasing difficulty.

## Deployed Application URL
<<<<<<< Updated upstream
[Deployment URL will be added here after deployment]
=======
https://alex20m.github.io/maze-game/
>>>>>>> Stashed changes

## How to Use the Application

### Getting Started
1. Launch the application and tap "Start Game" on the start screen
2. Select a level from the level selection screen (levels unlock as you complete them)
3. Tap on adjacent cells (horizontally or vertically) to move your blue ball
4. Navigate to the green goal square to complete the level
5. Gray cells are walls and cannot be crossed

### Controls
- **Tap/Touch**: Tap on any adjacent cell (up, down, left, or right) to move to that position
- The game is fully touch-enabled and does not require a keyboard or mouse

### Features
- **3 Levels**: Easy Start, Medium Challenge, and Hard Maze
- **Progress Saving**: Your completed levels are automatically saved
- **Responsive Design**: The game adapts to different screen sizes with a breakpoint at 600px width
- **Maximum Width**: On larger screens, content is limited to 800px for optimal viewing

### Screens
- **Start Screen**: Main menu to begin playing
- **Level Selection**: Choose which level to play (shows completion status)
- **Game Screen**: The actual maze gameplay
- **Result Screen**: Shows completion status and navigation options

## Development

### Running Locally
```bash
flutter pub get
flutter run -d chrome
```

### Building for Web
```bash
flutter build web
```

The game uses:
- **Flutter**: UI framework
- **Flame**: Game engine
- **shared_preferences**: Progress persistence
