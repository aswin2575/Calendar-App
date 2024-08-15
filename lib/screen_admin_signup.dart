import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenAdminSignup extends StatelessWidget {
  const ScreenAdminSignup({super.key, required this.user});
  final User user;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
              child: Container(
                child: Card.filled(
                  child: ListTile(
                    leading: CircleAvatar(
                      //backgroundImage: NetworkImage('https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740'),
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'lib/images/profile.png', // Local image
                          image: user.photoUrl, // Network image
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            // Display the local image if network image fails
                            return Image.asset(
                              'lib/images/profile.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(user.isAdmin? Icons.admin_panel_settings: Icons.account_circle,
              size: 150,),
            ),
            Center(
              child: user.isAdmin?
                Text('You are an Admin', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold), ):
                Text('Hey ${user.name}', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold), )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
              child: user.isAdmin?
                Text('Welcome to the Admin Panel! As an administrator, you have full access to manage and oversee all aspects of this application',textAlign: TextAlign.justify,):
                Text('As a registered student, you can view and manage your college events through this application. Stay updated on upcoming activities, register for events, and track your participation to make the most of your college experience',textAlign: TextAlign.justify,)
            ),
            if(!(user.isAdmin&&user.department==null))
            Card.filled(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Descriptor(title: user.department!.name,subtitle: 'Department',),
                    if (!user.isAdmin && user.admissionYear != null) Divider(),
                    if (!user.isAdmin && user.admissionYear != null) Descriptor(title: '${user.admissionYear}-${user.admissionYear!+4}',subtitle: 'Admission Year',),
                    if (!user.isAdmin && user.semester != null) Divider(),
                    if (!user.isAdmin && user.semester != null) Descriptor(title: user.semester!.toString(),subtitle: 'Semester',),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(onPressed: (){
                      Navigator.of(context).pop(true);
                    }, child: Text('Continue')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class Descriptor extends StatelessWidget {
  const Descriptor({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(fontSize: 15),),
          if(subtitle !=null)
            Text(subtitle!,style: TextStyle(fontSize: 12),),
        ],
      ),
    );
  }
}

