
import 'package:flutter/material.dart';
class ScreenAdminError extends StatelessWidget {
  const ScreenAdminError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          children: [
          //   SizedBox(
          //   height: 100,
          // ),
            Padding(
              padding: EdgeInsets.only(left: 8,right: 8,top: 128,bottom: 32),
              child: Icon(Icons.person_off,
              size: 150,),
            ),
            Text('Unauthorized User',style: TextStyle(fontSize: 24),),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("It looks like you don't have the necessary permissions to access this section. If you believe this is an error or you need access, please contact the system administrator or your college support team for assistance. We apologize for any inconvenience.",textAlign: TextAlign.justify,),
            ),
          ],
        ),
      )),
    );
  }
}
