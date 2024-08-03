import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'server/server.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  final months = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (event.imageUrl != null)
            Container(
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                event.imageUrl!,
                fit: BoxFit.fitWidth,
              ),
            ),
          const SizedBox(height: 8,),
          Wrap(
            spacing: 4,
            children: event.tags.map((tag) => Chip(
              label: Text(tag),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
            )).toList(),
          ),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: currentTheme.surfaceContainerHigh),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.location != null) InfoTile(leading: Icon(Icons.location_on_outlined), title: Text(event.location!),),
                InfoTile(leading: Icon(Icons.event), title: Text("${months[event.scheduledDateTime!.month - 1]} ${event.scheduledDateTime!.day}, ${event.scheduledDateTime!.year}"),),
                InfoTile(leading: Icon(Icons.watch_later_outlined), title: Text(getFormattedTime(event.scheduledDateTime!)),),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: currentTheme.surfaceContainerHigh),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: event.contacts.map((contact) => InfoTile(leading: Icon(Icons.person_outline), title: Text('${contact.name} (${contact.phone})'),),).toList(),
            ),
          ),
          if (event.description != null) Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(event.description!)
          )
        ],
      ),
    );
  }

}

class InfoTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;

  const InfoTile({super.key, this.leading, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null) SizedBox(width: 16,),
          title
        ],
      ),
    );
  }
}