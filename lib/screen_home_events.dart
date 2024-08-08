import 'package:calendar_app/event_card.dart';
import 'package:flutter/material.dart';

import 'server/server.dart';

class ScreenEvents extends StatelessWidget {
  const ScreenEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Server.instance!.currentUser!.myEvents;
    if (events.isEmpty) return const Center(child: Text('No Events'),);
    return ListView(
      children: events.map((event) => EventCard(event: event)).toList(),
    );
  }
}
