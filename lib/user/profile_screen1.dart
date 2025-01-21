import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen1 extends StatefulWidget {
  const ProfileScreen1({super.key});

  @override
  State<ProfileScreen1> createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  final _updateKey = GlobalKey<FormState>();
  SharedPreferences? userPrefs;

  String ip = '';
  String id = '';
  bool isLoading = false;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  late String initialUsername;
  late String initialEmail;
  late String initialPhone;
  late String initialAddress;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    userDetails();
    loadIP();
  }

  Future<void> loadIP() async {
    userPrefs = await SharedPreferences.getInstance();
    setState(() {
      ip = userPrefs?.getString('ip') ?? 'No IP Address';
    });
  }

  void _initializeControllers() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  Future<void> userDetails() async {
    setState(() {
      isLoading = true;
    });

    userPrefs = await SharedPreferences.getInstance();

    setState(() {
      id = userPrefs?.getString('userid') ?? 'no id';
      initialUsername = userPrefs?.getString('username') ?? 'no user name';
      initialEmail = userPrefs?.getString('useremail') ?? 'no user email';
      initialPhone = userPrefs?.getString('userphone') ?? 'no user phone';
      initialAddress = userPrefs?.getString('useraddress') ?? 'no user address';

      usernameController.text = initialUsername;
      emailController.text = initialEmail;
      phoneController.text = initialPhone;
      addressController.text = initialAddress;
      isLoading = false;
    });
  }

  Future<void> updateUser() async {
    setState(() {
      isLoading = true;
    });

    String url = 'http://$ip/homecare_app/updateuser.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': id,
          'username': usernameController.text,
          'email': emailController.text,
          'phone_no': phoneController.text,
          'address': addressController.text,
        },
      );

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        await userPrefs?.setString('username', usernameController.text);
        await userPrefs?.setString('useremail', emailController.text);
        await userPrefs?.setString('userphone', phoneController.text);
        await userPrefs?.setString('useraddress', addressController.text);

        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Updated')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Updation Failed')));
      }
    } catch (e) {
      print('updation error: $e');
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
    addressController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return usernameController.text != initialUsername ||
        emailController.text != initialEmail ||
        phoneController.text != initialPhone ||
        addressController.text != initialAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
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
                      decoration: const InputDecoration(
                          labelText: 'Enter your E-Mail'),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'Please enter your name' : null,
                      controller: usernameController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your Name'),
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
                          (value!.isEmpty) ? 'Please enter your address' : null,
                      controller: addressController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your Address'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_updateKey.currentState!.validate()) {
                          if (hasChanges()) {
                            updateUser();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No changes made')));
                          }
                        }
                      },
                      child: const Text('Update'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
