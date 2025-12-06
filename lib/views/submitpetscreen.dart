import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainpage.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<String> petType = ['Cat', 'Dog', 'Rabbit', 'Other'];
  List<String> category = ['Adoption', 'Donate Request', 'Help/Rescue'];
  String selectedPetType = 'Cat'; //Default Selection
  String selectedCategory = 'Adoption'; //Default Selection
  String? petName;
  String? locationLongtitude;
  String? description;

  TextEditingController longtitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  late Position position;
  late double screenWidth, screenHeight;
  List<Uint8List?> webImage = [null, null, null];
  List<File?> image = [null, null, null];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool visibleSecondImagePicker = false;
  bool visibleThirdImagePicker = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determineLocation();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Pet'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            height: 800,
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.pets, color: Colors.black),
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
                          hintText: 'Enter Pet Name',
                          labelText: 'Pet Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in pet name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          petName = value;
                        },
                      ),
                      //Drop Down Button for Pet Type (Cat,Dog,Rabbit,Other)
                      DropdownButtonFormField<String>(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.type_specimen, color: Colors.black),
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
                          hintText: 'Select Pet Type',
                          labelText: 'Pet Type',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        items: petType.map((String selectPetType) {
                          return DropdownMenuItem<String>(
                            value: selectPetType,
                            child: Text(selectPetType),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPetType = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select pet type';
                          }
                          return null;
                        },
        
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: const Color.fromARGB(255, 7, 40, 97),
                        ),
                        dropdownColor: const Color.fromARGB(255, 117, 162, 241),
                      ),
                      //Drop Down Button for Category (Adoption, Donation Request, Help/Rescue)
                      DropdownButtonFormField<String>(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.type_specimen, color: Colors.black),
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
                          hintText: 'Select Category',
                          labelText: 'Category',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        items: category.map((String selectCategory) {
                          return DropdownMenuItem<String>(
                            value: selectCategory,
                            child: Text(selectCategory),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: const Color.fromARGB(255, 7, 40, 97),
                        ),
                        dropdownColor: const Color.fromARGB(255, 117, 162, 241),
                      ),
                      //Description (Minimum 10 Charaters)
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintText: 'Select Category',
                          hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 14, 45, 98),
                              width: 3,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 3),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in the description";
                          }
                          if (value.length < 10) {
                            return "Please enter at least 10 character";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          description = value;
                        },
                        maxLines: 3,
                        maxLength: 50,
                      ),
                      //Location (Longitude)
                      TextFormField(
                        controller: longtitudeController,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.public, color: Colors.black),
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
                          hintText: 'Enter Longitude',
                          labelText: 'Longitude',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in longtitude";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          locationLongtitude = value;
                        },
                      ),
                      //Location (Latitude)
                      TextFormField(
                        controller: latitudeController,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.public, color: Colors.black),
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
                          hintText: 'Enter Latitude',
                          labelText: 'Latitude',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          helperText: "",
                          helperStyle: TextStyle(fontSize: 17),
                          errorStyle: TextStyle(fontSize: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in latitude";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          locationLongtitude = value;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //First Image Picker (Using Index to determine/detection)
                          GestureDetector(
                            onTap: () {
                              if (kIsWeb) {
                                //Website
                                openGallery(0);
                              } else {
                                //Mobile
                                pickimagedialog(0);
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                image: (image[0] != null && !kIsWeb)
                                    ? DecorationImage(
                                        image: FileImage(image[0]!),
                                        fit: BoxFit.fill,
                                      )
                                    : (webImage[0] != null)
                                    ? DecorationImage(
                                        image: MemoryImage(webImage[0]!),
                                        fit: BoxFit.fill,
                                      )
                                    : null, // If no image, show the default icon
                              ),
        
                              // If didn't select the image, show camera icon
                              child: (image[0] == null && webImage[0] == null)
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Tap to \nadd image",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          //Second Image Picker
                          Visibility(
                            visible: visibleSecondImagePicker,
                            child: GestureDetector(
                              onTap: () {
                                if (kIsWeb) {
                                  openGallery(1);
                                } else {
                                  pickimagedialog(1);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: (image[1] != null && !kIsWeb)
                                      ? DecorationImage(
                                          image: FileImage(image[1]!),
                                          fit: BoxFit.fill,
                                        )
                                      : (webImage[1] != null)
                                      ? DecorationImage(
                                          image: MemoryImage(webImage[1]!),
                                          fit: BoxFit.fill,
                                        )
                                      : null, // If no image, show the default icon
                                ),
                            
                                // If didn't select the image, show camera icon
                                child: (image[1] == null && webImage[1] == null)
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Tap to \nadd image",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          //Third Image Picker
                          Visibility(
                            visible: visibleThirdImagePicker,
                            child: GestureDetector(
                              onTap: () {
                                if (kIsWeb) {
                                  openGallery(2);
                                } else {
                                  pickimagedialog(2);
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: (image[2] != null && !kIsWeb)
                                      ? DecorationImage(
                                          image: FileImage(image[2]!),
                                          fit: BoxFit.fill,
                                        )
                                      : (webImage[2] != null)
                                      ? DecorationImage(
                                          image: MemoryImage(webImage[2]!),
                                          fit: BoxFit.fill,
                                        )
                                      : null, // If no image, show the default icon
                                ),
                            
                                // If didn't select the image, show camera icon
                                child: (image[2] == null && webImage[2] == null)
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Tap to \nadd image",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 30, 72, 145),
                            ),
                          ),
                          onPressed: validateForm,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
        ),
      ),
    );
  }

  Future<void> determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    position = await Geolocator.getCurrentPosition();
    autoFillLocation();
  }

  void autoFillLocation() {
    longtitudeController.text = position.longitude.toString();
    latitudeController.text = position.latitude.toString();
  }

  Future<void> openGallery(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image[index] = File(pickedFile.path);
        cropImage(index); // only for mobile
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
        webImage[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image[index] = File(pickedFile.path);
        cropImage(index);
      }
    }
  }

  Future<void> cropImage(int index) async {
    if (kIsWeb) {
      if(index == 0){
        setState(() {
          visibleSecondImagePicker = true;
        });
      }
      if(index == 1){
        setState(() {
          visibleThirdImagePicker = true;
        });
      }
      return;
    } // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image[index]!.path,
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
      image[index] = File(croppedFile.path);
      if(index == 0){
          visibleSecondImagePicker = true;
      }
      if(index == 1){
          visibleThirdImagePicker = true;
      }
      setState(() {});
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      //Check Image (At least upload 1 image)
      if (kIsWeb) {
        if (webImage[0] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please upload at least 1 image',
                style: TextStyle(fontSize: 15),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      } else {
        if (image[0] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please upload at least 1 image',
                style: TextStyle(fontSize: 15),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      }

      //Perform textformfield save operation
      formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Submit New Pet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 28, 59, 112),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitPet();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          content: Text(
            'Are you sure you want to submit this submission?',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    } else {
      return;
    }
  }

  void submitPet() async {
    List<String?> base64image = [];
    if (kIsWeb) {
      for (int x = 0; x <= 2; x++) {
        if (webImage[x] == null) {
          continue;
        }
        base64image.add(base64Encode(webImage[x]!));
      }
    } else {
      for (int x = 0; x <= 2; x++) {
        if (image[x] == null) {
          continue;
        }
        base64image.add(base64Encode(image[x]!.readAsBytesSync()));
      }
    }
    print(base64image);
    String latitude = latitudeController.text.trim();
    String longitude = longtitudeController.text.trim();

    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/submit_pet.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_name': petName,
            'pet_type': selectedPetType,
            'category': selectedCategory,
            'description': description,
            'lat': latitude,
            'lng': longitude,
            'image': jsonEncode(base64image),
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(user: widget.user),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}
