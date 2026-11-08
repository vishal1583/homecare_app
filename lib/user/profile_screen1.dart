import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    if (!mounted) return;
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
    if (!mounted) return;

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

    final url = ApiConfig.endpoint(ip, 'updateuser.php');

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
      if (!mounted) return;

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        await userPrefs?.setString('username', usernameController.text);
        if (!mounted) return;
        await userPrefs?.setString('useremail', emailController.text);
        if (!mounted) return;
        await userPrefs?.setString('userphone', phoneController.text);
        if (!mounted) return;
        await userPrefs?.setString('useraddress', addressController.text);
        if (!mounted) return;

        context.navigator.pop();
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Updated')));
      } else {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Updation Failed')));
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('User profile update failed: $e');
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    return AppFormPage(
      title: 'User Profile',
      heading: 'Your details, up to date.',
      description: 'Manage the contact information used for your bookings.',
      icon: Icons.person_outline_rounded,
      formKey: _updateKey,
      isLoading: isLoading,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          validator: FormValidators.required('Please enter a valid email'),
          controller: emailController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email address'),
        ),
        const SizedBox(height: 13),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('Please enter your name'),
          controller: usernameController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded),
              labelText: 'Full name'),
        ),
        const SizedBox(height: 13),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          validator:
              FormValidators.required('Please enter a valid phone number'),
          controller: phoneController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              labelText: 'Phone number'),
        ),
        const SizedBox(height: 13),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('Please enter your address'),
          controller: addressController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: 'Address'),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (_updateKey.currentState!.validate()) {
              if (hasChanges()) {
                updateUser();
              } else {
                context.scaffoldMessenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('No changes made')));
              }
            }
          },
          child: const Text('Update'),
        )
      ],
    );
  }
}
