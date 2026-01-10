import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/loginpage.dart';
import 'package:pawpal/views/mainpage.dart';
import 'package:pawpal/views/myadoptionlist.dart';
import 'package:pawpal/views/mydonationlist.dart';
import 'package:pawpal/views/mypetlist.dart';
import 'package:pawpal/views/payment.dart';
import 'package:pawpal/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  final String currentPage;
  const MyDrawer({super.key, required this.user, required this.currentPage});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenwidth;
  String? userEmail;
  String? userName;
  String? userCredit;
  String? userPassword;

  @override
  void initState() {
    super.initState();
    userCredit = widget.user?.userCredit ?? "0.00";
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70, bottom: 20),
            width: screenwidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 25, 118, 210),
                  Color(0xFF42A5F5),
                ], //Gradient Colour
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color.fromARGB(
                          255,
                          15,
                          68,
                          111,
                        ).withValues(alpha: 0.3),
                        //Load avatar or Replace with username first character
                        backgroundImage:
                            (widget.user?.userAvatar != null &&
                                widget.user!.userAvatar!.isNotEmpty)
                            ? NetworkImage(
                                '${MyConfig.baseUrl}/pawpal/server/uploads/user_profile/userAvatar_${widget.user!.userId}.png',
                              )
                            : null,
                        child:
                            (widget.user?.userAvatar != null &&
                                widget.user!.userAvatar!.isNotEmpty)
                            ? null
                            : Text(
                                widget.user?.userName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    "G",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? widget.user!.userName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              userEmail ?? widget.user!.userEmail.toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Credits Display Container
                GestureDetector(
                  onTap: showBuyCreditDialog,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "My Credits",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "RM $userCredit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // HOME
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: widget.currentPage == 'home'
                        ? Colors.white
                        : Color.fromARGB(255, 25, 118, 210),
                  ),
                  title: Text(
                    'HOME',
                    style: TextStyle(
                      color: widget.currentPage == 'home'
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: widget.currentPage == 'home'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: widget.currentPage == 'home'
                      ? Color.fromARGB(255, 25, 118, 210)
                      : null,
                  onTap: () {
                    if (widget.currentPage == 'home') {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      AnimatedRoute.slideFromRight(HomePage(user: widget.user)),
                    );
                  },
                ),

                // MY PET LIST
                ListTile(
                  leading: Icon(
                    Icons.pets,
                    color: widget.currentPage == 'myPetList'
                        ? Colors.white
                        : Color.fromARGB(255, 25, 118, 210),
                  ),
                  title: Text(
                    'MY PET LIST',
                    style: TextStyle(
                      color: widget.currentPage == 'myPetList'
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: widget.currentPage == 'myPetList'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: widget.currentPage == 'myPetList'
                      ? Color.fromARGB(255, 25, 118, 210)
                      : null,
                  onTap: () {
                    if (widget.currentPage == 'myPetList') {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      AnimatedRoute.slideFromRight(
                        MyPetList(user: widget.user),
                      ),
                    );
                  },
                ),

                // MY ADOPTION
                ListTile(
                  leading: Icon(
                    Icons.volunteer_activism,
                    color: widget.currentPage == 'myAdoption'
                        ? Colors.white
                        : Color.fromARGB(255, 25, 118, 210),
                  ),
                  title: Text(
                    'MY ADOPTION',
                    style: TextStyle(
                      color: widget.currentPage == 'myAdoption'
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: widget.currentPage == 'myAdoption'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: widget.currentPage == 'myAdoption'
                      ? Color.fromARGB(255, 25, 118, 210)
                      : null,
                  onTap: () {
                    if (widget.currentPage == 'myAdoption') {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      AnimatedRoute.slideFromRight(
                        MyAdoptionList(user: widget.user),
                      ),
                    );
                  },
                ),

                // MY DONATION
                ListTile(
                  leading: Icon(
                    Icons.card_giftcard,
                    color: widget.currentPage == 'myDonation'
                        ? Colors.white
                        : Color.fromARGB(255, 25, 118, 210),
                  ),
                  title: Text(
                    'MY DONATION ',
                    style: TextStyle(
                      color: widget.currentPage == 'myDonation'
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: widget.currentPage == 'myDonation'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: widget.currentPage == 'myDonation'
                      ? Color.fromARGB(255, 25, 118, 210)
                      : null,
                  onTap: () {
                    if (widget.currentPage == 'myDonation') {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      AnimatedRoute.slideFromRight(
                        MyDonationList(user: widget.user),
                      ),
                    );
                  },
                ),

                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // PROFILE
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: widget.currentPage == 'profile'
                        ? Colors.white
                        : Color.fromARGB(255, 25, 118, 210),
                  ),
                  title: Text(
                    'PROFILE ',
                    style: TextStyle(
                      color: widget.currentPage == 'profile'
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: widget.currentPage == 'profile'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  tileColor: widget.currentPage == 'profile'
                      ? Color.fromARGB(255, 25, 118, 210)
                      : null,
                  onTap: () {
                    if (widget.currentPage == 'profile') {
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      AnimatedRoute.slideFromRight(Profile(user: widget.user)),
                    );
                  },
                ),
              ],
            ),
          ),

          // Make Logout outside ListView to place it at bottom drawer
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'LOGOUT',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Logout Successful',
                    style: TextStyle(fontSize: 15),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }

  //Remove all prefs once log out
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('phone');
    prefs.remove('credit');
    prefs.remove('userAvatar');
    prefs.remove('rememberMe');

    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString('email');
    userName = prefs.getString('name');
    userPassword = prefs.getString('password');
    setState(() {});
  }

  void prefUpdateCredit(String? credit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('credit', credit ?? "");
    loadPreferences();
  }

  void showBuyCreditDialog() {
    final TextEditingController amountController = TextEditingController();
    Color mainBlue = Color.fromARGB(255, 31, 60, 136);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mainBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: mainBlue,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Top Up Credits",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainBlue,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter amount (Max RM 1000)\n If more than RM 1000 --> RM 1000",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    //Filter user input (only 4 digit and cannot start with 0)
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(r'^0')),
                      LengthLimitingTextInputFormatter(4),
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainBlue,
                    ),
                    decoration: InputDecoration(
                      prefixText: "RM ",
                      prefixStyle: TextStyle(
                        color: mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: mainBlue, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 1),
                      //RM10 QUICK INSERT
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: mainBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setDialogState(() {
                            amountController.text = "10";
                          });
                        },
                        child: const Text(
                          "RM 10",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 1),
                      //RM50 QUICK INSERT
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: mainBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setDialogState(() {
                            amountController.text = "50";
                          });
                        },
                        child: const Text(
                          "RM 50",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 1),
                      //RM100 QUICK INSERT
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: mainBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setDialogState(() {
                            amountController.text = "100";
                          });
                        },
                        child: const Text(
                          "RM 100",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          int amount = int.tryParse(amountController.text) ?? 0;
                          Navigator.pop(context);
                          if (widget.user != null) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentPage(
                                  user: widget.user!,
                                  credits: amount,
                                ),
                              ),
                            );
                            await fetchLatestUserData();
                          }
                        },
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Reload user data
  Future<void> fetchLatestUserData() async {
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/login_user.php'),
          body: {'email': userEmail, 'password': userPassword},
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              if (!mounted) return;
              User updatedUser = User.fromJson(resarray['data'][0]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  content: Text(
                    resarray['message'],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
              setState(() {
                userCredit = updatedUser.userCredit;
                widget.user!.userCredit = updatedUser.userCredit;
                prefUpdateCredit(updatedUser.userCredit);
              });
            }
          }
        });
  }
}
