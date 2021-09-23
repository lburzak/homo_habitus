import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/model/habit_progress.dart';

part 'progress_list_state.dart';

class ProgressListCubit extends Cubit<ProgressListState> {
  ProgressListCubit() : super(ProgressListLoaded([CounterGoalProgress(2, 10)]));
}
