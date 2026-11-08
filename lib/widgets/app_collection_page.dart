import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';

import 'app_empty_state.dart';

class AppCollectionPage<T> extends StatelessWidget {
  const AppCollectionPage(
      {super.key,
      required this.title,
      required this.description,
      required this.future,
      required this.emptyMessage,
      required this.itemBuilder,
      this.icon = Icons.calendar_month_outlined,
      this.onRetry});

  final String title;
  final String description;
  final Future<List<T>> future;
  final String emptyMessage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Column(
                children: [
                  const Expanded(
                      child: AppEmptyState(
                          title: 'Something needs a moment',
                          message:
                              'We could not load this page. Please try again.',
                          icon: Icons.wifi_off_outlined)),
                  if (onRetry != null)
                    Padding(
                        padding: const EdgeInsets.all(24),
                        child: ElevatedButton(
                            onPressed: onRetry,
                            child: const Text('Try again'))),
                ],
              );
            }
            return AppCollectionContent<T>(
                title: title,
                description: description,
                items: snapshot.data ?? [],
                emptyMessage: emptyMessage,
                itemBuilder: itemBuilder,
                icon: icon);
          },
        ),
      ),
    );
  }
}

class AppCollectionContent<T> extends StatelessWidget {
  const AppCollectionContent(
      {super.key,
      required this.title,
      required this.description,
      required this.items,
      required this.emptyMessage,
      required this.itemBuilder,
      this.icon = Icons.calendar_month_outlined});

  final String title;
  final String description;
  final List<T> items;
  final String emptyMessage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: context.theme.textTheme.headlineMedium),
                      const SizedBox(height: 10),
                      Text(description)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (items.isEmpty)
          SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                  title: 'All clear for now',
                  message: emptyMessage,
                  icon: icon))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: itemBuilder(context, items[index], index)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
