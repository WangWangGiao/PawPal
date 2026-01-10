import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/adoptrequest.dart';
import 'package:pawpal/views/donate.dart';

class PetDetailPage extends StatefulWidget {
  final MyPet? myPet;
  final User? user;
  final List<int> validTotalImage;
  const PetDetailPage({
    super.key,
    required this.myPet,
    required this.user,
    required this.validTotalImage,
  });

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  late String? buttonText;
  late double screenHeight, screenWidth;
  int selectedImageIndex = 1;
  bool isVisible = false;
  late List<int> validTotalImage;
  @override
  void initState() {
    super.initState();
    validTotalImage = widget.validTotalImage;
    loadButtonText();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // First Upload Picture Display on Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(
              '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${widget.myPet?.petId}_$selectedImageIndex.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.pets, size: 50),
              ),
            ),
          ),

          //Put the info on picture
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.35),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pet Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${widget.myPet?.petName}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Category
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: getCategoryColor(
                                  widget.myPet?.category,
                                ).withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${widget.myPet?.category}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Age and Type Display
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoTile(
                                Icons.cake,
                                "${widget.myPet?.petAge} Years",
                                "Age",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoTile(
                                Icons.pets,
                                "${widget.myPet?.petType}",
                                "Type",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoTile(
                                Icons.male,
                                "${widget.myPet?.petGender}",
                                "Gender",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 13),
                        const Text(
                          "Health Condition",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.myPet?.petHealth}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        if (validTotalImage.length > 1) ...[
                          const Text(
                            "More Photos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: validTotalImage.length,
                              itemBuilder: (context, index) {
                                int imageIndex = index + 1;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = imageIndex;
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: selectedImageIndex == imageIndex
                                            ? Colors.blueAccent
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${widget.myPet?.petId}_$imageIndex.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 3),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.myPet?.description}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.explore, color: Colors.blueAccent),
                            SizedBox(width: 5),
                            Text(
                              'Latitude: ${widget.myPet?.lat}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.public, color: Colors.blueAccent),
                            SizedBox(width: 5),
                            Text(
                              'Longitude: ${widget.myPet?.lng}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.gps_fixed, color: Colors.blueAccent),
                            SizedBox(width: 5),
                            Text(
                              'Google Map: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: copyGoogleMapLink,
                              child: Text(
                                'Click Here To Copy',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(
                                    255,
                                    84,
                                    134,
                                    222,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Divider(thickness: 2),
                        //Owner Information
                        const Text(
                          "Posted By",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //Username
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blueAccent),
                            const SizedBox(width: 3),
                            Text(
                              "Username: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${widget.myPet?.userName}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        //Owner Phone Number
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.blueAccent),
                            const SizedBox(width: 3),
                            Text(
                              "Phone Number: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${widget.myPet?.userPhone}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        //Owner Email
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.blueAccent),
                            const SizedBox(width: 3),
                            Text(
                              "Email: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "${widget.myPet?.userEmail}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Visibility(
                          visible: isVisible,
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  43,
                                  90,
                                  209,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () {
                                if (widget.myPet?.category?.toLowerCase() ==
                                    "adoption") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdoptRequest(
                                        myPet: widget.myPet,
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                }

                                if (widget.myPet?.category?.toLowerCase() ==
                                    "donate request") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Donate(
                                        myPet: widget.myPet,
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                buttonText ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Previous Page Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleBtn(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black26,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Color getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'adoption':
        return Color.fromARGB(255, 0, 8, 255);
      case 'donate request':
        return Color.fromARGB(255, 36, 59, 94);
      default:
        return Colors.white;
    }
  }

  void copyGoogleMapLink() {
    //Reference https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
    Clipboard.setData(
      ClipboardData(
        text:
            'https://www.google.com/maps/search/?api=1&query=${widget.myPet?.lat},${widget.myPet?.lng}',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Copy successful",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 80, 80, 80),
            ),
          ),
        ],
      ),
    );
  }

  void loadButtonText() {
    if (widget.myPet?.userId != widget.user?.userId) {
      setState(() {
        buttonText = widget.myPet?.category ?? "Contact Owner";
        if (widget.myPet?.category == "Adoption" ||
            widget.myPet?.category == "Donate Request") {
          isVisible = true;
        } else {
          isVisible = false;
        }
      });
    } else {
      buttonText = "";
    }
  }
}
