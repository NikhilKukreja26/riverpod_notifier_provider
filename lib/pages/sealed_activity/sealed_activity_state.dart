import 'package:notifier_provider/models/activity.dart';

sealed class SealedActivityState {
  const SealedActivityState();

  @override
  String toString() => 'SealedActivityState()';
}

final class SealedActivityInitial extends SealedActivityState {
  const SealedActivityInitial();

  @override
  String toString() => 'SealedActivityInitial()';
}

final class SealedActivityLoading extends SealedActivityState {
  const SealedActivityLoading();

  @override
  String toString() => 'SealedActivityLoading()';
}

final class SealedActivitySuccess extends SealedActivityState {
  final List<Activity> activities;

  const SealedActivitySuccess({
    required this.activities,
  });

  @override
  String toString() => 'SealedActivitySuccess(activities: $activities)';
}

final class SealedActivityFailure extends SealedActivityState {
  final String error;
  const SealedActivityFailure({
    required this.error,
  });

  @override
  String toString() => 'SealedActivityFailure(error: $error)';
}
