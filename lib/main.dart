import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(SplashAnimation());
}

class SplashAnimation extends StatelessWidget {
  const SplashAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen(), debugShowCheckedModeBanner: false);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  double rotationTurns = 0.0;
  Timer? rotationTimer;

  @override
  void initState() {
    super.initState();

    // Start other animations once first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        animate = true;
        rotationTurns = 1.0; // start rotation
      });
    });

    // Setup periodic timer to toggle rotation turns continuously
    rotationTimer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        rotationTurns = rotationTurns == 0.0 ? 1.0 : 0.0;
      });
    });

    Timer(Duration(seconds: 6), () {
      if (mounted) {
        rotationTimer?.cancel();
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
      }
    });
  }

  @override
  void dispose() {
    rotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationDuration = Duration(seconds: 2);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: animate ? 1 : 0,
              duration: animationDuration,
              curve: Curves.easeIn,
              child: AnimatedScale(
                scale: animate ? 1 : 0.6,
                duration: animationDuration,
                curve: Curves.easeOutBack,
                child: AnimatedRotation(
                  turns: rotationTurns,
                  duration: animationDuration,
                  curve: Curves.easeIn,
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            AnimatedSlide(
              offset: animate ? Offset.zero : Offset(0, 1),
              duration: animationDuration,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: animate ? 1 : 0,
                duration: animationDuration,
                curve: Curves.easeIn,
                child: Text(
                  'Flutto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double scale = 1.0;

  @override
  void initState() {
    super.initState();

    _startBouncing();
  }

  void _startBouncing() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        scale = scale == 1.0 ? 1.2 : 1.0;
      });

      _startBouncing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Screen'), centerTitle: true),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
          transform: Matrix4.identity()..scale(scale),
          child: Image.asset('assets/wink.png'),
        ),
      ),
    );
  }
}
