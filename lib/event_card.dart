import 'package:calendar_app/info_chips.dart';
import 'package:flutter/material.dart';

import 'server/server.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final bool showTime;
  final Widget? actionButton;
  final void Function()? onRemove;

  const EventCard( { super.key, required this.event, this.showTime = true, this.onRemove, this.actionButton } );

  @override
  State<StatefulWidget> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  late final Event event;
  late final Channel? channel;
  
  @override
  void initState() {
    super.initState();

    event = widget.event;
    channel = event.channel;
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.imageUrl != null)
            Stack(
              fit: StackFit.passthrough,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    event.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                InfoChips(
                    currentTheme: currentTheme,
                    owner: channel?.name,
                    showTime: widget.showTime,
                    dateTime: event.scheduledDateTime!)
              ],
            ),
          ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Text(event.title, overflow: TextOverflow.ellipsis)
                ),
                if (event.imageUrl == null)
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: InfoChips(
                      currentTheme: currentTheme,
                      owner: channel?.name,
                      inline: true,
                      showTime: widget.showTime,
                      dateTime: event.scheduledDateTime!,
                    ),
                  )
              ],
            ),
            trailing: widget.actionButton)
        ],
      ));
  }
}
