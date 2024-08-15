import 'package:calendar_app/screen_channels.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenHomeChannels extends StatefulWidget {
  const ScreenHomeChannels({super.key});

  @override
  State<ScreenHomeChannels> createState() => _ScreenHomeChannelsState();
}

class _ScreenHomeChannelsState extends State<ScreenHomeChannels> {
  late List<Channel> myChannels;
  bool loading = true;

  Future<void> loadData() async {
    final server = Server.instance!;
    final currentUser = server.currentUser!;
    myChannels = await (currentUser.isAdmin? Channel.loadMultiple(null): currentUser.myChannels);
  }

  @override
  void initState() {
    super.initState();

    // GlobalDataHolder.instance.registerSimpleCallback("HomeEventScreenFAB", onFabPressed);
    loadData().then((_) {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: Text('Loading Channels'));
    else if (myChannels.isEmpty) return const Center(child: Text('No Channels'),);
    return ListView(
      children: myChannels.map((channel) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24),
          leading: CircleAvatar(),
          title: Text(channel.name, overflow: TextOverflow.ellipsis,),
          subtitle: Text("Owned by ${channel.owner.name}"),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenChannels(channel: channel,),));
          },
        );
      }).toList(),
    );
  }
}
