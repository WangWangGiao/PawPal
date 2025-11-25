import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autologin();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/pawpal_icon.png'),
            Padding(
              padding: const EdgeInsets.fromLTRB(50,90,50,0),
              child: LinearProgressIndicator(color: Colors.blueAccent,),
            )
          ],
        ),
        ),
      );
  }
  
  void autologin() {
    SharedPreferences.getInstance().then((prefs){
      bool? rememberMe = prefs.getBool('rememberMe');
      if(rememberMe != null && rememberMe){
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http.post(Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/login_user.php'),
          body: {
            'email': email,
            'password': password,
          },
        ).then((response){
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              User user = User.fromJson(resarray['data'][0]);
              Future.delayed(Duration(seconds: 3),(){
                if(!mounted) return;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(user: user)));
              });
            } else {
              if (!mounted) return;
              Future.delayed(Duration(seconds: 3),(){
                if(!mounted) return;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              });
            }
          } else {
            if (!mounted) return;
              Future.delayed(Duration(seconds: 3),(){
                if(!mounted) return;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              });
          }
        });
      }else{
        if (!mounted) return;
        Future.delayed(Duration(seconds: 3),(){
          if(!mounted) return;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
        });
      }
    });
  }
}