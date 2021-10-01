import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homo_habitus/domain/model/progress.dart';

part 'progress_list_state.dart';

class ProgressListCubit extends Cubit<ProgressListState> {
  ProgressListCubit() : super(ProgressListLoaded([CounterProgress(2, 10)]));
}
