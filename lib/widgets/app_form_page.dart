import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

class AppFormPage extends StatelessWidget {
  const AppFormPage({
    super.key,
    required this.title,
    required this.heading,
    required this.description,
    required this.icon,
    required this.formKey,
    required this.children,
    this.isLoading = false,
    this.eyebrow = 'HOMECARE',
  });

  final String title;
  final String heading;
  final String description;
  final IconData icon;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final bool isLoading;
  final String eyebrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(icon, size: 30),
                  ),
                  const SizedBox(height: 24),
                  Text(eyebrow,
                      style: context.theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 10),
                  Text(heading, style: context.theme.textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text(description,
                      style: context.theme.textTheme.bodyLarge
                          ?.copyWith(color: AppColors.muted)),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(child: CircularProgressIndicator()))
                          : Form(
                              key: formKey,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: children),
                            ),
                    ),
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
