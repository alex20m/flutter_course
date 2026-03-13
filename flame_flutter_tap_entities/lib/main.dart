import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: TapEntitiesGame(),
    ),
  );
}

class TapEntitiesGame extends Forge2DGame {
  static const double gameDurationSeconds = 30;

  final Random _random = Random();
  late final TextComponent _hud;

  var tapCount = 0;
  var elapsedSeconds = 0.0;
  var isGameOver = false;

  TapEntitiesGame()
      : super(
          gravity: Vector2(0, 20),
          camera: CameraComponent.withFixedResolution(
            width: 800,
            height: 600,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xFFF6F8FB);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    world.add(GameBounds());

    world.addAll([
      CircleEntity(initialCenter: Vector2(-20, -20), radius: 2.8),
      RectangleEntity(
        initialCenter: Vector2(0, -22),
        width: 5,
        height: 3,
      ),
      PolygonEntity(initialCenter: Vector2(20, -21)),
    ]);

    _hud = TextComponent(
      text: _hudText,
      position: Vector2(12, 12),
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF111827),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    camera.viewport.add(_hud);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }

    elapsedSeconds += dt;
    if (elapsedSeconds >= gameDurationSeconds) {
      elapsedSeconds = gameDurationSeconds;
      isGameOver = true;
    }

    _hud.text = _hudText;
  }

  void registerTap() {
    if (isGameOver) {
      return;
    }
    tapCount++;
    _hud.text = _hudText;
  }

  Rect get worldRect => camera.visibleWorldRect;

  Vector2 randomTopCenter({required double radiusX, required double radiusY}) {
    final rect = worldRect;

    final minX = rect.left + radiusX + 1;
    final maxX = rect.right - radiusX - 1;
    final minY = rect.top + radiusY + 2;
    final maxY = rect.top + radiusY + 10;

    return Vector2(
      minX + _random.nextDouble() * max(0.0001, maxX - minX),
      minY + _random.nextDouble() * max(0.0001, maxY - minY),
    );
  }

  String get _hudText {
    final remaining = max(0.0, gameDurationSeconds - elapsedSeconds).ceil();
    if (isGameOver) {
      return 'Game over! Taps: $tapCount';
    }
    return 'Time: ${remaining}s   Taps: $tapCount';
  }
}

class GameBounds extends BodyComponent<TapEntitiesGame> {
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = Vector2.zero();

    final body = world.createBody(bodyDef);
    final rect = game.worldRect;

    final bounds = [
      Vector2(rect.left, rect.top + 1),
      Vector2(rect.right, rect.top + 1),
      Vector2(rect.right, rect.bottom - 1),
      Vector2(rect.left, rect.bottom - 1),
    ];

    for (var i = 0; i < bounds.length; i++) {
      body.createFixture(
        FixtureDef(
          EdgeShape()
            ..set(
              bounds[i],
              bounds[(i + 1) % bounds.length],
            ),
        )..restitution = 0.2,
      );
    }

    return body;
  }
}

abstract class TappablePhysicsEntity extends BodyComponent<TapEntitiesGame>
    with TapCallbacks {
  static const double relocateInterval = 1.0;

  final Paint fillPaint;
  final Vector2 initialCenter;

  double _elapsedForMove = 0;

  TappablePhysicsEntity({required this.initialCenter, required this.fillPaint});

  double get radiusX;
  double get radiusY;

  @override
  void onTapDown(TapDownEvent event) {
    if (game.isGameOver) {
      return;
    }

    game.registerTap();
    body.applyLinearImpulse(Vector2(0, -55));
    body.setAwake(true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) {
      return;
    }

    _elapsedForMove += dt;
    if (_elapsedForMove >= relocateInterval) {
      _elapsedForMove -= relocateInterval;
      final next = game.randomTopCenter(radiusX: radiusX, radiusY: radiusY);
      body
        ..setTransform(next, body.angle)
        ..linearVelocity = Vector2.zero()
        ..angularVelocity = 0
        ..setAwake(true);
    }
  }
}

class CircleEntity extends TappablePhysicsEntity {
  final double radius;

  CircleEntity({required super.initialCenter, required this.radius})
      : super(fillPaint: Paint()..color = const Color(0xFF3B82F6));

  @override
  double get radiusX => radius;

  @override
  double get radiusY => radius;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = initialCenter
      ..type = BodyType.dynamic
      ..angularVelocity = 0.8
      ..angularDamping = 0.2
      ..userData = this;

    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = radius;
    body.createFixture(
      FixtureDef(shape)
        ..density = 1
        ..friction = 0.25
        ..restitution = 0.45,
    );
    return body;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, radius, fillPaint);
  }
}

class RectangleEntity extends TappablePhysicsEntity {
  final double width;
  final double height;

  RectangleEntity({
    required super.initialCenter,
    required this.width,
    required this.height,
  }) : super(fillPaint: Paint()..color = const Color(0xFF22C55E));

  @override
  double get radiusX => width / 2;

  @override
  double get radiusY => height / 2;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = initialCenter
      ..type = BodyType.dynamic
      ..angularVelocity = 1.1
      ..userData = this;

    final body = world.createBody(bodyDef);
    final shape = PolygonShape()..setAsBoxXY(width / 2, height / 2);
    body.createFixture(
      FixtureDef(shape)
        ..density = 1
        ..friction = 0.35
        ..restitution = 0.35,
    );
    return body;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      fillPaint,
    );
  }
}

class PolygonEntity extends TappablePhysicsEntity {
  static final List<Vector2> _vertices = [
    Vector2(0, -3.2),
    Vector2(2.8, -1.2),
    Vector2(1.8, 2.6),
    Vector2(-2.8, 2.2),
  ];

  PolygonEntity({required super.initialCenter})
      : super(fillPaint: Paint()..color = const Color(0xFFF59E0B));

  @override
  double get radiusX => 2.8;

  @override
  double get radiusY => 3.2;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = initialCenter
      ..type = BodyType.dynamic
      ..angularVelocity = 1.4
      ..userData = this;

    final body = world.createBody(bodyDef);
    final shape = PolygonShape()..set(_vertices);
    body.createFixture(
      FixtureDef(shape)
        ..density = 1
        ..friction = 0.35
        ..restitution = 0.35,
    );
    return body;
  }

  @override
  void render(Canvas canvas) {
    final path = Path()..moveTo(_vertices.first.x, _vertices.first.y);
    for (final vertex in _vertices.skip(1)) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();
    canvas.drawPath(path, fillPaint);
  }
}
