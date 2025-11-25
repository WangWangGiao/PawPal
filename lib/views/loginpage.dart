import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isChecked = false;
  bool visible = true;
  String? email;
  String? password;

  late User user;
  late double screenWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPreferences();
  }
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth > 400){
      screenWidth = 400;
    }else{
      screenWidth = screenWidth;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                Text(
                  'Login Here',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  'Welcome back! Your furry friend is waiting for you',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 65),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //Email TextFormField
                      TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.email, color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 14, 45, 98),
                              width: 3,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                          hintText: 'Enter Your Email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in email";
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 5),
                      //Password TextFormField
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        obscureText: visible,
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.lock, color: Colors.black),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: IconButton(
                              onPressed: () {
                                if (visible) {
                                  visible = false;
                                } else {
                                  visible = true;
                                }
                                setState(() {});
                              },
                              icon: Icon(Icons.visibility),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 14, 45, 98),
                              width: 3,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                          hintText: 'Enter Your Password',
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in password";
                          }
                          if (value.length < 6) {
                            return "Password must at least 6 character";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {isChecked = value!;});
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color.fromARGB(255, 30, 72, 145),
                      ),
                    ),
                    onPressed: loginValidate,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (!mounted) return;
                    setState(() {
                      formKey.currentState!.reset();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an account yet? Register here",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loginValidate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      loginUser(email,password);
    } else {
      return;
    }
  }
  
  void loginUser(String? email, String? password) async {
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/login_user.php'),
          body: {
            'email': email,
            'password': password,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              user = User.fromJson(resarray['data'][0]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  content: Text(
                    resarray['message'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
                  )
                ),
              );
              prefUpdate(isChecked);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context,).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    resarray['message'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
                  )
                )
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Registration failed. CODE: ${response.statusCode}', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
        })
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Request failed. Please try again later', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                )
              ),
            );
          },
        );
  }
}
