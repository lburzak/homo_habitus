const tables = {'habit': 'habit'};

class Tables {
  static const habit = 'habit';
  static const goal = 'goal';
  static const goalType = 'goal_type';
  static const timeframe = 'timeframe';
}

class HabitColumns {
  const HabitColumns();

  String get id => 'id';

  String get name => 'name';

  String get iconName => 'iconName';
}

class GoalColumns {
  const GoalColumns();

  String get id => 'id';

  String get habitId => 'habit_id';

  String get targetValue => 'target_value';

  String get type => 'type';

  String get timeframe => 'timeframe';

  String get assignmentDate => 'assignmentDate';
}

class GoalTypeColumns {
  const GoalTypeColumns();

  String get name => 'name';
}

class TimeframeColumns {
  const TimeframeColumns();

  String get name => 'name';
}

class Columns {
  static const habit = HabitColumns();
  static const goal = GoalColumns();
  static const goalType = GoalTypeColumns();
  static const timeframe = TimeframeColumns();
}

class Queries {
  static final String createHabitTable = '''
  create table ${Tables.habit} (
    ${Columns.habit.id} integer primary key autoincrement,
    ${Columns.habit.name} text,
    ${Columns.habit.iconName} text
  );
  ''';

  static final String createGoalTable = '''
  create table ${Tables.goal} (
    ${Columns.goal.id} integer,
    ${Columns.goal.habitId} integer,
    ${Columns.goal.targetValue} integer,
    ${Columns.goal.type} text,
    ${Columns.goal.timeframe} text,
    ${Columns.goal.assignmentDate} integer,
    foreign key(${Columns.goal.habitId}) references ${Tables.habit}(${Columns.habit.id})
    foreign key(${Columns.goal.type}) references ${Tables.goalType}(${Columns.goalType.name})
    foreign key(${Columns.goal.timeframe}) references ${Tables.timeframe}(${Columns.goalType.name})
  );
  ''';

  static final String createGoalTypeTable = '''
  create table ${Tables.goalType} (
    ${Columns.goalType.name} text
  )
  ''';

  static final String createTimeframeTable = '''
  create table ${Tables.timeframe} (
    ${Columns.timeframe.name} text
  )
  ''';

  static const String populateGoalTypeTable = '''
  insert into ${Tables.goalType} values ('counter'), ('timer');
  ''';

  static const String populateTimeframeTable = '''
  insert into ${Tables.timeframe} values ('day'), ('week'), ('month');
  ''';
}
