import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showError({
  Icon? icon,
  required String title,
  required String message,
  required WidgetRef ref,
}) {
  ref.read(promptNotifierProvider.notifier).addPrompt(
        icon: icon,
        title: title,
        message: message,
        severity: Severity.error,
      );
}

void showInfo({
  Icon? icon,
  required String title,
  required String message,
  required WidgetRef ref,
}) {
  ref.read(promptNotifierProvider.notifier).addPrompt(
        icon: icon,
        title: title,
        message: message,
        severity: Severity.info,
      );
}

void showWarning({
  Icon? icon,
  required String title,
  required String message,
  required WidgetRef ref,
}) {
  ref.read(promptNotifierProvider.notifier).addPrompt(
        icon: icon,
        title: title,
        message: message,
        severity: Severity.warning,
      );
}

void showSuccess({
  Icon? icon,
  required String title,
  required String message,
  required WidgetRef ref,
}) {
  ref.read(promptNotifierProvider.notifier).addPrompt(
        icon: icon,
        title: title,
        message: message,
        severity: Severity.good,
      );
}

enum Severity { info, error, warning, good }

@visibleForTesting
class PromptModel {
  final Icon? icon;
  final int id;
  final String title;
  final String message;
  final Severity severity;

  PromptModel({
    this.icon,
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
  });
}

@visibleForTesting
class UIPromptModel extends PromptModel {
  final AnimationController animationController;

  UIPromptModel({
    required super.id,
    required super.title,
    required super.message,
    required super.severity,
    required this.animationController,
  });
}

@visibleForTesting
class PromptStateNotifier extends Notifier<List<PromptModel>> {
  @override
  List<PromptModel> build() {
    return [];
  }

  void addPrompt({
    Icon? icon,
    required String title,
    required String message,
    required Severity severity,
  }) {
    state = [
      ...state,
      PromptModel(
        icon: icon,
        id: DateTime.now().microsecondsSinceEpoch,
        title: title,
        message: message,
        severity: severity,
      ),
    ];
  }

  void removePrompt({required int id}) {
    if (state.isEmpty) {
      return;
    }

    state.removeAt(state.indexWhere((prompt) => prompt.id == id));

    state = [...state];
  }
}

@visibleForTesting
final promptNotifierProvider =
    NotifierProvider<PromptStateNotifier, List<PromptModel>>(
  PromptStateNotifier.new,
);

///Wrap your whole app with this so the prompts can show anywhere on your screen
class AwesomePrompt extends ConsumerStatefulWidget {
  final Widget child;
  const AwesomePrompt({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AwesomePromptState();
}

class _AwesomePromptState extends ConsumerState<AwesomePrompt>
    with TickerProviderStateMixin {
  Map<String, UIPromptModel> uiPromptsMap = {};

  void addPrompt({required PromptModel prompt}) {
    if (uiPromptsMap.containsKey("${prompt.id}")) {
      return;
    }

    setState(() {
      uiPromptsMap["${prompt.id}"] = UIPromptModel(
        id: prompt.id,
        title: prompt.title,
        message: prompt.message,
        severity: prompt.severity,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  Future removedPrompt({required String id}) async {
    await uiPromptsMap[id]?.animationController.reverse();

    setState(() {
      uiPromptsMap.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<PromptModel> prompts = ref.watch(promptNotifierProvider);

    ref.listen(
      promptNotifierProvider,
      (previous, next) {
        addPrompt(prompt: next.last);
      },
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: uiPromptsMap.entries.map((promptEntry) {
                      // return Text(uiPromptsMap[promptEntry.key]!.title);

                      return PromptCard(
                        key: Key("${uiPromptsMap[promptEntry.key]!.id}"),
                        icon: uiPromptsMap[promptEntry.key]!.icon,
                        title: uiPromptsMap[promptEntry.key]!.title,
                        message: uiPromptsMap[promptEntry.key]!.message,
                        severity: uiPromptsMap[promptEntry.key]!.severity,
                        animationController:
                            uiPromptsMap[promptEntry.key]!.animationController,
                        onClose: () async {
                          if (uiPromptsMap.isEmpty) {
                            return;
                          }

                          await removedPrompt(
                              id: "${uiPromptsMap[promptEntry.key]!.id}");
                        },
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

@visibleForTesting
class PromptCard extends StatefulWidget {
  final Icon? icon;
  final Severity severity;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final int durationInSeconds;
  final AnimationController animationController;

  const PromptCard({
    super.key,
    this.icon,
    this.title = "Information",
    this.message =
        "Please check your device and make sure all the needed services are turned on.",
    this.onTap,
    this.onClose,
    this.severity = Severity.info,
    this.durationInSeconds = 10,
    required this.animationController,
  });

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard> {
  final Color textColor = const Color(0xFF282828);

  late final Timer _timer;

  double _durationElapsed = 0;

  Color bgColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFFF0FDFA);
      case Severity.info:
        return const Color(0xFFEFF6FF);
      case Severity.warning:
        return const Color(0xFFFFF7ED);
      case Severity.error:
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFFF0FDFA);
    }
  }

  Color borderColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF14B8A6);
      case Severity.info:
        return const Color(0xFF3B82F6);
      case Severity.warning:
        return const Color(0xFFF97316);
      case Severity.error:
        return const Color(0xFFFF3F3C);
      default:
        return const Color(0xFF5EEAD4);
    }
  }

  Icon icon({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Icon(Icons.check_circle_outline);
      case Severity.info:
        return const Icon(Icons.info_outline);
      case Severity.warning:
        return const Icon(Icons.notifications_outlined);
      case Severity.error:
        return const Icon(Icons.warning_amber_rounded);
      default:
        return const Icon(Icons.check_circle_outline);
    }
  }

  // late final AnimationController _animationController = AnimationController(
  //   duration: const Duration(milliseconds: 500),
  //   vsync: this,
  // );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -1.5),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: widget.animationController,
    curve: Curves.easeIn,
  ));

  late final Animation<double> _opacityAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: widget.animationController,
    curve: Curves.easeIn,
  ));

  @override
  void initState() {
    widget.animationController.forward();

    _timer = Timer(Duration(seconds: widget.durationInSeconds + 1), () {});

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _durationElapsed = timer.tick / widget.durationInSeconds;
        });

        if (timer.tick >= widget.durationInSeconds + 1) {
          if (widget.onClose != null && mounted) {
            widget.onClose!();
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() async {
    widget.animationController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: bgColor(severity: widget.severity),
                border: Border.all(
                  width: 1,
                  color: borderColor(severity: widget.severity),
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconContainer(
                            icon:
                                widget.icon ?? icon(severity: widget.severity),
                            severity: widget.severity,
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: Text(
                                  widget.title,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: Text(
                                  widget.message,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 11.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_timer.isActive)
                    TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: _durationElapsed),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            color: borderColor(severity: widget.severity),
                          );
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class IconContainer extends StatelessWidget {
  final Icon? icon;
  final Severity severity;
  const IconContainer({
    super.key,
    required this.icon,
    this.severity = Severity.good,
  });

  Color outerRingColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFFCCFBF1);
      case Severity.info:
        return const Color(0xFFDBEAFE);
      case Severity.warning:
        return const Color(0xFFFFEDD5);
      case Severity.error:
        return const Color(0xFFFFD1D1);
      default:
        return const Color(0xFFCCFBF1);
    }
  }

  Color innerRingColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0x4D5EEAD4);
      case Severity.info:
        return const Color(0x4D93C5FD);
      case Severity.warning:
        return const Color(0x4DFDBA74);
      case Severity.error:
        return const Color(0x4DFF3F3C);
      default:
        return const Color(0x4D5EEAD4);
    }
  }

  Color iconColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF14B8A6);
      case Severity.info:
        return const Color(0xFF3B82F6);
      case Severity.warning:
        return const Color(0xFFF97316);
      case Severity.error:
        return const Color(0xFFFF3F3C);
      default:
        return Colors.teal.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: outerRingColor(severity: severity),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: innerRingColor(severity: severity),
        ),
        child: Icon(
          icon!.icon,
          color: iconColor(severity: severity),
          size: 20.0,
        ),
      ),
    );
  }
}

class PromptCardEmbedded extends StatefulWidget {
  final Icon? icon;
  final Severity severity;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final bool show;
  final bool showCloseButton;

  const PromptCardEmbedded({
    super.key,
    this.icon,
    this.title = "Information",
    this.message =
        "Please check your device and make sure all the needed services are turned on.",
    this.onTap,
    this.onClose,
    this.severity = Severity.info,
    this.show = false,
    this.showCloseButton = true,
  });

  @override
  State<PromptCardEmbedded> createState() => _PromptCardEmbeddedState();
}

class _PromptCardEmbeddedState extends State<PromptCardEmbedded>
    with SingleTickerProviderStateMixin {
  final Color textColor = const Color(0xFF282828);

  Color bgColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFFF0FDFA);
      case Severity.info:
        return const Color(0xFFEFF6FF);
      case Severity.warning:
        return const Color(0xFFFFF7ED);
      case Severity.error:
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFFF0FDFA);
    }
  }

  Color borderColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF14B8A6);
      case Severity.info:
        return const Color(0xFF3B82F6);
      case Severity.warning:
        return const Color(0xFFF97316);
      case Severity.error:
        return const Color(0xFFFF3F3C);
      default:
        return const Color(0xFF5EEAD4);
    }
  }

  Icon icon({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Icon(Icons.check_circle_outline);
      case Severity.info:
        return const Icon(Icons.info_outline);
      case Severity.warning:
        return const Icon(Icons.notifications_outlined);
      case Severity.error:
        return const Icon(Icons.warning_amber_rounded);
      default:
        return const Icon(Icons.check_circle_outline);
    }
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  // late final Animation<Offset> _offsetAnimation = Tween<Offset>(
  //   begin: const Offset(0.0, -1.5),
  //   end: Offset.zero,
  // ).animate(CurvedAnimation(
  //   parent: _animationController,
  //   curve: Curves.easeIn,
  // ));

  late final Animation<double> _sizeFactor = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  ));

  late final Animation<double> _opacityAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeIn,
  ));

  @override
  void initState() {
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() async {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.show) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return SizeTransition(
      sizeFactor: _sizeFactor,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: bgColor(severity: widget.severity),
                border: Border.all(
                  width: 1,
                  color: borderColor(severity: widget.severity),
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconContainer(
                        icon: widget.icon ?? icon(severity: widget.severity),
                        severity: widget.severity,
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: Text(
                              widget.message,
                              maxLines: 5,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        if (widget.onClose != null) {
                          widget.onClose!();
                        }

                        _animationController.reverse();
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
