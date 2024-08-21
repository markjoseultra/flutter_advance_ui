import 'package:flutter/material.dart';
import 'package:flutter_advance_ui/presentation/pages/animation_builder_demo_page.dart';
import 'package:flutter_advance_ui/presentation/pages/scroll_animation_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentPage = 0;

  final GlobalKey<ScaffoldState> _indexPageScaffold = GlobalKey();

  Widget _renderPage() {
    switch (_currentPage) {
      case 0:
        return const ScorllAnimationPage();
      case 1:
        return const AnimatedBuilderDemoPage();
      default:
        return const ScorllAnimationPage();
    }
  }

  void _gotoPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _indexPageScaffold,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("ADVANCE UI"),
        actions: [
          IconButton(
            onPressed: () {
              _indexPageScaffold.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
          )
        ],
      ),
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
            )
          ],
        ),
      ),
    );
  }
}
