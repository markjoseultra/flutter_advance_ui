import 'package:flutter/material.dart';

class DrawingCanvassPage extends StatefulWidget {
  const DrawingCanvassPage({super.key});

  @override
  State<DrawingCanvassPage> createState() => _DrawingCanvassPageState();
}

class _DrawingCanvassPageState extends State<DrawingCanvassPage> {
  TimeType currentTimeType = TimeType.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: BezierClipper1(),
            child: Container(
              height: 400,
              color: Colors.blue,
              child: AnimatedSDayNightBanner(timeType: currentTimeType),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  currentTimeType = currentTimeType == TimeType.night
                      ? TimeType.day
                      : TimeType.night;
                });
              },
              child: const Text("Animate"))
        ],
      ),
    );
  }
}

class BezierClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double height = size.height;

    double width = size.width;

    double heightOffset = height * 0.2;

    path.lineTo(0, height - heightOffset);

    path.quadraticBezierTo(width / 2, height, width, height - heightOffset);

    path.lineTo(width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

enum TimeType { day, night }

enum ShapeType { circle, square }

class AnimatedSDayNightBanner extends StatefulWidget {
  final TimeType timeType;
  final ShapeType? shapeType;
  const AnimatedSDayNightBanner(
      {super.key, required this.timeType, this.shapeType = ShapeType.circle});

  @override
  State<AnimatedSDayNightBanner> createState() =>
      _AnimatedSDayNightBannerState();
}

class _AnimatedSDayNightBannerState extends State<AnimatedSDayNightBanner>
    with TickerProviderStateMixin {
  late final AnimationController _cloud1AnimationController =
      AnimationController(
    duration: const Duration(seconds: 70),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _cloud2AnimationController =
      AnimationController(
    duration: const Duration(seconds: 30),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _cloud3AnimationController =
      AnimationController(
    duration: const Duration(seconds: 90),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _sunAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final AnimationController _moonAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void dispose() {
    _cloud1AnimationController.dispose();
    _cloud2AnimationController.dispose();
    _cloud3AnimationController.dispose();
    _sunAnimationController.dispose();
    _moonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timeType == TimeType.day) {
      _sunAnimationController.forward();
    } else {
      _sunAnimationController.reverse();
    }

    if (widget.timeType == TimeType.night) {
      _moonAnimationController.forward();
    } else {
      _moonAnimationController.reverse();
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ClipPath(
        child: Stack(
          children: [
            //BACKGROUND
            AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              child: widget.timeType == TimeType.day
                  ? Image.asset(
                      key: const ValueKey("day_bg"),
                      "assets/images/bg_only_day.png",
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      key: const ValueKey("day_night"),
                      "assets/images/bg_only_night.png",
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
            ),

            //SUN MOON
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(-500, 10, 10, 10),
                  const Size(190, 190),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(220, 10, 10, 10),
                  const Size(190, 190),
                ),
              ).animate(CurvedAnimation(
                parent: _sunAnimationController,
                curve: Curves.elasticInOut,
              )),
              child: Image.asset(
                "assets/images/sun.png",
                width: 100,
                height: 100,
              ),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 10, 10, 10),
                  const Size(190, 190),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(220, 10, 10, 10),
                  const Size(190, 190),
                ),
              ).animate(CurvedAnimation(
                parent: _moonAnimationController,
                curve: Curves.elasticInOut,
              )),
              child: Image.asset(
                "assets/images/moon.png",
                width: 100,
                height: 100,
              ),
            ),

            //MOVING CLOUDS
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 0, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 0, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud3AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Cloud(
                  dayCloudAsset: "assets/images/cloud_3.png",
                  nightCloudAsset: "assets/images/cloud_3_night.png",
                  timeType: widget.timeType,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 100, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 100, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud1AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Cloud(
                    dayCloudAsset: "assets/images/cloud_1.png",
                    nightCloudAsset: "assets/images/cloud_1_night.png",
                    timeType: widget.timeType,
                    width: 200,
                    height: 200,
                  )),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 200, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 200, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud2AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Cloud(
                    dayCloudAsset: "assets/images/cloud_2.png",
                    nightCloudAsset: "assets/images/cloud_2_night.png",
                    timeType: widget.timeType,
                    width: 200,
                    height: 200,
                  )),
            ),

            //STATIC CLOUDS
            Positioned(
              right: -50,
              bottom: 0,
              // child: Cloud(
              //   key: const Key("static_cloud_1"),
              //   dayCloudAsset: "assets/images/cloud_3.png",
              //   nightCloudAsset: "assets/images/cloud_3_night.png",
              //   timeType: widget.timeType,
              //   width: 200,
              //   height: 200,
              // ),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 2),
                child: widget.timeType == TimeType.day
                    ? Image.asset(
                        key: const ValueKey("static_cloud_1_day"),
                        "assets/images/cloud_3.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        key: const ValueKey("static_cloud_1_night"),
                        "assets/images/cloud_3_night.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              left: -50,
              top: -50,
              child: Cloud(
                key: const Key("static_cloud_2"),
                dayCloudAsset: "assets/images/cloud_4.png",
                nightCloudAsset: "assets/images/cloud_4_night.png",
                timeType: widget.timeType,
                width: 200,
                height: 200,
              ),
            ),
            Positioned(
              key: const Key("static_cloud_3"),
              left: -100,
              bottom: -50,
              child: Cloud(
                dayCloudAsset: "assets/images/cloud_2.png",
                nightCloudAsset: "assets/images/cloud_2_night.png",
                timeType: widget.timeType,
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class Cloud extends StatefulWidget {
  final TimeType timeType;
  final String dayCloudAsset;
  final String nightCloudAsset;
  final double width;
  final double height;

  const Cloud({
    super.key,
    required this.timeType,
    required this.dayCloudAsset,
    required this.nightCloudAsset,
    required this.width,
    required this.height,
  });

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      child: widget.timeType == TimeType.day
          ? Image.asset(
              key: ValueKey("${widget.dayCloudAsset}_day"),
              widget.dayCloudAsset,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            )
          : Image.asset(
              key: ValueKey("${widget.dayCloudAsset}_night"),
              widget.nightCloudAsset,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            ),
    );
  }
}
