import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';
import 'package:flutter_application_7/models/service_provider.dart';

import 'serviceavailablecard.dart';

class ServiceBrowser extends StatefulWidget {
  const ServiceBrowser(
      {super.key,
      required this.providers,
      required this.onProviderSelected,
      this.onRefresh});

  final List<ServiceProvider> providers;
  final ValueChanged<ServiceProvider> onProviderSelected;
  final Future<void> Function()? onRefresh;

  @override
  State<ServiceBrowser> createState() => _ServiceBrowserState();
}

class _ServiceBrowserState extends State<ServiceBrowser> {
  final _searchController = TextEditingController();
  String? _selectedSkill;

  List<String> _skills(ServiceProvider provider) => provider.providerSkills
      .split(RegExp(r'[,;|]'))
      .map((skill) => skill.trim())
      .where((skill) => skill.isNotEmpty)
      .toList();

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedSkill = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final skillLabels = <String, String>{};
    for (final skill in widget.providers.expand(_skills)) {
      skillLabels.putIfAbsent(skill.toLowerCase(), () => skill);
    }
    final skills = skillLabels.keys.toList()..sort();
    final filtered = widget.providers.where((provider) {
      final matchesQuery = [
        provider.providerName,
        provider.providerSkills,
        provider.providerLocation
      ].any((value) => value.toLowerCase().contains(query));
      return matchesQuery &&
          (_selectedSkill == null ||
              _skills(provider)
                  .any((skill) => skill.toLowerCase() == _selectedSkill));
    }).toList();
    final hasFilters = query.isNotEmpty || _selectedSkill != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        final content = CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: _ContentWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(26)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.home_repair_service_outlined,
                                size: 32),
                            const SizedBox(height: 22),
                            Text('A helping hand\nfor your home.',
                                style: context.theme.textTheme.headlineMedium),
                            const SizedBox(height: 12),
                            const Text(
                                'Explore local providers and find the right skills for the job.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          labelText: 'Search services',
                          hintText: 'Skills, names, or locations',
                          fillColor: AppColors.surface,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () =>
                                      setState(() => _searchController.clear()),
                                ),
                        ),
                      ),
                      if (skills.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text('BROWSE BY SKILL',
                            style: context.theme.textTheme.labelSmall
                                ?.copyWith(color: AppColors.muted)),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                    label: const Text('All services'),
                                    selected: _selectedSkill == null,
                                    onSelected: (_) =>
                                        setState(() => _selectedSkill = null)),
                              ),
                              for (final skill in skills)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label:
                                        Text(skillLabels[skill]!.capitalize()),
                                    selected: _selectedSkill == skill,
                                    onSelected: (selected) => setState(() =>
                                        _selectedSkill =
                                            selected ? skill : null),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                              '${filtered.length} ${filtered.length == 1 ? 'provider' : 'providers'}${hasFilters ? ' found' : ' to explore'}',
                              style: context.theme.textTheme.titleMedium),
                          if (hasFilters)
                            TextButton(
                                onPressed: _clearFilters,
                                child: const Text('Reset filters')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverToBoxAdapter(
                child: _ContentWidth(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          children: [
                            Icon(
                                hasFilters
                                    ? Icons.search_off_rounded
                                    : Icons.handyman_outlined,
                                size: 36,
                                color: AppColors.muted),
                            const SizedBox(height: 18),
                            Text(
                                hasFilters
                                    ? 'No matches just yet'
                                    : 'No providers yet',
                                textAlign: TextAlign.center,
                                style: context.theme.textTheme.titleLarge),
                            const SizedBox(height: 10),
                            Text(
                                hasFilters
                                    ? 'Try a different skill, name, or location, or clear your filters to see everyone.'
                                    : 'Service providers will appear here when they are available. Pull down to refresh.',
                                textAlign: TextAlign.center),
                            if (hasFilters) ...[
                              const SizedBox(height: 18),
                              OutlinedButton(
                                  onPressed: _clearFilters,
                                  child: const Text('Clear filters'))
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList.builder(
                  itemCount: (filtered.length / columns).ceil(),
                  itemBuilder: (context, row) => _ContentWidth(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var column = 0;
                                column < columns;
                                column++) ...[
                              if (column > 0) const SizedBox(width: 16),
                              Expanded(
                                  child:
                                      row * columns + column < filtered.length
                                          ? _providerCard(
                                              filtered[row * columns + column])
                                          : const SizedBox.shrink()),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
        return widget.onRefresh == null
            ? content
            : RefreshIndicator(onRefresh: widget.onRefresh!, child: content);
      },
    );
  }

  Widget _providerCard(ServiceProvider provider) {
    final words = provider.providerName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    final initials =
        words.take(2).map((word) => word.characters.first.toUpperCase()).join();
    return ServiceAvailableCard(
      key: ValueKey(provider.id),
      leading: initials.isEmpty ? '?' : initials,
      title: provider.providerName,
      subtitle: provider.providerSkills,
      location: provider.providerLocation,
      onPressed: () => widget.onProviderSelected(provider),
    );
  }
}

class _ContentWidth extends StatelessWidget {
  const _ContentWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040), child: child));
}
