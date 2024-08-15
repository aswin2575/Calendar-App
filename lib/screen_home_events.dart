import 'package:calendar_app/event_card.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:flutter/material.dart';

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
    loadData().then((_) => setState(() => loading = false));
  }


  @override
  void dispose() {
    super.dispose();

    GlobalDataHolder.instance.unregisterSimpleCallback("HomeEventScreenFAB", onFabPressed);
  }

  void onFabPressed() {
    final server = Server.instance!;
    final currentUser = server.currentUser!;

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
    else if (myEvents.isEmpty) return const Center(child: Text('No Events'),);
    return ListView(
      children: myEvents.map((event) => EventCard(event: event)).toList(),
    );
  }
}
