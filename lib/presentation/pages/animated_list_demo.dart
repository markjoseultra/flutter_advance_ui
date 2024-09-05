import 'package:flutter/material.dart';

class SampleListModel {
  final int id;
  final String title;
  final String subtitle;

  SampleListModel(
      {required this.id, required this.title, required this.subtitle});
}

class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({super.key});

  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  final List<SampleListModel> data = [];

  void addData() {
    if (listKey.currentState == null) {
      return;
    }

    listKey.currentState!
        .insertItem(data.length, duration: const Duration(seconds: 1));

    data.insert(
      data.length,
      SampleListModel(
          id: data.length,
          title: "Lorem ipsum",
          subtitle:
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
    );
  }

  void onRemove({required int index}) async {
    listKey.currentState!.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return ListItem(
          animation: animation,
          title: data[index].title,
          subtitle: data[index].subtitle,
          onRemove: () {},
        );
      },
    );

    await Future.delayed(const Duration(seconds: 1));

    data.removeAt(index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      for (var i = 0; i < 5; i++) {
        addData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedList(
        key: listKey,
        itemBuilder: (context, index, animation) {
          return ListItem(
            animation: animation,
            title: data[index].title,
            subtitle: data[index].subtitle,
            onRemove: () {
              onRemove(index: index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addData,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRemove;
  final Animation<double> animation;

  const ListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRemove,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.insert_comment),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: IconButton(
            onPressed: () {
              onRemove();
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
