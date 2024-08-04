import 'package:calendar_app/screen_home.dart';
import 'package:flutter/material.dart';
class authencheck extends StatefulWidget {
  const authencheck({super.key});

  @override
  State<authencheck> createState() => _authencheckState();
}

class _authencheckState extends State<authencheck> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.00),
                child: Text('Profile',
                style: TextStyle(fontSize: 32.00,fontWeight: FontWeight.bold),),
              ),
            Center(
                child: CircleAvatar(
                  radius:70.0,
                  backgroundImage: NetworkImage('https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?t=st=1721577515~exp=1721581115~hmac=85c0c9ad76d5eed77a7cfb720b142a6969d87df5088a60b812503d560134b8a6&w=740'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.00),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.00),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.00),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Admission Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.00),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.00),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Batch',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      )
                  ),
                ),
              ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ScreenHome()));
                    }, child: Text('Continue')),
                  ))
            ],
          )),
    );
  }
}