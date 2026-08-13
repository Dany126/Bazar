class TimelineStepDataModel {
  final String label;
  final int statusIndex;
  final bool completed;

  const TimelineStepDataModel({
    required this.label,
    required this.statusIndex,
    this.completed = false,
  });

  TimelineStepDataModel copyWith({bool? completed}) {
    return TimelineStepDataModel(
      label: label,
      statusIndex: statusIndex,
      completed: completed ?? this.completed,
    );
  }
}
