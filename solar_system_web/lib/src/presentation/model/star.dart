class Star {
  double x;
  double y;
  double mass;
  double radius;

  Star(this.x, this.y, this.mass, this.radius);

  double get diameter => radius * 2;
}
