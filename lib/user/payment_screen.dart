import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_application_7/user/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  final List<String> paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'Cash'];

  Future<void> loadPref()async
  {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
      userID = prefObj?.getString('userid') ?? 'No user ID';
    });
  }

  Future<void> paymentDetails(String bookingID)async
  {
    String url = 'http://$ip/homecare_app/payment.php';

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

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Details Uploaded')),
        );
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => FeedbackScreen(bookingID: bookingID,userID: userID,)),
        // );
        Navigator.pop(context);
        Navigator.pop(context);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Details Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error: $e')),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                decoration: const InputDecoration(labelText: 'Agreed Amount'),
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
                decoration: const InputDecoration(labelText: 'Payment Method'),
                value: selectedPaymentMethod,
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
          ),
        ),
      ),
    );
  }
}
