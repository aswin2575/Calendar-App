import 'dart:math';

import 'package:calendar_app/channel_sheet.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

import 'event_card.dart';
import 'event_details.dart';
class ScreenChannels extends StatefulWidget {
  const ScreenChannels({super.key});

  @override
  State<ScreenChannels> createState() => _ScreenChannelsState();
}

class _ScreenChannelsState extends State<ScreenChannels> {
  final currentUser = Server.instance!.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card.filled(
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Text('Channel Title'),
                  onTap: (){},
                ),
              ),
            ),
          )),
    );
  }
}
// class EventCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String description;
//   final String imageUrl;
//
//   const EventCard({
//     Key? key,
//     required this.title,
//     required this.date,
//     required this.description,
//     required this.imageUrl,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//       elevation: 5.0,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
//             child: Image.network(
//               imageUrl,
//               height: 150,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 5.0),
//                 Text(
//                   date,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final server = Server.instance!;

  late final List<Event> events = server.dummy() ;

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
                    child: Text('Events'),
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
      body: events!.isEmpty? const Text('No Feeds Available'): ListView(
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
      floatingActionButton: FloatingActionButton(onPressed: (){},
        child: Icon(Icons.add),),
    );
  }
}
