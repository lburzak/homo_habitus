part of 'progress_list_cubit.dart';

abstract class ProgressListState extends Equatable {
  const ProgressListState();
}

class ProgressListInitial extends ProgressListState {
  @override
  List<Object> get props => [];
}

class ProgressListLoading extends ProgressListState {
  @override
  List<Object> get props => [];
}

class ProgressListLoaded extends ProgressListState {
  final List<GoalProgress> dayProgresses;

  const ProgressListLoaded(this.dayProgresses);

  @override
  List<Object> get props => [dayProgresses];
}
