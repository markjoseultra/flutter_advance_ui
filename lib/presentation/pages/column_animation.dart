import 'package:flutter/material.dart';

class ColumnAnimation extends StatelessWidget {
  const ColumnAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fade In and Out Example')),
      body: SlideInOutColumn(),
    );
  }
}

class SlideInOutColumn extends StatefulWidget {
  const SlideInOutColumn({super.key});
  @override
  _SlideInOutColumnState createState() => _SlideInOutColumnState();
}

class _SlideInOutColumnState extends State<SlideInOutColumn>
    with TickerProviderStateMixin {
  final List<bool> _visibleItems = List.generate(5, (_) => true);
  final List<AnimationController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _controllers.add(AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleVisibility(int index) {
    setState(() {
      if (_visibleItems[index]) {
        _controllers[index].forward();
      } else {
        _controllers[index].reverse();
      }
      _visibleItems[index] = !_visibleItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(5, (index) {
        final animation = Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ));

        return GestureDetector(
          onTap: () => _toggleVisibility(index),
          child: SlideTransition(
            position: animation,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
