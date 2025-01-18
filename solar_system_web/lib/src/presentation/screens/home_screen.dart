import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:solar_system_web/src/presentation/model/planet.dart';
import 'package:solar_system_web/src/presentation/model/star.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final star = Star(350, 350, 800, 10);

  final List<Planet> planets = [
    Planet(320, 350, 0, 6.3, 1.5, Colors.grey.shade400),
    Planet(280, 350, 0, 3.7, 2, Colors.grey.shade200),
    Planet(240, 350, 0, 2.8, 3, Colors.blueAccent.shade200),
    Planet(200, 350, 0, 2.3, 4, Colors.yellow.shade200),
    Planet(160, 350, 0, 2, 5, Colors.deepOrangeAccent),
    Planet(120, 350, 0, 1.8, 6, Colors.yellow.shade300),
    Planet(80, 350, 0, 1.65, 7, Colors.yellowAccent.shade100),
    Planet(40, 350, 0, 1.55, 8, Colors.blueGrey.shade300),
    Planet(0, 350, 0, 1.45, 8, Colors.blueAccent.shade400),
  ];

  final double G = 1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1000),
    )..addListener(() {
        setState(() {
          _updatePlanetPositions();
        });
      });

    _animationController.forward();
  }

  void _updatePlanetPositions() {
    double deltaTime = _animationController.lastElapsedDuration!.inMilliseconds / 1000;

    for (var planet in planets) {
      double totalForceX = 0;
      double totalForceY = 0;

      double dx = star.x - planet.x;
      double dy = star.y - planet.y;
      double distance = math.sqrt(dx * dx + dy * dy);

      if (distance < 1) continue;

      double force = G * star.mass / (distance * distance);
      totalForceX += force * (dx / distance);
      totalForceY += force * (dy / distance);

      planet.vx += totalForceX; // * deltaTime;
      planet.vy += totalForceY; // * deltaTime;

      planet.x += planet.vx; // * deltaTime;
      planet.y += planet.vy; // * deltaTime;

      planet.trajectory.add(Offset(planet.x, planet.y));

      if (distance < star.radius) {
        _animationController.stop();
        break;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...planets.map((p) {
                  return Text(
                      'planet: ${p.x.toStringAsFixed(2)} ${p.y.toStringAsFixed(2)} ${p.vx.toStringAsFixed(2)} ${p.vy.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white));
                }),
              ],
            ),
          ),
          Positioned(
            left: star.x - star.radius,
            top: star.y - star.radius,
            child: Container(
              width: star.diameter,
              height: star.diameter,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
          ),
          ...planets.map((planet) {
            return Positioned(
              left: planet.x - planet.radius,
              top: planet.y - planet.radius,
              child: Container(
                width: planet.diameter,
                height: planet.diameter,
                decoration: BoxDecoration(
                  color: planet.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
          ...planets.map((planet) {
            return CustomPaint(
              painter: TrajectoryPainter(planet.trajectory),
              child: Container(),
            );
          }),
        ],
      ),
    );
  }
}

class TrajectoryPainter extends CustomPainter {
  final List<Offset> trajectory;
  TrajectoryPainter(this.trajectory);

  @override
  void paint(Canvas canvas, Size size) {
    if (trajectory.isEmpty) return;

    Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < trajectory.length - 1; i++) {
      canvas.drawLine(trajectory[i], trajectory[i + 1], paint);

      //if (trajectory.length > 10) trajectory.removeAt(i);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
