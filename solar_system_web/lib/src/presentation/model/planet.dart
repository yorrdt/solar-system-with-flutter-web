import 'dart:ui';

class Planet {
  double x;
  double y;
  // double mass;
  double radius;
  double vx;
  double vy;
  List<Offset> trajectory;
  Color color;

  Planet(
    this.x,
    this.y,
    this.vx,
    this.vy,
    // this.mass,
    this.radius,
    this.color,
  ) : trajectory = [];

  double get diameter => radius * 2;
}
