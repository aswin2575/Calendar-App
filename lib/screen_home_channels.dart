import 'package:calendar_app/screen_channels.dart';
import 'package:flutter/material.dart';

class ScreenHomeChannels extends StatelessWidget {
  const ScreenHomeChannels({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context, index) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
        leading: CircleAvatar(),
        title: Text("Channel $index"),
        subtitle: Text("Department"),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventListScreen(),));
        },
      );
    }, separatorBuilder: (context, index) => Divider(
      indent: 16,
      endIndent: 16,
      thickness: 0,
      height: 1,
    ),
        itemCount: 10);
  }
}
