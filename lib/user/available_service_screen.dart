import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/user/provider_details_screen.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/widgets/service_browser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AvailableServiceScreen extends StatefulWidget {
  const AvailableServiceScreen({super.key});

  @override
  State<AvailableServiceScreen> createState() => _AvailableServiceScreenState();
}

class _AvailableServiceScreenState extends State<AvailableServiceScreen> {
  SharedPreferences? _prefObj;
  String _ip = '';
  bool isLoading = true;
  List<ServiceProvider> _providers = [];
  bool _hasLoaded = false;
  bool _hasError = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  Future<void> _loadIP() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!mounted) return;
      _prefObj = preferences;
      _ip = preferences.getString('ip') ?? 'No IP';
      await _refreshProviders();
    } catch (error) {
      debugPrint('Unable to load service preferences: $error');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<List<ServiceProvider>> _serviceView() async {
    final url = ApiConfig.endpoint(_ip, 'viewprovider.php');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Unable to load services (${response.statusCode})');
    }
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((services) => ServiceProvider.fromJson(services)).toList();
  }

  Future<void> _refreshProviders() async {
    if (_isRefreshing) return;
    if (_prefObj == null) {
      setState(() => isLoading = true);
      await _loadIP();
      return;
    }
    setState(() => _isRefreshing = true);
    try {
      final providers = await _serviceView();
      if (!mounted) return;
      setState(() {
        _providers = providers;
        _hasLoaded = true;
        _hasError = false;
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Unable to load services: $error');
      if (!mounted) return;
      if (_hasLoaded) {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Could not refresh services. Please try again.')));
      } else {
        setState(() {
          _hasError = true;
          isLoading = false;
        });
      }
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  void _openProvider(ServiceProvider provider) {
    debugPrint('Selected provider: ${provider.id}');
    _prefObj!.setString('providerid', provider.id);
    context.navigator.push(MaterialPageRoute(
      builder: (context) => ProviderDetailsScreen(
        providerName: provider.providerName,
        providerEmail: provider.providerEmail,
        providerPhoneNo: provider.providerPhoneno,
        providerLocation: provider.providerLocation,
        providerSkills: provider.providerSkills,
      ),
    ));
  }

  Widget _errorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(Icons.wifi_off_outlined, size: 30)),
              const SizedBox(height: 22),
              Text('Let us try that again.',
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              const Text(
                  'We could not load the service providers. Check your connection and try again.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: _refreshProviders, child: const Text('Try again')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Service'),
        actions: [
          IconButton(
              tooltip: 'Refresh services',
              onPressed: isLoading || _isRefreshing ? null : _refreshProviders,
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
                ? _errorState()
                : ServiceBrowser(
                    providers: _providers,
                    onProviderSelected: _openProvider,
                    onRefresh: _refreshProviders,
                  ),
      ),
    );
  }
}
