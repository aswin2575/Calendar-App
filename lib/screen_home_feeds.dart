import 'package:calendar_app/event_card.dart';
import 'package:calendar_app/event_details.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenFeeds extends StatefulWidget {
  const ScreenFeeds({super.key});

  @override
  State<ScreenFeeds> createState() => _ScreenFeedsState();
}

class _ScreenFeedsState extends State<ScreenFeeds> {
  final server = Server.instance!;

  late List<Event> feeds;
  late List<Event> followingEvents;
  bool loading = true;

  Future<void> loadData() async {
    final results = await Future.wait([
      server.getNewsFeeds(),
      server.currentUser!.followingEvents
    ]);
    feeds = results[0].map((event) => event!).toList();
    followingEvents = results[1].map((event) => event!).toList();
  }

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading? const Text('Loading Feeds'): feeds.isEmpty? const Text('No Feeds Available'): ListView(
        children: feeds.map((event) => GestureDetector(
          child: EventCard(
            event: event,
            showTime: false,
            actionButton: event.channel == null? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
              followingEvents.contains(event)? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
              FilledButton.tonal(onPressed: () {}, child: const Text('Follow')),
          ),
          onTap: () => showModalBottomSheet(
              context: context,
              useSafeArea: true,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  maxChildSize: 0.9,
                  minChildSize: 0.2,
                  expand: false,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: EventDetails(event: event)
                    );
                  },
                );
              }
          ),
        )).toList()
      )
    );
  }
}
