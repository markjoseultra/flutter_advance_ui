import 'package:flutter/material.dart';

// ignore: implementation_imports
import 'package:flutter/src/rendering/sliver_persistent_header.dart';

class FancyScrollPage extends StatefulWidget {
  const FancyScrollPage({super.key});

  @override
  State<FancyScrollPage> createState() => _FancyScrollPageState();
}

class _FancyScrollPageState extends State<FancyScrollPage> {
  final ScrollController mainScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: mainScrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: MediaPlayerSection(
            minHeight: 300,
            maxHeight: 300,
          ),
        ),
        SliverToBoxAdapter(
          child: DetailsOne(
            title: "How to make a youtube UI",
            subtitle: "110k views 3w ago",
            channelName: "FTV",
            subscribers: "107k",
            onSubscribe: () {},
          ),
        ),
        const SliverToBoxAdapter(
          child: ShortsSection(),
        ),
        SliverAnimatedOpacity(
          opacity: 1,
          duration: const Duration(seconds: 1),
          sliver: SliverPersistentHeader(
            pinned: true,
            delegate: CategorySection(
              minHeight: 50,
              maxHeight: 50,
              categories: [
                "All",
                "Esports",
                "Mobile Games",
                "Related",
                "For you",
              ],
            ),
          ),
        ),
        const RecommendationSection(),
        const SliverToBoxAdapter(
          child: ShortsSection(),
        ),
        const RecommendationSection(),
      ],
    );
  }
}

class MediaPlayerSection implements SliverPersistentHeaderDelegate {
  MediaPlayerSection({
    required this.minHeight,
    required this.maxHeight,
  });

  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxHeight,
      color: Colors.black,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent;
  }

  @override
  TickerProvider? get vsync => null;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      const PersistentHeaderShowOnScreenConfiguration();

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}

class CategorySection implements SliverPersistentHeaderDelegate {
  CategorySection({
    required this.minHeight,
    required this.maxHeight,
    required this.categories,
  });

  final double minHeight;
  final double maxHeight;
  final List<String> categories;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: maxExtent,
      child: ListView.builder(
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Chip(
              backgroundColor: Colors.grey,
              label: Text(
                categories[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent;
  }

  @override
  TickerProvider? get vsync => null;

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      const PersistentHeaderShowOnScreenConfiguration();

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}

class DetailsOne extends StatelessWidget {
  final String title;
  final String subtitle;
  final String channelName;
  final String subscribers;
  final VoidCallback onSubscribe;

  const DetailsOne({
    super.key,
    required this.title,
    required this.subtitle,
    required this.channelName,
    required this.subscribers,
    required this.onSubscribe,
  });

  final TextStyle titleStyle = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 11.0,
  );

  final TextStyle channelStyle = const TextStyle(
    fontSize: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: titleStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subtitle, style: subtitleStyle),
              TextButton(
                onPressed: () {},
                child: Text(
                  "...more",
                  style: subtitleStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    maxRadius: 15,
                    child: Text(channelName.substring(0, 1)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    channelName,
                    style: subtitleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    subscribers,
                    style: subtitleStyle.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onSubscribe,
                child: const Text("Subscribe"),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ShortsSection extends StatelessWidget {
  const ShortsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey),
            );
          }),
    );
  }
}

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 250.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          );
        });
  }
}
