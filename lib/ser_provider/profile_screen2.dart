import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    if (!mounted) return;
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
      initialUsername =
          providerPrefs.getString('providername') ?? 'no username';
      initialEmail = providerPrefs.getString('provideremail') ?? 'no email';
      initialPhone = providerPrefs.getString('providerphoneno') ?? 'no phone';
      initialAddress =
          providerPrefs.getString('providerlocation') ?? 'no location';
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

    final url = ApiConfig.endpoint(ip, 'updateprovider.php');

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
      if (!mounted) return;

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];
      debugPrint('Provider profile update: $jsonString');

      if (jsonString == 'success') {
        // Save updated details in SharedPreferences
        await providerPrefs.setString('providername', usernameController.text);
        if (!mounted) return;
        await providerPrefs.setString('provideremail', emailController.text);
        if (!mounted) return;
        await providerPrefs.setString('providerphoneno', phoneController.text);
        if (!mounted) return;
        await providerPrefs.setString(
            'providerlocation', locationController.text);
        if (!mounted) return;
        await providerPrefs.setString('providerskills', skillsController.text);
        if (!mounted) return;

        context.navigator.pop();
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Updated Successfully')));
      } else {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Updation Failed')));
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('Provider profile update failed: $e');
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
    return AppFormPage(
      title: 'Provider Profile',
      heading: 'Put your best self forward.',
      description: 'Keep your contact details, location, and skills current.',
      icon: Icons.badge_outlined,
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
          validator: FormValidators.required('Please enter your skills'),
          controller: skillsController,
          decoration: const InputDecoration(labelText: 'Your skills'),
        ),
        const SizedBox(height: 13),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('Please enter your address'),
          controller: locationController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: 'Service location'),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (_updateKey.currentState!.validate()) {
              if (hasChanges()) {
                updateProvider();
              } else {
                context.scaffoldMessenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('No changes made')),
                  );
              }
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
