import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen2 extends StatefulWidget {
  const ProfileScreen2({super.key});

  @override
  State<ProfileScreen2> createState() => _ProfileScreen2State();
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  final _updateKey = GlobalKey<FormState>();
  late SharedPreferences providerPrefs;

  String ip = '';
  String providerId = '';
  bool isLoading = false;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController skillsController;

  late String initialUsername;
  late String initialEmail;
  late String initialPhone;
  late String initialAddress;
  late String initialSkills;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    initializeSharedPreferences();
  }

  void _initializeControllers() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    skillsController = TextEditingController();
  }

  Future<void> initializeSharedPreferences() async {
    setState(() {
      isLoading = true;
    });
    providerPrefs = await SharedPreferences.getInstance();
    loadIP();
    loadProviderDetails();
  }

  // Load IP address
  Future<void> loadIP() async {
    setState(() {
      ip = providerPrefs.getString('ip') ?? 'No IP Address';
    });
  }

  // Load provider details
  Future<void> loadProviderDetails() async {
    setState(() {
      providerId = providerPrefs.getString('providerid') ?? 'no id';
      initialUsername = providerPrefs.getString('providername') ?? 'no username';
      initialEmail = providerPrefs.getString('provideremail') ?? 'no email';
      initialPhone = providerPrefs.getString('providerphoneno') ?? 'no phone';
      initialAddress = providerPrefs.getString('providerlocation') ?? 'no location';
      initialSkills = providerPrefs.getString('providerskills') ?? 'no skills';

      usernameController.text = initialUsername;
      emailController.text = initialEmail;
      phoneController.text = initialPhone;
      locationController.text = initialAddress;
      skillsController.text = initialSkills;
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateProvider() async {
    setState(() {
      isLoading = true;
    });

    String url = 'http://$ip/homecare_app/updateprovider.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': providerId,
          'username': usernameController.text,
          'email': emailController.text,
          'phone_no': phoneController.text,
          'location': locationController.text,
          'skills': skillsController.text,
        },
      );

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];
      print(jsonString);

      if (jsonString == 'success') {
        // Save updated details in SharedPreferences
        await providerPrefs.setString('providername', usernameController.text);
        await providerPrefs.setString('provideremail', emailController.text);
        await providerPrefs.setString('providerphoneno', phoneController.text);
        await providerPrefs.setString('providerlocation', locationController.text);
        await providerPrefs.setString('providerskills', skillsController.text);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updated Successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updation Failed')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return usernameController.text != initialUsername ||
        emailController.text != initialEmail ||
        phoneController.text != initialPhone ||
        locationController.text != initialAddress ||
        skillsController.text != initialSkills;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _updateKey,
                child: Column(
                  children: [
                    const SizedBox(height: 45),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'Please enter a valid email' : null,
                      controller: emailController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your E-Mail'),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'Please enter your name' : null,
                      controller: usernameController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Name'),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      validator: (value) => (value!.isEmpty)
                          ? 'Please enter a valid phone number'
                          : null,
                      controller: phoneController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your Phone number'),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'Please enter your skills' : null,
                      controller: skillsController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Skills'),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'Please enter your address' : null,
                      controller: locationController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your Address'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_updateKey.currentState!.validate()) {
                          if (hasChanges()) {
                            updateProvider();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No changes made')),
                            );
                          }
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
