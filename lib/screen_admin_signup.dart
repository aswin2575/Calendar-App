import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class ScreenAdminSignup extends StatelessWidget {
  const ScreenAdminSignup({super.key});


  //final currentUser = Server.instance!.currentUser!;
  final bool admin=true;

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
                          placeholder: 'lib/images/aswin.png', // Local image
                          image: 'lib/images/images.jpeg', // Network image
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            // Display the local image if network image fails
                            return Image.asset(
                              'lib/images/aswin.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),),
                    title: Text("Aswin Babu"),
                    subtitle: Text("aswinbabu2575@gmail.com"),
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(admin? Icons.admin_panel_settings: Icons.account_circle,
              size: 150,),
            ),
            Center(
              child: admin?
                Text('You are an Admin', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold), ):
                Text('Hey Aswin Babu', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold), )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
              child: admin?
                Text('Welcome to the Admin Panel! As an administrator, you have full access to manage and oversee all aspects of this application. Your responsibilities include monitoring user activity, managing content, ensuring the security of the platform, and maintaining a smooth user experience for everyone.',textAlign: TextAlign.justify,):
                Text('As a registered student, you can view and manage your college events through this application. Stay updated on upcoming activities, register for events, and track your participation to make the most of your college experience',textAlign: TextAlign.justify,)
            ),
            Card.filled(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Descriptor(title: 'CSE',subtitle: 'Department',),
                    if (!admin) Divider(),
                    if (!admin) Descriptor(title: '2021-2025',subtitle: 'Admission Year',),
                    if (!admin) Divider(),
                    if (!admin) Descriptor(title: 'S7',subtitle: 'Semester',),
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
                    child: FilledButton(onPressed: (){}, child: Text('Continue')),
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
          Text(title),
          if(subtitle !=null)
            Text(subtitle!),
        ],
      ),
    );
  }
}

