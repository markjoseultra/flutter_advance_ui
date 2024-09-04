import 'package:flutter/material.dart';
import 'package:flutter_advance_ui/presentation/pages/animated_list_demo.dart';
import 'package:flutter_advance_ui/presentation/pages/animation_builder_demo_page.dart';
import 'package:flutter_advance_ui/presentation/pages/column_animation.dart';
import 'package:flutter_advance_ui/presentation/pages/custom_prompt.dart';
import 'package:flutter_advance_ui/presentation/pages/drawing_canvas_page.dart';
import 'package:flutter_advance_ui/presentation/pages/fancy_scroll_page.dart';
import 'package:flutter_advance_ui/presentation/pages/scroll_animation_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentPage = 5;

  final GlobalKey<ScaffoldState> _indexPageScaffold = GlobalKey();

  Widget _renderPage() {
    switch (_currentPage) {
      case 0:
        return const ScorllAnimationPage();
      case 1:
        return const AnimatedBuilderDemoPage();
      case 2:
        return const FancyScrollPage();
      case 3:
        return const DrawingCanvassPage();
      case 4:
        return const AnimatedListDemo();
      case 5:
        return const ColumnAnimation();
      case 6:
        return const CustomPrompt();
      default:
        return const ScorllAnimationPage();
    }
  }

  void _gotoPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
    _indexPageScaffold.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _indexPageScaffold,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("ADVANCE UI"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         _indexPageScaffold.currentState?.openDrawer();
      //       },
      //       icon: const Icon(Icons.menu),
      //     )
      //   ],
      // ),
      body: _renderPage(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Scroll Animation"),
              onTap: () {
                _gotoPage(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Animated Builder Demo"),
              onTap: () {
                _gotoPage(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Fancy Scroll Demo"),
              onTap: () {
                _gotoPage(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Drawing Canvas Demo"),
              onTap: () {
                _gotoPage(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Animated List  Demo"),
              onTap: () {
                _gotoPage(4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Animated Column"),
              onTap: () {
                _gotoPage(5);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Custom Prompt"),
              onTap: () {
                _gotoPage(6);
              },
            ),
          ],
        ),
      ),
    );
  }
}
