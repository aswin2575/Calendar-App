import 'package:flutter/material.dart';

class ScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
          SizedBox.square(dimension: 8,),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Faculties',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                      IconButton(onPressed: null, icon: Icon(Icons.navigate_before_rounded)),
                      SizedBox(width: 4,),
                      Text('0 of 10'),
                      SizedBox(width: 4,),
                      IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
                      SizedBox(width: 4,),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add))
                    ],
                  ),
                ),
                Divider(),
                Center(child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
                  child: Text('No Faculties', style: TextStyle(color: colorScheme.secondaryFixedDim),),
                ))
              ],
            ),
          ),
          SizedBox.square(dimension: 8,),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Students',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ),
                      IconButton(onPressed: null, icon: Icon(Icons.navigate_before_rounded)),
                      SizedBox(width: 4,),
                      Text('0 of 10'),
                      SizedBox(width: 4,),
                      IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next_rounded)),
                      SizedBox(width: 4,),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add))
                    ],
                  ),
                ),
                Divider(),
                Center(child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
                  child: Text('No Students', style: TextStyle(color: colorScheme.secondaryFixedDim),),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

}