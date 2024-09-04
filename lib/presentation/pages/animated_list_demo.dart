import 'package:flutter/material.dart';
import 'package:flutter_advance_ui/core/prompts/awesome_prompts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedListDemo extends ConsumerWidget {
  const AnimatedListDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showError(
              title: "Test",
              message: "Lorem ipsum dolor sit amit",
              ref: ref,
            );
          },
          child: const Text("Show Prompt"),
        ),
      ),
    );
  }
}
