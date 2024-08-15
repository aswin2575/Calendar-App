import 'package:calendar_app/auth_page.dart';
import 'package:calendar_app/global_data_holder.dart';
import 'package:calendar_app/screen_admin_signup.dart';
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
  final themes=['System','Light','Dark'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode=GlobalDataHolder.instance.themeMode.value;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    MaterialPageRoute(builder: (context) => const AuthPage()));
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

        if(!(currentUser.isAdmin&&currentUser.department==null))
          Card.filled(
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Descriptor(title: currentUser.department!.name,subtitle: 'Department',),
                  if (!currentUser.isAdmin && currentUser.admissionYear != null) Divider(),
                  if (!currentUser.isAdmin && currentUser.admissionYear != null) Descriptor(title: '${currentUser.admissionYear}-${currentUser.admissionYear!+4}',subtitle: 'Admission Year',),
                  if (!currentUser.isAdmin && currentUser.semester != null) Divider(),
                  if (!currentUser.isAdmin && currentUser.semester != null) Descriptor(title: currentUser.semester!.toString(),subtitle: 'Semester',),
                ],
              ),
            ),
          ),
        //

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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Card.filled(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              leading: Icon(Icons.contrast),
              title: Text('Theme',style: TextStyle(fontSize: 16),),
              subtitle: Text(themes[themeMode.index]),
              onTap: () {
                showDialog<ThemeMode>(
                  context: context,
                  builder: (BuildContext context) => ThemeModeSelector(initialValue: themeMode,)
                ).then((result) {
                  if (result== null) return;
                  setState(() {
                    GlobalDataHolder.instance.themeMode.value=result;
                  });
                });
              },
            ),
          ),
        )
      ],
    );;
  }
}

class ThemeModeSelector extends StatefulWidget {
  const ThemeModeSelector({super.key, this.initialValue=ThemeMode.system});
  final ThemeMode initialValue;
  @override
  State<ThemeModeSelector> createState() => _ThemeModeSelectorState();
}

class _ThemeModeSelectorState extends State<ThemeModeSelector> {
  final themes=['System','Light','Dark'];
  late String selectedValue = themes[widget.initialValue.index];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: themes.map((e){
          return RadioListTile<String>(
            value: e,
            groupValue: selectedValue,
            title: Text(e),
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
          );
        }).toList()
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:(){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                Navigator.of(context).pop(ThemeMode.values[themes.indexOf(selectedValue)]);
              },
              child: const Text('OK'),
            ),
          ],
        )

      ],
    );
  }
}


