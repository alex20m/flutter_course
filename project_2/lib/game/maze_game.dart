import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../models/maze_level.dart';

class MazeGame extends FlameGame with TapCallbacks {
  final MazeLevel level;
  final Function(bool) onGameEnd;
  
  late double cellSize;
  late Vector2 playerPosition;
  late Vector2 targetPosition;
  
  MazeGame({required this.level, required this.onGameEnd});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final gridSize = level.grid.length;
    final availableSize = size.x < size.y ? size.x : size.y;
    cellSize = (availableSize * 0.9) / gridSize;
    
    playerPosition = Vector2(
      level.startX * cellSize,
      level.startY * cellSize,
    );
    targetPosition = playerPosition.clone();
    
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final gridSize = level.grid.length;
    final offsetX = (size.x - gridSize * cellSize) / 2;
    final offsetY = (size.y - gridSize * cellSize) / 2;
    
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final rect = Rect.fromLTWH(
          offsetX + x * cellSize,
          offsetY + y * cellSize,
          cellSize,
          cellSize,
        );
        
        final paint = Paint();
        if (level.grid[y][x] == 1) {
          paint.color = Colors.grey[800]!;
        } else {
          paint.color = Colors.grey[200]!;
        }
        canvas.drawRect(rect, paint);
        
        final borderPaint = Paint()
          ..color = Colors.grey[400]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawRect(rect, borderPaint);
      }
    }
    
    final endRect = Rect.fromLTWH(
      offsetX + level.endX * cellSize + cellSize * 0.15,
      offsetY + level.endY * cellSize + cellSize * 0.15,
      cellSize * 0.7,
      cellSize * 0.7,
    );
    final endPaint = Paint()..color = Colors.green;
    canvas.drawRect(endRect, endPaint);
    
    final playerRect = Rect.fromCircle(
      center: Offset(
        offsetX + playerPosition.x + cellSize / 2,
        offsetY + playerPosition.y + cellSize / 2,
      ),
      radius: cellSize * 0.35,
    );
    final playerPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(playerRect.center, playerRect.width / 2, playerPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    final diff = targetPosition - playerPosition;
    if (diff.length > 1) {
      playerPosition += diff.normalized() * 300 * dt;
    } else {
      playerPosition = targetPosition.clone();
      
      final gridX = (playerPosition.x / cellSize).round();
      final gridY = (playerPosition.y / cellSize).round();
      
      if (gridX == level.endX && gridY == level.endY) {
        onGameEnd(true);
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final gridSize = level.grid.length;
    final offsetX = (size.x - gridSize * cellSize) / 2;
    final offsetY = (size.y - gridSize * cellSize) / 2;
    
    final localX = event.localPosition.x - offsetX;
    final localY = event.localPosition.y - offsetY;
    
    if (localX < 0 || localY < 0 || 
        localX >= gridSize * cellSize || localY >= gridSize * cellSize) {
      return;
    }
    
    final targetGridX = (localX / cellSize).floor();
    final targetGridY = (localY / cellSize).floor();
    
    if (targetGridX < 0 || targetGridX >= gridSize || 
        targetGridY < 0 || targetGridY >= gridSize) {
      return;
    }
    
    if (level.grid[targetGridY][targetGridX] == 1) {
      return;
    }
    
    final currentGridX = (playerPosition.x / cellSize).round();
    final currentGridY = (playerPosition.y / cellSize).round();
    
    final dx = (targetGridX - currentGridX).abs();
    final dy = (targetGridY - currentGridY).abs();
    
    if ((dx == 1 && dy == 0) || (dx == 0 && dy == 1)) {
      targetPosition = Vector2(
        targetGridX * cellSize,
        targetGridY * cellSize,
      );
    }
  }
}
