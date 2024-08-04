import 'package:calendar_app/authen_check_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
class authenpage extends StatefulWidget {
  const authenpage({super.key});

  @override
  State<authenpage> createState() => _authenpageState();
}

class _authenpageState extends State<authenpage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(child:
      Column(
        children: [
          SizedBox(
            height: 80.00,
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('/calendar_app/lib/images/images.jpeg'),
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
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
                alignment: AlignmentDirectional.bottomEnd,
                child: ElevatedButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> authencheck()));
                }
                // {_signInWithGoogle().then((user) {
                //   if (user != null) {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return LoggedInScreen(user: user);
                //         },
                //       ),
                //     );
                //   }
                // });},
                    ,child: Text('Sign in'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                ))),
          )
        ],
      )),
    );
  }
}
// final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn _googleSignIn = GoogleSignIn();
// Future<User?> _signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//
//   final AuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//
//   final UserCredential userCredential = await _auth.signInWithCredential(credential);
//   final User? user = userCredential.user;
//
//   print("signed in " + user!.displayName!);
//   return user;
// }
// class LoggedInScreen extends StatelessWidget {
//   final User user;
//
//   LoggedInScreen({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(user.photoURL ?? ''),
//               radius: 50,
//             ),
//             SizedBox(height: 20),
//             Text('Name: ${user.displayName}'),
//             Text('Email: ${user.email}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

