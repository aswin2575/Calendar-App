import 'package:calendar_app/screen_admin_error.dart';
import 'package:calendar_app/screen_admin_signup.dart';
import 'package:calendar_app/screen_home.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading = false;
  late final Server server = Server.instance!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
      Column(
        children: [
          SizedBox(
            height: 80.00,
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/images/images.jpeg'),
              radius: 80.00,
            ),
          ),
          SizedBox(
            height: 20.00,
          ),
          Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 24),
            child: Column(
              children: [
                Text('Welcome to ASIET TIMES',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                Text("Stay updated with all the events at Adi Shankara Institute of Engineering and Technology, Kalady. From seminars to cultural activities, ASIET TIMES keeps you informed and engaged with everything happening on campus.",textAlign: TextAlign.justify,),
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: FilledButton.tonal(
        onPressed: loading? null: () {
          setState(() {
            loading=true;
          });
          server.signIn(
            context: context,
            signupBuilder: (context, user) => ScreenAdminSignup(user: user,),
            signupErrorBuilder: (context) => ScreenAdminError()
          ).then((success){
            setState(() => loading=false);

            if (success){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScreenHome()),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Access Denied'),
                    content: Text("Please contact the administrative office to get access or verify your registration. Only students of ASIET are allowed to use this application.",textAlign: TextAlign.justify,),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          // Perform additional actions if necessary
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          });
        },
        child: loading
          ?SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        :Text('Get Started'),
      ),
    );
  }
}
