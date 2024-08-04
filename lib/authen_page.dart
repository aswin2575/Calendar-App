import 'package:calendar_app/authen_check_page.dart';
import 'package:calendar_app/screen_home.dart';
import 'package:calendar_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class authenpage extends StatefulWidget {
  const authenpage({super.key});

  @override
  State<authenpage> createState() => _authenpageState();
}

class _authenpageState extends State<authenpage> {
  bool loading = false;
  late final Server server = Server.instance!;

  @override
  void initState() {
    super.initState();
    // Server.initialize().then((_) {
    //   server=Server.instance!;
    //   setState(() {
    //     loading=false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // if(!loading && server.currentUser!=null){
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => ScreenHome()),
    //   );
    // }
    int a=1;
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
                Text('ASIET',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                Text('Description:\nAdi Shankara Institute of Engineering & Technology was established at Kalady with the aim of providing value-added technical education with a flair of professional excellence and ethical values. The college is run by ADI SANKARA TRUST, a registered trust which has carved a niche in the educational sector by running Sree Sankara College, Sree Sarada School, Adi Sankara Training College, Sree Sarada Special School, DDU Kaushal Kendra all at Kalady.',textAlign: TextAlign.justify,),
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
          server.signIn().then((success){
            setState(() {
              loading=false;
            });
            if (success){
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ScreenHome()),
              );
            }
            else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sign-In Failed'),
                    content: Text("Couldn't find email\nPlease select email"),
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
