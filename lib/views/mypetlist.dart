import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/views/editpetlist.dart';
import 'package:pawpal/views/petdetailpage.dart';
import 'package:pawpal/views/submitpetscreen.dart';

class MyPetList extends StatefulWidget {
  final User? user;
  const MyPetList({super.key, required this.user});

  @override
  State<MyPetList> createState() => _MyPetListState();
}

class _MyPetListState extends State<MyPetList> {
  List<MyPet> petList = [];
  String status = 'Loading...';
  late double screenWidth, screenHeight;
  String selectedCategory = "All";
  String selectedType = "All";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData('');
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
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'My Pet List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Container(
                height: 55,
                width: screenWidth * 0.85,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      27,
                      27,
                      27,
                    ).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search By Pet Name",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 46, 46, 46),
                              fontSize: 17,
                            ),
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 20, 20, 20),
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 82, 81, 81),
                      ),
                      onPressed: () {
                        if (searchController.text.trim() == "" ||
                            searchController.text.trim().isEmpty) {
                          loadData('');
                        } else {
                          loadData(searchController.text.trim());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  // Reset button
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedCategory = "All";
                        selectedType = "All";
                        searchController.clear();
                      });
                      loadData('');
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: Color(0xFF1976D2),
                    ),
                    label: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets
                          .zero, // Remove default internal padding to align the button precisely to the edge
                      minimumSize: const Size(50, 30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ["All", "Adoption", "Donation"].map((
                          category,
                        ) {
                          // Identify Selected Category
                          bool isSelected = selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 7,
                            ), // Button Distance
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                                loadData(searchController.text.trim());
                              },
                              child: Container(
                                width: 85,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  // Selected Button = Button Color Blue, Else = White
                                  color: isSelected
                                      ? const Color(0xFF1976D2)
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  category,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    // Selected Text = Text Color White, Else = Grey
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true, // Dropdown fill the container
                        value: selectedType,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF1976D2),
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        items: <String>['All', 'Dog', 'Cat', 'Rabbit', 'Other']
                            .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                          loadData(searchController.text.trim());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    petList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.find_in_page_outlined, size: 64),
                                  SizedBox(height: 12),
                                  Text(
                                    status,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: petList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Color categoryColor = getCategoryColor(
                                  petList[index].category.toString(),
                                );
                                return GestureDetector(
                                  onTap: () async {
                                    List<int> totalPicture = [
                                      1,
                                    ]; //Must At Least 1 Picture
                                    // Check User Have Upload 2/3 Picture
                                    for (int i = 2; i <= 3; i++) {
                                      final url = Uri.parse(
                                        '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${petList[index].petId}_$i.png',
                                      );
                                      try {
                                        final response = await http.head(url);
                                        if (response.statusCode == 200) {
                                          totalPicture.add(i);
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Error checking image $i: $e",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PetDetailPage(
                                          myPet: petList[index],
                                          user: widget.user,
                                          validTotalImage: totalPicture,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Pet Image
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: screenWidth * 0.23,
                                                    height: screenWidth * 0.23,
                                                    color: Colors.grey[200],
                                                    child: Image.network(
                                                      '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${petList[index].petId}_1.png',
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 40,
                                                              color:
                                                                  Colors.grey,
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),

                                                // Pet some info
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Pet Name
                                                      Text(
                                                        petList[index].petName
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      // Pet Type
                                                      Text(
                                                        "Type: ${petList[index].petType}",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      // Pet Age
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.cake,
                                                            size: 20,
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(
                                                            "Age: ${petList[index].petAge}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[500],
                                                            ),
                                                          ),

                                                          const Spacer(),

                                                          // Edit Button
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) => EditPetList(
                                                                        user: widget
                                                                            .user,
                                                                        myPet:
                                                                            petList[index],
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.edit_note,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 24,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),

                                                          // Delete Button
                                                          GestureDetector(
                                                            onTap: () =>
                                                                showDeleteDialog(
                                                                  petList[index]
                                                                      .petId,
                                                                ),
                                                            child: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 24,
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

                                          // Category (Right Top)
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              width: 140,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: categoryColor.withValues(
                                                  alpha: 0.7,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                    ),
                                              ),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                petList[index].category
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: const Color.fromRGBO(68, 138, 255, 1)),
      ),
      drawer: MyDrawer(user: widget.user, currentPage: "myPetList"),
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'adoption':
        return const Color.fromARGB(255, 0, 8, 255);
      case 'donate request':
        return const Color.fromARGB(255, 36, 59, 94);
      default:
        return Colors.blueAccent;
    }
  }

  void loadData(String search) {
    setState(() {
      status = "Loading...";
    });
    petList.clear();
    String? userIdArg = widget.user?.userId;
    http
        .get(
          Uri.parse(
            //search logic
            '${MyConfig.baseUrl}/pawpal/server/api/get_my_pets.php?user_id=$userIdArg&viewer_id=${widget.user?.userId}&search=${search.trim()}&category=${selectedCategory.trim()}&type=${selectedType.trim()}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // load data to list
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(MyPet.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else {
              // success but didn't have any data inserted
              setState(() {
                petList.clear();
                status = "No Data Found";
              });
            }
          } else {
            // request failed
            setState(() {
              petList.clear();
              status = "Failed to load services";
            });
          }
        });
  }

  Future<void> showDeleteDialog(String? petId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Delete Pet Record?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure you want to delete this? This action cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          deletePetRecord(petId);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deletePetRecord(String? petid) async {
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/delete_pet.php'),
          body: {'pet_id': petid},
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
              Navigator.pop(context);
              loadData('');
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
