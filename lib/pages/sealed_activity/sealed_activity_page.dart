import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/enum_activity/enum_activity_page.dart';
import 'package:notifier_provider/pages/sealed_activity/sealed_activity_provider.dart';
import 'package:notifier_provider/pages/sealed_activity/sealed_activity_state.dart';

class SealedActivityPage extends ConsumerStatefulWidget {
  const SealedActivityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SealedActivityPageState();
}

class _SealedActivityPageState extends ConsumerState<SealedActivityPage> {
  Widget? prevWidget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(sealedActivityProvider.notifier)
          .fetchActivity(activityType: activityTypes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(sealedActivityProvider);
    ref.listen<SealedActivityState>(sealedActivityProvider, (previous, next) {
      if (next is SealedActivityFailure) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(next.error),
            );
          },
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('SealedActivityNotifier'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(sealedActivityProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (activityState) {
        SealedActivityInitial() => const Center(
            child: Text(
              'Get some activity',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        SealedActivityLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        SealedActivityFailure() => prevWidget == null
            ? const Center(
                child: Text(
                  'Get some activity',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              )
            : prevWidget!,
        SealedActivitySuccess(activities: List<Activity> activities) =>
          prevWidget = ActivityWidget(
            activity: activities.first,
          ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final randomNumber = Random().nextInt(activityTypes.length);
          ref
              .read(sealedActivityProvider.notifier)
              .fetchActivity(activityType: activityTypes[randomNumber]);
        },
        label: Text(
          'New Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
