import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/enum_activity/enum_activity_page.dart';
import 'package:notifier_provider/pages/sealed_async_activity/sealed_async_activity_state.dart';
import 'package:notifier_provider/pages/sealed_async_activity/sealed_async_activity_provider.dart';

class SealedAsyncActivityPage extends ConsumerStatefulWidget {
  const SealedAsyncActivityPage({super.key});

  @override
  ConsumerState<SealedAsyncActivityPage> createState() =>
      _SealedAsyncActivityPageState();
}

class _SealedAsyncActivityPageState
    extends ConsumerState<SealedAsyncActivityPage> {
  Widget? prevWidget;

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(sealedAsyncActivityProvider);
    ref.listen<SealedAsyncActivityState>(sealedAsyncActivityProvider,
        (previous, next) {
      if (next is SealedAsyncActivityFailure) {
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
        title: const Text('SealedAsyncActivityNotifier'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(sealedAsyncActivityProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (activityState) {
        // SealedActivityInitial() => const Center(
        //     child: Text(
        //       'Get some activity',
        //       style: TextStyle(fontSize: 20.0),
        //     ),
        //   ),
        SealedAsyncActivityLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        SealedAsyncActivityFailure() => prevWidget == null
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
        SealedAsyncActivitySuccess(activities: List<Activity> activities) =>
          prevWidget = ActivityWidget(
            activity: activities.first,
          ),
      },
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final randomNumber = Random().nextInt(activityTypes.length);
          ref
              .read(sealedAsyncActivityProvider.notifier)
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
