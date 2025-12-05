import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SubmitPetScreen extends StatefulWidget {
  const SubmitPetScreen({super.key});

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

  TextEditingController longtitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  late Position position;
  late double screenWidht, screenHeight;
  List<Uint8List?> webImage = [null,null,null];
  List<File?> image = [null,null,null];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determineLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Pet'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
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
                        if (value == 'Select Pet Type') {
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
                          selectedPetType = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == 'Select Category') {
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
                        petName = value;
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
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (kIsWeb) {
                             openGallery();
                            } else {
                              pickimagedialog(0);
                            }
                          },
                          child: Container(
                            width: 130,
                            height: 130,
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
                                  : null // If no image, show the default icon
                            ),
                        
                            // If didn't select the image, show camera icon
                            child: (image[0] == null && webImage[0] == null) 
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
  
  void openGallery() {}
  
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
                  openGallery();
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
    if (kIsWeb) return; // skip cropping on web
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
      setState(() {});
    }
  }
}
