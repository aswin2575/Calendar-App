//import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:calendar_app/event_edit_sheet.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:calendar_app/profile_sheet.dart';
import 'package:calendar_app/screen_home_admin.dart';
import 'package:calendar_app/screen_home_channels.dart';
import 'package:calendar_app/screen_home_events.dart';
import 'package:calendar_app/screen_home_feeds.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  var _currentPageIndex = 0;
  final _pages = [
    const ScreenFeeds(),
    const ScreenEvents(),
    const ScreenHomeChannels(),
    if (Server.instance!.currentUser!.isAdmin) ScreenAdmin()
  ];
  final pageController = PageController(initialPage: 0);
  final currentUser = Server.instance!.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      floatingActionButton: (_currentPageIndex == 1 || (_currentPageIndex == 2 && Server.instance!.currentUser!.isAdmin)) ? FloatingActionButton(onPressed: () {
        if (_currentPageIndex == 1) {
          GlobalDataHolder.instance.invokeSimpleCallback("HomeEventScreenFAB");
        }
      }, child: Icon(Icons.add),): null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    onTap: () => controller.openView(),
                    onChanged: (_) => controller.openView(),
                    elevation: const WidgetStatePropertyAll<double>(0),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.only(left: 16, right: 8)),
                    controller: controller,
                    hintText: 'Search Events & Channels',
                    leading: const Icon(Icons.search),
                    trailing: [
                      GestureDetector(
                        child: CircleAvatar(
                          //backgroundImage: NetworkImage('https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740'),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'lib/images/profile.png', // Local image
                              image: currentUser.photoUrl, // Network image
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                // Display the local image if network image fails
                                return Image.asset(
                                  'lib/images/profile.png',
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
                              return DraggableScrollableSheet(
                                expand: false,
                                minChildSize: 0.2,
                                maxChildSize: 0.95,
                                initialChildSize: 0.6,
                                builder: (BuildContext context, ScrollController scrollController) {
                                  return SingleChildScrollView(
                                    controller: scrollController,
                                    child: const ProfileSheet(),
                                  );
                                },
                              );

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
                onPageChanged: (index) => setState(() => _currentPageIndex = index),
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
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.event), label: 'My Events'),
          const NavigationDestination(icon: Icon(Icons.groups), label: 'Channels'),
          if (Server.instance!.currentUser!.isAdmin) const NavigationDestination(icon: Icon(Icons.admin_panel_settings), label: 'Admin Panel')
        ],
      ),
    );
  }
}