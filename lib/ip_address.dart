import 'package:flutter/material.dart';
import 'package:flutter_application_7/splash_screen.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _ipController,
                  validator: (value) => (value!.isEmpty) ? 'Invalid data' : null,
                  decoration:
                      const InputDecoration(labelText: 'Enter your IP Address'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _ipAddress = _ipController.text.trim();
                      });
                      SharedPreferences prefObj =
                          await SharedPreferences.getInstance();
                      await prefObj.setString('ip', _ipAddress);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()));
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
