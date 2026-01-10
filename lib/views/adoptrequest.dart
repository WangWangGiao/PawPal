import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/mypet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/views/mainpage.dart';

class AdoptRequest extends StatefulWidget {
  final User? user;
  final MyPet? myPet;
  const AdoptRequest({super.key, required this.user, required this.myPet});

  @override
  State<AdoptRequest> createState() => _AdoptRequestState();
}

class _AdoptRequestState extends State<AdoptRequest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController motivationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Apply to Adopt ${widget.myPet?.petName}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Motivation Message",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildMultilineTextField(
                controller: motivationController,
                hint:"Why do you want to adopt ${widget.myPet?.petName}? Tell us about your home environment.",
                lines: 3,
              ),
              const SizedBox(height: 30),
              Text(
                "Previous Pet Experience",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildMultilineTextField(
                controller: experienceController,
                hint:
                    "Have you raised pets before? Mention any specific breeds or challenges.",
                lines: 3,
              ),
              const SizedBox(height: 50),
              // Submit Adopt Request Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    "Submit Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
  }

  // 輸入框組件
  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String hint,
    required int lines,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        filled: true,
        errorStyle: TextStyle(fontSize: 15),
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "This field is required" : null,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Submit Adoption Request',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 28, 59, 112),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitAdoption();
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
            'Are you sure you want to submit this adoption request?',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    } else {
      return;
    }
  }
  
  void submitAdoption() async {
    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/pet_adopt_request.php'),
          body: {
            'pet_id': widget.myPet?.petId,
            'user_id': widget.user?.userId,
            'motivation': motivationController.text.trim(),
            'previous_exp': experienceController.text.trim(),
            'status': 'Pending',
            'owned_id': widget.myPet?.userId,
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