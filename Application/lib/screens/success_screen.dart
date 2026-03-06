import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../models/incident_request.dart';
import '../models/issue_resolved_request.dart';
import '../services/incident_service.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  static const routeName = '/success';

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  bool _isSubmitting = false;
  String? _error;

  Future<void> _resolveIssue() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final map = args is Map ? args : null;
    final incident = map?['incident'] as IncidentRequest?;
    final submittedAt = map?['submittedAt'] as DateTime?;

    if (incident == null || submittedAt == null) {
      setState(() => _error = 'Incident details unavailable.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    HapticFeedback.selectionClick();

    try {
      final payload = IssueResolvedRequest(
        eventId: incident.eventId,
        name: incident.name,
        phoneNumber: incident.phoneNumber,
        latitude: incident.latitude,
        longitude: incident.longitude,
        timestamp: DateTime.now(),
        reportedAt: submittedAt,
      );

      await IncidentService().markIssueResolved(payload);
      HapticFeedback.mediumImpact();

      if (!mounted) return;
      Navigator.popUntil(
        context,
        (route) => route.settings.name == '/events' || route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : AppTheme.primary.withValues(alpha: 0.08);
    final iconColor = isDark ? AppTheme.accent : AppTheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 88,
                  width: 88,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.18)
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 48,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Incident Report Submitted Successfully',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Our team will arrive and address you soon. Do not worry!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSubmitting ? null : _resolveIssue,
                  child: Text(_isSubmitting ? 'Submitting...' : 'Issue Resolved'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
