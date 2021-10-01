part of 'habit_creator_bloc.dart';

class HabitCreatorState extends Equatable {
  final IconAsset icon;
  final String name;
  final Deadline deadline;
  final int targetCount;
  final int targetHours;
  final int targetMinutes;
  final GoalType goalType;
  final bool finished;

  const HabitCreatorState(
      {required this.icon,
      required this.name,
      required this.deadline,
      required this.targetCount,
      required this.targetHours,
      required this.targetMinutes,
      required this.goalType,
      required this.finished});

  HabitCreatorState copyWith(
          {IconAsset? icon,
          String? name,
          Deadline? deadline,
          int? targetCount,
          int? targetHours,
          int? targetMinutes,
          GoalType? goalType,
          bool? finished}) =>
      HabitCreatorState(
          icon: icon ?? this.icon,
          name: name ?? this.name,
          deadline: deadline ?? this.deadline,
          targetCount: targetCount ?? this.targetCount,
          targetHours: targetHours ?? this.targetHours,
          targetMinutes: targetMinutes ?? this.targetMinutes,
          goalType: goalType ?? this.goalType,
          finished: finished ?? this.finished);

  @override
  List<Object> get props =>
      [
        icon,
        name,
        deadline,
        goalType,
        targetCount,
        targetHours,
        targetMinutes,
        finished
      ];
}
