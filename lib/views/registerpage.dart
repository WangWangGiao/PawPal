import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  String? username;
  String? email;
  String? password;
  String? phone;
  bool visible = true;
  bool isLoading = false;

  late double screenWidth;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  'Create an account and start exploring to find your forever furry friend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                //Reference https://api.flutter.dev/flutter/material/TextFormField-class.html
                //https://stackoverflow.com/questions/56730412/change-the-default-border-color-of-textformfield-in-flutter
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //Username TextFormField
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.person, color: Colors.black),
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
                          hintText: 'Enter Your UserName',
                          labelText: 'Username',
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
                            return "Please fill in username";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                      //Email TextFormField
                      TextFormField(
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
                            return "Password must at least 6 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      //Confirm Password TextFormField
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        obscureText: visible,
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
                          hintText: 'Enter Password Again',
                          labelText: 'Confirm Password',
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
                            return "Please fill in confirm password";
                          }
                          if (value != passwordController.text) {
                            return "Password do not match";
                          }
                          return null;
                        },
                      ),
                      //Phone TextFormField
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.phone, color: Colors.black),
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
                          hintText: 'Enter Your Phone Number',
                          labelText: 'Phone Number',
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
                            return "Please fill in phone number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phone = value;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 30, 72, 145),
                            ),
                          ),
                          onPressed: registerCheck,
                          child: Text(
                            'Sign Up',
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
                          if(!mounted) return;
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Login here',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerCheck() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Register Account',style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 28, 59, 112)),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                registerUser(username, email, password, phone);
              },
              child: Text('Register',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
          ],
          content: Text('Are you sure you want to register this account?',style: TextStyle(fontSize: 18,color: Colors.black),),
        ),
      );
    } else {
      return;
    }
  }

  void registerUser(String? username,String? email,String? password,String? phone,) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.blueAccent,),
              SizedBox(width: 30),
              Text('Registering...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/register_user.php'),
          body: {
            'name': username,
            'email': email,
            'password': password,
            'phone': phone,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    resarray['message'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
                  )
                ),
              );
              if (isLoading) {
                if (!mounted) return;
                Navigator.pop(context); //Close the loading dialog
                setState(() {
                  isLoading = false;
                });
              }
              Navigator.pop(context);
              Navigator.pushReplacement(//Close the register page
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
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

    //Close the loading dialog if register failed or error occured.
    if (isLoading) {
      Navigator.pop(context); //Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}
