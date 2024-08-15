import 'dart:math';

import 'package:calendar_app/channel_sheet.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

import 'event_card.dart';
import 'event_details.dart';
import 'event_edit_sheet.dart';

class ScreenChannels extends StatefulWidget {
  final Channel channel;
  const ScreenChannels({super.key, required this.channel});

  @override
  State<ScreenChannels> createState() => _ScreenChannelsState();
}

class _ScreenChannelsState extends State<ScreenChannels> {
  late final List<Event> events;
  bool loading = true;

  Future<void> loadData() async {
    final query = Event.collection.where('channel', isEqualTo: widget.channel.id);
    events = await Event.loadMultiple(query);
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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 48,
        leading:IconButton(
            padding:EdgeInsets.only(left: 0),
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)
        ),
        title: Container(
          padding: EdgeInsets.only(right: 12),
          child: Row(
            children: [
              CircleAvatar(),
              SizedBox(width: 8,),
              Expanded(
                  child: GestureDetector(
                    child: Text(widget.channel.name),
                  onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChannelSheet()));
                  },)),
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return IconButton(onPressed: () => controller.openView(), icon: Icon(Icons.search));
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = controller.text.length > 0? '${controller.text} $index': 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView('');
                        });
                      },
                    );
                  }
                );
              })
          ],
          ),
        ),
      ),
      body: loading? Center(child: const Text('Loading Events...')): events.isEmpty? Center(child: const Text('No Events')): ListView(
          children: events.map((event) => GestureDetector(
            child: EventCard(
              event: event,
              showTime: false,
              // actionButton: event.channel == null? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
              // server.currentUser!.followingEvents.contains(event)? OutlinedButton(onPressed: () {}, child: const Text('Remove')):
              // FilledButton.tonal(onPressed: () {}, child: const Text('Follow')),
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
      ),
      floatingActionButton:(!Server.instance!.currentUser!.isAdmin)? null:
        FloatingActionButton(
          onPressed: (){
            showModalBottomSheet<Event>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  minChildSize: 0.2,
                  initialChildSize: 0.6,
                  builder: (context, scrollController) => SingleChildScrollView(
                    controller: scrollController,
                    child: EventEditSheet(channel: widget.channel),
                  ),
                )
            ).then((event) {
              if (event != null) {
                setState(() {
                  events.add(event);
                });
              }
            });
          },
          child: Icon(Icons.add),
        ),
    );
  }
}
