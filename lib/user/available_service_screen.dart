import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:flutter_application_7/user/provider_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/serviceavailablecard.dart';

class AvailableServiceScreen extends StatefulWidget {
  const AvailableServiceScreen({super.key});

  @override
  State<AvailableServiceScreen> createState() => _AvailableServiceScreenState();
}

class _AvailableServiceScreenState extends State<AvailableServiceScreen> {
  SharedPreferences? _prefObj;
  String _ip = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  Future<void> _loadIP() async {
    try {
      _prefObj = await SharedPreferences.getInstance();
      setState(() {
        _ip = _prefObj?.getString('ip') ?? 'No IP';
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading IP: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<ServiceProvider>> _serviceView() async {
    String url = 'http://$_ip/homecare_app/viewprovider.php';

    try {
      var response = await http.get(Uri.parse(url));
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((services) => ServiceProvider.fromJson(services))
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching services: $e')));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Services'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<ServiceProvider>>(
              future: _serviceView(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No services available'));
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final serviceProvider = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15.0),
                        child: ServiceAvailableCard(
                          leading: '${index+1}',
                          title: serviceProvider.providerName,
                          subtitle: serviceProvider.providerSkills,
                          onPressed: () {
                            print('selected provider id: ${serviceProvider.id}');
                            _prefObj!.setString('providerid', serviceProvider.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderDetailsScreen(
                                  providerName: serviceProvider.providerName,
                                  providerEmail: serviceProvider.providerEmail,
                                  providerPhoneNo: serviceProvider.providerPhoneno,
                                  providerLocation: serviceProvider.providerLocation,
                                  providerSkills: serviceProvider.providerSkills,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
