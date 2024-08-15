import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' hide Query;
import 'package:flutter/material.dart';

import 'server/server.dart';

class ScreenAdmin extends StatelessWidget {
  const ScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final server = Server.instance!;
    final facultiesQuery = UserFrame.collection.where('isAdmin', isEqualTo: true);
    final studentsQuery = UserFrame.collection.where('isAdmin', isEqualTo: false);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            if (server.currentUser!.id == server.appAdminId) Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                leading: Icon(Icons.change_circle),
                title: Text('Transfer Ownership'),
                subtitle: Text('Change ownership to another user'),
                onTap: () {},
              ),
            ),
            SizedBox.square(dimension: 8,),
            UserFrameListView(title: 'Faculties', query: facultiesQuery, isAdmin: true,),
            SizedBox.square(dimension: 8,),
            UserFrameListView(title: 'Students', query: studentsQuery, isAdmin: false)
          ],
        ),
      ),
    );
  }

}

class UserFrameListView extends StatefulWidget {
  final String title;
  final bool? isAdmin;
  final Query<Map<String, dynamic>> query;
  const UserFrameListView({super.key, required this.title, required this.query, this.isAdmin});

  @override
  State<UserFrameListView> createState() => _UserFrameListViewState();
}

class _UserFrameListViewState extends State<UserFrameListView> {
  bool loading = true;
  List<UserFrame>? userFrames;

  @override
  void initState() {
    super.initState();

    UserFrame.loadMultiple(widget.query).then((userFrames) {
      this.userFrames = userFrames;
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6, left: 24, right: 8),
            child: Row(
              children: [
                Expanded( child: Text( widget.title, style: TextStyle( fontSize: 16 ), ), ),
                IconButton(onPressed: () {
                  showDialog<UserFrame>(context: context, builder: (context) => UserFrameDialog(title: widget.title, isAdmin: widget.isAdmin,)).then((result) {
                    if (result == null) return;

                    setState(() => userFrames!.add(result));
                  });
                }, icon: Icon(Icons.add))
              ],
            ),
          ),
          Divider(),
          if (loading || userFrames == null || userFrames!.isEmpty) Center(child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
            child: Text(loading? 'Loading...': 'No ${widget.title}', style: TextStyle(color: colorScheme.secondaryFixedDim),),
          ))
          else Column(
            children: userFrames!.map((userFrame) => ListTile(
              contentPadding: EdgeInsets.only(right: 8, left: 24),
              title: Text(userFrame.email, overflow: TextOverflow.ellipsis,),
              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                userFrame.delete();
                setState(() => userFrames!.remove(userFrame));
              })
            )).toList(),
          )
        ],
      ),
    );
  }
}

class UserFrameDialog extends StatefulWidget {
  final String title;
  final bool? isAdmin;
  const UserFrameDialog({super.key, required this.title, this.isAdmin});

  @override
  State<UserFrameDialog> createState() => _UserFrameDialogState();
}

class _UserFrameDialogState extends State<UserFrameDialog> {
  final emailController = TextEditingController();
  final yearController = TextEditingController();
  final departmentController = TextEditingController();
  late bool isAdmin = widget.isAdmin ?? false;
  final departments = Department.codes;

  bool get validInput => emailController.text.isNotEmpty && isAdmin? true: (yearController.text.isNotEmpty && departmentController.text.isNotEmpty);

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
    yearController.addListener(() => setState(() {}));
    departmentController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add ${widget.title}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(border: InputBorder.none, hintText: 'Email ID'),
          ),
          DropdownMenu(
            controller: departmentController,
            dropdownMenuEntries: departments.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
            inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
            hintText: 'Department',
            expandedInsets: EdgeInsets.zero,
          ),
          if (!isAdmin) TextField(
            keyboardType: TextInputType.number,
            controller: yearController,
            decoration: InputDecoration(border: InputBorder.none, hintText: 'Admission Year'),
          ),
          if (widget.isAdmin == null) Row(children: [
            Checkbox(value: isAdmin, onChanged: (value) => setState(() => isAdmin = value!)),
            Text('Faculty')
          ],)
        ],
      ),
      actions: [
        OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
        FilledButton.tonal(onPressed: validInput? () => Navigator.of(context).pop(
          UserFrame(email: emailController.text, isAdmin: isAdmin, department: departmentController.text.isNotEmpty? Department(code: departmentController.text): null, admissionYear: isAdmin? null: int.parse(yearController.text))
        ): null, child: Text('Save')),
      ],
    );
  }
}
