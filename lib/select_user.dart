import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

import 'ser_provider/login_screen2.dart';
import 'user/login_screen1.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homecare')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.home_work_outlined,
                            color: Color(0xFFBEE3CD), size: 48),
                        const SizedBox(height: 24),
                        Text('HELP, RIGHT AT HOME',
                            style: context.theme.textTheme.labelSmall
                                ?.copyWith(color: const Color(0xFFBEE3CD))),
                        const SizedBox(height: 12),
                        Text('A little help.\nA better home.',
                            style: context.theme.textTheme.headlineLarge
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 14),
                        const Text(
                            'Connect with local service providers and keep your home running smoothly.',
                            style: TextStyle(
                                color: Color(0xFFD6E7DE),
                                fontSize: 16,
                                height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('How can we help?',
                      style: context.theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Choose how you would like to use Homecare.'),
                  const SizedBox(height: 20),
                  _RoleCard(
                    title: 'General User',
                    description:
                        'Find a service, book a visit, and manage your home.',
                    icon: Icons.chair_outlined,
                    onTap: () => context.navigator.push(MaterialPageRoute(
                        builder: (context) => const LoginScreen1())),
                  ),
                  const SizedBox(height: 14),
                  _RoleCard(
                    title: 'Service Provider',
                    description:
                        'Share your skills, respond to requests, and manage work.',
                    icon: Icons.handyman_outlined,
                    onTap: () => context.navigator.push(MaterialPageRoute(
                        builder: (context) => const LoginScreen2())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard(
      {required this.title,
      required this.description,
      required this.icon,
      required this.onTap});

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: AppColors.primarySoft, child: Icon(icon)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(description),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
