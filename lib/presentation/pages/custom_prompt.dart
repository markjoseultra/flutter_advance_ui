import 'package:flutter/material.dart';

import 'package:flutter_advance_ui/core/prompts/awesome_prompts_v2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomPrompt extends ConsumerStatefulWidget {
  const CustomPrompt({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomPromptState();
}

class _CustomPromptState extends ConsumerState<CustomPrompt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              showError(
                title: "Lorem ipsum",
                message: "Lorem ipsum dolor sit amit",
                ref: ref,
              );

              showSuccess(
                title: "Lorem ipsum",
                message: "Lorem ipsum dolor sit amit",
                ref: ref,
              );
              showInfo(
                title: "Lorem ipsum",
                message: "Lorem ipsum dolor sit amit",
                ref: ref,
              );
              showWarning(
                title: "Lorem ipsum",
                message: "Lorem ipsum dolor sit amit",
                ref: ref,
              );
            },
            child: const Text("SHOW PROMPT")),
      ),
    );
  }
}
