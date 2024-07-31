import 'package:flutter/material.dart';

class profilesheet extends StatefulWidget {
  const profilesheet({super.key});

  @override
  State<profilesheet> createState() => _profilesheetState();
}

class _profilesheetState extends State<profilesheet> {
  var lst = <String>[];
  int inputs = 3;
  var editable=false;
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var widgets = lst.map((item) { return Text(item); } );
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.logout)),
            ],
          ),
          Center(
            child: CircleAvatar(
              radius:70.0,
              backgroundImage: NetworkImage('https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(child: Text('Aswin Babu',style: TextStyle(fontSize: 32.00),)),
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
                  Text('aswinbabu2575@gmail.com', style: TextStyle(
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
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                if (editable) IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      editable = false;
                    });
                  },
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interests',style: TextStyle(fontWeight: FontWeight.bold),
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
                        }, icon: Icon(Icons.done))
                      ],
                    )
                  ],
                ),
              ]
            ),
          ),
          //

          ListTile(title: Container(
            decoration: BoxDecoration(color: Colors.grey[850],
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
          )
          ,],
      ),
    );;
  }
}
