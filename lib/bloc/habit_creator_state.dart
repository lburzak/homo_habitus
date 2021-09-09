part of 'habit_creator_bloc.dart';

class HabitCreatorState extends Equatable {
  final IconAsset icon;
  final String name;
  final Timeframe timeframe;
  final int targetCount;
  final int targetHours;
  final int targetMinutes;
  final GoalType goalType;

  const HabitCreatorState(
      {required this.icon,
      required this.name,
      required this.timeframe,
      required this.targetCount,
      required this.targetHours,
      required this.targetMinutes,
      required this.goalType});

  HabitCreatorState copyWith(
          {IconAsset? icon,
          String? name,
          Timeframe? timeframe,
          int? targetCount,
          int? targetHours,
          int? targetMinutes,
          GoalType? goalType}) =>
      HabitCreatorState(
          icon: icon ?? this.icon,
          name: name ?? this.name,
          timeframe: timeframe ?? this.timeframe,
          targetCount: targetCount ?? this.targetCount,
          targetHours: targetHours ?? this.targetHours,
          targetMinutes: targetMinutes ?? this.targetMinutes,
          goalType: goalType ?? this.goalType);

  @override
  List<Object> get props => [
        icon,
        name,
        timeframe,
        goalType,
        targetCount,
        targetHours,
        targetMinutes,
      ];
}
