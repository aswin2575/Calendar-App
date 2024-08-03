import 'package:calendar_app/event_card.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenFeeds extends StatefulWidget {
  ScreenFeeds({super.key});

  @override
  State<ScreenFeeds> createState() => _ScreenFeedsState();
}

class _ScreenFeedsState extends State<ScreenFeeds> {
  final server = Server.instance;

  List<Event>? feeds;

  @override
  void initState() {
    server.getNewsFeeds().then((feeds) => setState(() => this.feeds = feeds));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: feeds == null? const Text('Loading Feeds'): ListView(
        children: feeds!.map((event) => EventCard(
          event: event,
          showTime: false,
          // actionButton: ,
        )).toList()
      )
    );
  }
}
