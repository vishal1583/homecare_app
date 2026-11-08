import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout(
      {super.key,
      required this.welcomeText,
      required this.role,
      required this.cards});

  final String welcomeText;
  final String role;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final isProvider = role == 'Service Provider';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 14.0;
                final columns = constraints.maxWidth < 320
                    ? 1
                    : constraints.maxWidth > 850
                        ? 3
                        : 2;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(28)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                                color: const Color(0xFF285649),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(role,
                                style: context.theme.textTheme.labelSmall
                                    ?.copyWith(color: const Color(0xFFD6E7DE))),
                          ),
                          const SizedBox(height: 24),
                          Text(welcomeText,
                              style: const TextStyle(
                                  color: Color(0xFFBEE3CD),
                                  fontSize: 14,
                                  height: 1.5)),
                          const SizedBox(height: 8),
                          Text(
                              isProvider
                                  ? 'Your work, organized.'
                                  : 'Home, handled.',
                              style: context.theme.textTheme.headlineLarge
                                  ?.copyWith(color: Colors.white)),
                          const SizedBox(height: 12),
                          Text(
                              isProvider
                                  ? 'From new requests to a job well done. Everything you need, in one place.'
                                  : 'Find the right help and make a little more room for what matters.',
                              style: const TextStyle(
                                  color: Color(0xFFD6E7DE),
                                  fontSize: 15,
                                  height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                        isProvider
                            ? 'Your workspace'
                            : 'What can we take care of?',
                        style: context.theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(isProvider
                        ? 'Manage your services, one step at a time.'
                        : 'A few simple ways to make home life easier.'),
                    const SizedBox(height: 20),
                    for (var row = 0; row < cards.length; row += columns)
                      Padding(
                        padding: const EdgeInsets.only(bottom: spacing),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var column = 0;
                                  column < columns;
                                  column++) ...[
                                if (column > 0) const SizedBox(width: spacing),
                                Expanded(
                                    child: row + column < cards.length
                                        ? cards[row + column]
                                        : const SizedBox.shrink()),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
