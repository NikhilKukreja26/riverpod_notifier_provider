import 'package:notifier_provider/models/activity.dart';
import 'package:notifier_provider/pages/sealed_async_activity/sealed_async_activity_state.dart';
import 'package:notifier_provider/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sealed_async_activity_provider.g.dart';

@riverpod
class SealedAsyncActivity extends _$SealedAsyncActivity {
  int _errorCounter = 0;

  SealedAsyncActivity() {
    print('[sealedAsyncActivityProvider] constructor called');
  }

  @override
  SealedAsyncActivityState build() {
    print('[sealedAsyncActivityProvider] initialized');
    ref.onDispose(() {
      print('[sealedAsyncActivityProvider] disposed');
    });

    print('hashCode: $hashCode');
    fetchActivity(activityType: activityTypes[0]);
    return const SealedAsyncActivityLoading();
  }

  Future<void> fetchActivity({required String activityType}) async {
    print('hashCode in fetchActivity: $hashCode');
    state = const SealedAsyncActivityLoading();

    try {
      print('_errorCounter: $_errorCounter');
      if (_errorCounter++ % 2 != 1) {
        await Future.delayed(const Duration(milliseconds: 500));
        throw 'Fail to fetch activity';
      }
      final response = await ref.watch(dioProvider).get('?type=$activityType');

      final List activityList = response.data;

      final activities = [
        for (final activity in activityList) Activity.fromJson(activity),
      ];

      state = SealedAsyncActivitySuccess(activities: activities);
    } catch (e) {
      state = SealedAsyncActivityFailure(
        error: e.toString(),
      );
    }
  }
}
