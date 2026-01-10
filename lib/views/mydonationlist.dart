import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/donate.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/mydrawer.dart';

class MyDonationList extends StatefulWidget {
  final User? user;
  const MyDonationList({super.key, required this.user});

  @override
  State<MyDonationList> createState() => _MyDonationListState();
}

class _MyDonationListState extends State<MyDonationList> {
  List<MyDonation> donationList = [];
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
                'My Donation List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    donationList.isEmpty
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
                              itemCount: donationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Color categoryColor = getDonateTypeColor(
                                  donationList[index].donationtype.toString(),
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
                                                    '${MyConfig.baseUrl}/pawpal/server/uploads/pet/pets_${donationList[index].petid}_1.png',
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

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Pet name
                                                    Text(
                                                      donationList[index]
                                                          .petname
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    if (donationList[index]
                                                            .donationtype ==
                                                        'Money') ...[
                                                      Text(
                                                        "Donate Amount: ${donationList[index].amount}",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ] else if (donationList[index]
                                                                .donationtype ==
                                                            'Food' ||
                                                        donationList[index]
                                                                .donationtype ==
                                                            'Medical') ...[
                                                      Text(
                                                        "Item Donate: ${donationList[index].description}",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                    const SizedBox(height: 4),
                                                    // Donate Date
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Donate Date: ${donationList[index].donatedate}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors
                                                                  .grey[500],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                      
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
                                              donationList[index].donationtype
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
      drawer: MyDrawer(user: widget.user, currentPage: "myDonation"),
    );
  }

  void loadData() {
    setState(() {
      status = "Loading...";
      donationList.clear();
    });

    String userId = widget.user?.userId ?? "";

    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/server/api/get_my_donations.php?user_id=$userId',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true) {
              var data = jsonResponse['data'] as List;
              setState(() {
                donationList = data
                    .map((item) => MyDonation.fromJson(item))
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

  Color getDonateTypeColor(String? donateType) {
    switch (donateType?.toLowerCase()) {
      case 'money':
        return Colors.green;
      default:
        return Colors.blueAccent;
    }
  }
}
