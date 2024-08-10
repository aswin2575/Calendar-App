import 'package:calendar_app/authen_page.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ProfileSheet extends StatefulWidget {
  const ProfileSheet({super.key});

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  var lst = <String>[];
  int inputs = 3;
  var editable=false;
  int? selectedIndex;
  final currentUser = Server.instance!.currentUser!;
  bool light=true;
  final ValueNotifier<int> _selectedValueNotifier = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<ThemeData> _themes = [
    ThemeData.light(),
    ThemeData.dark()];
    //bool? _checked=false;
    int tempSelectedValue = _selectedValueNotifier.value;
    var widgets = lst.map((item) { return Text(item); } );
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30,),
        Stack(
          children: [
        Center(
          child: CircleAvatar(
            radius:70.0,
            backgroundImage: NetworkImage(currentUser.photoUrl),
          ),
        ),
        Positioned(
          //top: 20,
          right: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                Server.instance!.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const authenpage()));
              }, icon: Icon(Icons.logout)),
            ],
          ),
        ),
        ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(child: Text(currentUser.name,style: TextStyle(fontSize: 32.00),)),
        SizedBox(
          height: 8,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),),
            child: Row(
              children: [SizedBox(width: 8.00),
                Icon(Icons.mail, color: colorScheme.onTertiaryContainer, size: 18,),
                SizedBox(width: 8.00),
                Text(currentUser.email, style: TextStyle(
                    color: colorScheme.onTertiaryContainer
                ),),
                SizedBox(width: 8.00),
              ],
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,),
          ),
        ),
        SizedBox(
          height: 30,
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: editable? 16: 0),
          decoration: editable? BoxDecoration(
            color: colorScheme.surfaceContainerHigh
          ): null,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Interests',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                  if (editable) IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        editable = false;
                      });
                    },
                  ),
                ],
              ),

              Center(
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    children: List<Widget>.generate(
                        inputs,
                            (index) {
                          return editable? InputChip(
                            label: Text('Person ${index + 1}'),
                            backgroundColor: colorScheme.surfaceContainerHigh,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selectedIndex == index) {
                                  selectedIndex = null;
                                } else {
                                  selectedIndex = index;
                                }
                              });
                            },
                            onDeleted: () {
                              setState(() {
                                inputs = inputs - 1;
                              });
                            },
                          ): Chip(
                              label: Text('Item $index'),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0)
                          );
                        }
                    ) + [
                      if (!editable) IconButton(onPressed: () {
                        setState(() {
                          editable = true;
                        });
                      }, icon: Icon(Icons.edit))
                    ]
                ),
              ),
              if (editable) Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add Interest'
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    setState(() {
                      inputs += 1;
                    });
                  }, icon: Icon(Icons.add))
                ],
              )
            ],
          ),
        ),
        //

        ListTile(title: Container(
          decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // SizedBox(width: 20,),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [SizedBox(width: 150,),
                  Text('Department\nSemester\nAdmission',style: TextStyle(fontWeight: FontWeight.bold),),
                ],),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('CSE\nS6\n21BCS080'),
                ],),
              // SizedBox(width: 20,),
            ],
          ),
        ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: Text('Settings',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20),),
        ),
        // ListTile(
        //   leading: Text('Dark Theme',style: TextStyle(fontSize: 20),),
        //   trailing: Switch(
        //     value: light,
        //     onChanged:(bool value){
        //       setState(() {
        //         light=value;
        //       });
        //     } ,),
        // ),
        ListTile(
          leading: Text('Theme',style: TextStyle(fontSize: 16),),
          onTap: () {
            tempSelectedValue=_selectedValueNotifier.value;
            showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Theme'),
              content: ValueListenableBuilder<int>(
                valueListenable: _selectedValueNotifier,
                  builder: (context,selectedValue, child){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<int>(
                        value: 1,
                        groupValue: selectedValue,
                        title: Text('Light'),
                        onChanged: (int? value) {
                          _selectedValueNotifier.value = value!;
                        },
                      ),
                      RadioListTile<int>(
                        value: 2,
                        groupValue: selectedValue,
                        title: Text('Dark'),
                        onChanged: (int? value) {
                          _selectedValueNotifier.value = value!;
                        },
                      ),
                    ],
                  );
                  }
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:(){
                        _selectedValueNotifier.value=tempSelectedValue;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();

                      },
                      child: const Text('OK'),
                    ),
                  ],
                )

              ],
            ),
          );},
        )
      ],
    );;
  }
}
