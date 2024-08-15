import 'package:calendar_app/event_card.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:flutter/material.dart';

import 'event_details.dart';
import 'event_edit_sheet.dart';
import 'server/server.dart';

class ScreenEvents extends StatefulWidget {
  const ScreenEvents({super.key});

  @override
  State<ScreenEvents> createState() => _ScreenEventsState();
}

class _ScreenEventsState extends State<ScreenEvents> {
  late List<Event> myEvents;
  bool loading = true;

  Future<void> loadData() async {
    final server = Server.instance!;
    myEvents = await server.currentUser!.myEvents;
  }

  @override
  void initState() {
    super.initState();

    GlobalDataHolder.instance.registerSimpleCallback("HomeEventScreenFAB", onFabPressed);
    loadData().then((_) {
      if (mounted) setState(() => loading = false);
    });
  }


  @override
  void dispose() {
    super.dispose();

    GlobalDataHolder.instance.unregisterSimpleCallback("HomeEventScreenFAB", onFabPressed);
  }

  void onFabPressed() {
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
            child: const EventEditSheet(),
          ),
        )
    ).then((event) {
      if (event != null) {
        setState(() {
          myEvents.add(event);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: Text('Loading Events'));
    if (myEvents.isEmpty) return const Center(child: Text('No Events'),);
    return ListView(
      children: myEvents.map((event) {
        return GestureDetector(
          child: EventCard(
            event: event,
            actionButton: OutlinedButton(
              child: Text(event.channel == null? 'Remove': 'Unfollow'),
              onPressed: () {
                setState(() {
                  myEvents.remove(event);
                });
                if (event.channel == null) {
                  event.delete();
                } else{
                  Server.instance!.currentUser!.unfollowEvent(event);
                }
              },
            ),
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
                initialChildSize: event.imageUrl == null? 0.25: 0.6,
                builder: (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: EventDetails(event: event)
                  );
                },
              );
            }
          ),
        );
      }).toList(),
    );
  }
}
