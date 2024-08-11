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

  List<Event>? feeds;

  @override
  void initState() {
    super.initState();
    server.getNewsFeeds().then((feeds) => setState(() => this.feeds = feeds));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: feeds == null? const Text('Loading Feeds'): feeds!.isEmpty? const Text('No Feeds Available'): ListView(
        children: feeds!.map((event) => GestureDetector(
          child: EventCard(
            event: event,
            showTime: false,
            actionButton: event.channel == null? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
              server.currentUser!.followingEvents.contains(event)? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
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
