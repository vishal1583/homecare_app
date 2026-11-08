import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';
import 'package:flutter_application_7/models/bookings.dart';

class BookingCard extends StatelessWidget {
  const BookingCard(
      {super.key,
      required this.booking,
      required this.name,
      this.actions = const []});

  final Bookings booking;
  final String name;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('BOOKING #${booking.id}',
                    style: context.theme.textTheme.labelSmall
                        ?.copyWith(color: AppColors.muted)),
                BookingStatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 18),
            Text(name.capitalize(), style: context.theme.textTheme.titleLarge),
            const SizedBox(height: 18),
            _BookingDetail(
                icon: Icons.calendar_today_outlined,
                text: booking.dateOfBooking),
            const SizedBox(height: 10),
            _BookingDetail(
                icon: Icons.schedule_rounded, text: booking.timeOfBooking),
            if (actions.isNotEmpty) ...[
              const Divider(height: 36),
              Wrap(spacing: 12, runSpacing: 12, children: actions),
            ],
          ],
        ),
      ),
    );
  }
}

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'requested' => const Color(0xFF885411),
      'rejected' => AppColors.error,
      'completed' => const Color(0xFF285C8B),
      'accepted' || 'paid' => AppColors.primary,
      _ => AppColors.muted,
    };
    final label = status.isEmpty ? 'Unknown' : status.capitalize();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: color.withAlpha(20), borderRadius: BorderRadius.circular(30)),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _BookingDetail extends StatelessWidget {
  const _BookingDetail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.muted),
      const SizedBox(width: 10),
      Expanded(child: Text(text))
    ]);
  }
}
