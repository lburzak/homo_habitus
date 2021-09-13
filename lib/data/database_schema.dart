const tables = {'habit': 'habit'};

class Tables {
  static const habit = 'habit';
  static const goal = 'goal';
  static const goalType = 'goal_type';
  static const timeframe = 'timeframe';
  static const progress = 'progress';
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

class ProgressColumns {
  const ProgressColumns();

  String get id => 'id';
  String get goalId => 'goal_id';
  String get value => 'value';
  String get timestamp => 'timestamp';
}

class Columns {
  static const habit = HabitColumns();
  static const goal = GoalColumns();
  static const goalType = GoalTypeColumns();
  static const timeframe = TimeframeColumns();
  static const progress = ProgressColumns();
}

class TimeframeValues {
  const TimeframeValues();

  String get day => 'day';
  String get week => 'week';
  String get month => 'month';
}

class Values {
  static const timeframe = TimeframeValues();
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
    ${Columns.goal.id} integer primary key,
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
    ${Columns.goalType.name} text primary key
  )
  ''';

  static final String createTimeframeTable = '''
  create table ${Tables.timeframe} (
    ${Columns.timeframe.name} text primary key
  )
  ''';

  static final String createProgressTable = '''
  create table ${Tables.progress} (
    ${Columns.progress.id} integer primary key autoincrement,
    ${Columns.progress.goalId} integer,
    ${Columns.progress.value} integer,
    ${Columns.progress.timestamp} integer,
    
    foreign key(${Columns.progress.goalId}) references ${Tables.goal}(${Columns.goal.id})
  ) 
  ''';

  // TODO: Extract magic strings
  static const String populateGoalTypeTable = '''
  insert into ${Tables.goalType} values ('counter'), ('timer');
  ''';

  static final String populateTimeframeTable = '''
  insert into ${Tables.timeframe} values ('${Values.timeframe.day}'), ('${Values.timeframe.week}'), ('${Values.timeframe.month}');
  ''';

  static final String selectHabitsByTimeframe = '''
  select ${Tables.habit}.${Columns.habit.id}, ${Tables.habit}.${Columns.habit.name}, ${Tables.habit}.${Columns.habit.iconName}
  from ${Tables.habit}
    left join ${Tables.goal}
      on ${Tables.habit}.${Columns.habit.id} = ${Tables.goal}.${Columns.goal.habitId}
    left join ${Tables.timeframe}
      on ${Tables.goal}.${Columns.goal.timeframe} = ${Tables.timeframe}.${Columns.timeframe.name}
  where ${Tables.timeframe}.${Columns.timeframe.name} = ?
  ''';
}
