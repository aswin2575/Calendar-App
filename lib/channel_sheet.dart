import 'package:flutter/material.dart';

class ChannelSheet extends StatefulWidget {
  const ChannelSheet({super.key});

  @override
  State<ChannelSheet> createState() => _ChannelSheetState();
}

class _ChannelSheetState extends State<ChannelSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                leading: Icon(Icons.change_circle),
                title: Text('Transfer Ownership'),
                subtitle: Text('Change ownership to another user'),
                onTap: () {},
              ),
            ),
          ],
        ),
      )
    );
  }
}
