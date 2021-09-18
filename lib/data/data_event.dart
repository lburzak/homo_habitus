import 'dart:async';

class DataEvent {}

class HabitCreatedEvent extends DataEvent {
  HabitCreatedEvent();
}

class HabitChangedEvent extends DataEvent {
  final int habitId;

  HabitChangedEvent(this.habitId);
}

class DataEventBus {
  final StreamController<DataEvent> _events = StreamController.broadcast();

  Stream<DataEvent> get events => _events.stream;

  void emit(DataEvent event) {
    _events.add(event);
  }
}
