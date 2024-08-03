//import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:calendar_app/profile_sheet.dart';
import 'package:calendar_app/screen_channels.dart';
import 'package:calendar_app/screen_events.dart';
import 'package:calendar_app/screen_feeds.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  var _currentPageIndex = 0;
  final _pages = const [
    ScreenFeeds(),
    ScreenEvents(),
    ScreenChannels()
  ];
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    elevation: WidgetStatePropertyAll<double>(0),
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 16, right: 8)),
                    controller: controller,
                    hintText: 'Search Events & Channels',
                    leading: Icon(Icons.search),
                    trailing: [
                      GestureDetector(
                        child: CircleAvatar(
                          //backgroundImage: NetworkImage('https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740'),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/images/aswin.png', // Local image
                              image: 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740', // Network image
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                // Display the local image if network image fails
                                return Image.asset(
                                  'lib/images/aswin.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return profilesheet();

                            },
                          );
                        },
                      )
                    ],
                  );
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
                  });
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: _pages,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
            pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event), label: 'My Events'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Channels')
        ],
      ),
    );
  }
}
