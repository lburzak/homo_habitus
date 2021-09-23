import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'progress_calendar_state.dart';

class ProgressCalendarCubit extends Cubit<ProgressCalendarState> {
  ProgressCalendarCubit() : super(const ProgressCalendarLoaded([1, 24, 30]));
}
