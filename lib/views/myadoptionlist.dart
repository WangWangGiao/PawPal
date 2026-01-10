import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/adopt.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';

class MyAdoptionList extends StatefulWidget {
  final User? user;
  const MyAdoptionList({super.key, required this.user});

  @override
  State<MyAdoptionList> createState() => _MyAdoptionListState();
}

class _MyAdoptionListState extends State<MyAdoptionList> {
  List<MyAdoption> adoptionList = [];
  String status = 'Loading...';
  late double screenWidth, screenHeight;
  @override
  void initState() {
    super.initState();
    loadData();
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
        height: 800,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'My Adoption List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: screenWidth,
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'Owner may will delete their pet adoption request \nrecord, your adoption request will also deleted!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    adoptionList.isEmpty
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
                              itemCount: adoptionList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Color categoryColor = getStatusColor(
                                  adoptionList[index].status.toString(),
                                );
                                return Card(
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
                                                    '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${adoptionList[index].petid}_1.png',
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return const Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),

                                              // Pet and owner info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Pet Name
                                                    Text(
                                                      adoptionList[index]
                                                          .petName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    // Owner Name
                                                    Text(
                                                      "Owner: ${adoptionList[index].userName}",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    // Owner Phone
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Contact: ${adoptionList[index].userPhone}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                        // Delete Button
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap:
                                                                () => showDeleteDialog(adoptionList[index].petid),
                                                            child: const Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 24,
                                                            ),
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: categoryColor.withValues(
                                                alpha: 0.7,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                      15,
                                                    ),
                                                  ),
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              adoptionList[index].status
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
      drawer: MyDrawer(user: widget.user, currentPage: "myAdoption"),
    );
  }

  void loadData() {
    setState(() {
      status = "Loading...";
      adoptionList.clear();
    });

    String userId = widget.user?.userId ?? "";

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/server/api/get_my_adoptions.php?user_id=$userId',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true) {
              var data = jsonResponse['data'] as List;
              setState(() {
                adoptionList = data
                    .map((item) => MyAdoption.fromJson(item))
                    .toList();
              });
            } else {
              setState(() {
                status = "No Data Found";
              });
            }
          } else {
            setState(() {
              status = "Server Error: ${response.statusCode}";
            });
          }
        })
        .catchError((error) {
          setState(() {
            status = "Error: $error";
          });
        });
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
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
                  "Delete Adoption Request?",
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
                          deleteAdoptionRequest(petId);
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

  void deleteAdoptionRequest(String? petid) async {
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/delete_adoption_request.php'),
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
              loadData();
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
