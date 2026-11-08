import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.bookingID});

  final String bookingID;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    loadPref();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final agreedAmount = TextEditingController();

  SharedPreferences? prefObj;
  String ip = '';
  String userID = '';

  String? selectedPaymentMethod;
  final List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Cash'
  ];

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
      userID = prefObj?.getString('userid') ?? 'No user ID';
    });
  }

  Future<void> paymentDetails(String bookingID) async {
    final confirmed = await context.confirmAction(
      title: 'Submit payment details?',
      message:
          'Amount: ${agreedAmount.text}\nMethod: $selectedPaymentMethod\n\nThis will record payment for booking #$bookingID.',
      confirmLabel: 'Record payment',
    );
    if (!confirmed || !mounted) return;

    final url = ApiConfig.endpoint(ip, 'payment.php');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'booking_id': bookingID,
          'agreed_amount': agreedAmount.text,
          'payment_method': selectedPaymentMethod,
          'payment_status': 'success',
        },
      );
      if (!mounted) return;

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Payment Details Uploaded')),
          );
        context.navigator.pop();
        context.navigator.pop();
      } else {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Payment Details Failed')),
          );
      }
    } catch (e) {
      if (!mounted) return;
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('error: $e')),
        );
    }
  }

  @override
  void dispose() {
    agreedAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'Payment',
      heading: 'Finish on a good note.',
      description:
          'Record the amount agreed with your service provider and choose a payment method.',
      icon: Icons.payments_outlined,
      formKey: _formKey,
      children: [
        const Text(
          'Enter Payment Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.payments_outlined),
              labelText: 'Agreed Amount'),
          controller: agreedAmount,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null && value!.isEmpty) {
              return 'Please enter the agreed amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Payment Method'),
          initialValue: selectedPaymentMethod,
          items: paymentMethods.map((method) {
            return DropdownMenuItem(
              value: method,
              child: Text(method),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPaymentMethod = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a payment method';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                paymentDetails(widget.bookingID);
              }
            },
            child: const Text('Submit Payment'),
          ),
        ),
      ],
    );
  }
}
