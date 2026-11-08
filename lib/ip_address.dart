import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/splash_screen.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpAddressScreen extends StatefulWidget {
  const IpAddressScreen({super.key});

  @override
  State<IpAddressScreen> createState() => _IpAddressScreenState();
}

class _IpAddressScreenState extends State<IpAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ipController = TextEditingController();
  String _ipAddress = '';

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'Welcome to Homecare',
      heading: 'A little help.\nA better home.',
      description: 'Connect to your Homecare server to get started.',
      icon: Icons.home_work_outlined,
      formKey: _formKey,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          controller: _ipController,
          validator: FormValidators.required('Invalid data'),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.dns_outlined),
              labelText: 'Enter your IP Address'),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _ipAddress = _ipController.text.trim();
              });
              SharedPreferences prefObj = await SharedPreferences.getInstance();
              await prefObj.setString('ip', _ipAddress);
              if (!context.mounted) return;
              context.navigator.pushReplacement(MaterialPageRoute(
                  builder: (context) => const SplashScreen()));
            }
          },
          child: const Text('Submit'),
        )
      ],
    );
  }
}
