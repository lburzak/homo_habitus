import 'package:homo_habitus/model/deadline.dart';
import 'package:homo_habitus/model/progress.dart';

class Goal {
  final Deadline deadline;
  final Progress progress;

  static Goal placeholder() =>
      Goal(progress: CounterProgress.initial(10), deadline: Deadline.endOfDay);

  Goal({required this.deadline, required this.progress});
}
