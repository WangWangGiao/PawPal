import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final User? user;
  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late double screenWidth, screenHeight;
  Uint8List? webImage, userPic;
  File? image;
  bool isAble = false;
  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: isAble ? () => pickimagedialog(0) : null,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.withValues(alpha: 0.3),
                //Load avatar or Replace with username first character
                backgroundImage: userPic != null
                    ? MemoryImage(userPic!)
                    : kIsWeb && webImage != null
                    ? MemoryImage(webImage!)
                    : !kIsWeb && image != null
                    ? FileImage(image!)
                    : widget.user?.userAvatar != null &&
                          widget.user!.userAvatar!.isNotEmpty
                    ? NetworkImage(
                        '${MyConfig.baseUrl}/pawpal/server/uploads/user_profile/userAvatar_${widget.user!.userId}.png',
                      )
                    : null,
                child:
                    userPic == null &&
                        image == null &&
                        webImage == null &&
                        (widget.user?.userAvatar == null ||
                            widget.user!.userAvatar!.isEmpty)
                    ? Text(
                        widget.user?.userName?.substring(0, 1).toUpperCase() ??
                            "G",
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : isAble
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.white70,
                        size: 30,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  //Widget method
                  _buildLabel("Name"),
                  _buildInputField(
                    hint: "Enter your name",
                    icon: Icons.person,
                    isAble: isAble,
                    controller: nameController,
                  ),
                  const SizedBox(height: 10),
                  _buildLabel("Email Address"),
                  _buildInputField(
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                    isAble: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  _buildLabel("Phone Number"),
                  _buildInputField(
                    hint: "Enter your phone number",
                    icon: Icons.phone_outlined,
                    isAble: isAble,
                    controller: phoneController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        isAble
                            ? "Update Mode (Editable)"
                            : "View Mode (Read-only)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isAble ? Colors.orange : Colors.blue,
                        ),
                      ),
                      Switch(
                        value: isAble,
                        onChanged: (value) {
                          setState(() {
                            isAble = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth,
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 30, 72, 145),
                            ),
                          ),
                          onPressed: isAble
                              ? () {
                                  validateForm();
                                }
                              : null,
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(user: widget.user, currentPage: "profile"),
    );
  }

  // Text Widget Custom for textfield title (Label)
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // TextField Widget Custom
  Widget _buildInputField({
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool isAble = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          enabled: isAble,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[600])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black26, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openGallery(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage(index); // only for mobile
        setState(() {});
      }
    }
  }

  void pickimagedialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage(index);
      }
    }
  }

  Future<void> cropImage(int index) async {
    if (kIsWeb) {
      return;
    } // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      image = File(croppedFile.path);
      setState(() {});
    }
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text =
        prefs.getString('name') ?? widget.user!.userName.toString();
    emailController.text =
        prefs.getString('email') ?? widget.user!.userEmail.toString();
    phoneController.text =
        prefs.getString('phone') ?? widget.user!.userPhone.toString();
    setState(() {});
    ;
  }

  void prefUpdate(bool avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phoneController.text);
    prefs.setString('name', nameController.text);
    if (avatar) {
      prefs.setBool('userAvatar', true);
      widget.user?.userAvatar = "HasChanged";
    }
  }

  Future<void> validateForm() async {
    String username = nameController.text.trim();
    String useremail = emailController.text.trim();
    String userphone = phoneController.text.trim();
    if (username.isEmpty || useremail.isEmpty || userphone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            "Please fill in all requierd field",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            "Please fill in username",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    if (useremail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            "Please fill in email address",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(useremail)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text(
              "Email address incorrect format",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        );
        return;
      }
    }

    bool isNumeric = RegExp(r'^[0-9]+$').hasMatch(userphone);

    if (userphone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            "Please fill in phone number",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    } else if (!isNumeric) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(
            "Phone number must contain only digits",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    String base64image = "";
    if (kIsWeb) {
      base64image = base64Encode(webImage!);
    } else if (image != null) {
      base64image = base64Encode(image!.readAsBytesSync());
    }

    await http
        .post(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/server/api/update_user_profile.php',
          ),
          body: {
            'userid': widget.user?.userId,
            'name': username,
            'phone': userphone,
            'userpic': base64image,
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
                    resarray['message'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
              prefUpdate(true);
              isAble = false;
              loadPreferences();
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    resarray['message'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Registration failed. CODE: ${response.statusCode}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  'Request failed. Please try again later',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
  }
}
