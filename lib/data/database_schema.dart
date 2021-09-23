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

  String get assignmentDate => 'assignment_date';
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
    ${Columns.goal.id} integer primary key autoincrement,
    ${Columns.goal.habitId} integer,
    ${Columns.goal.targetValue} integer,
    ${Columns.goal.type} text,
    ${Columns.goal.timeframe} text,
    ${Columns.goal.assignmentDate} integer,
    foreign key(${Columns.goal.habitId}) references ${Tables.habit}(${Columns.habit.id}),
    foreign key(${Columns.goal.type}) references ${Tables.goalType}(${Columns.goalType.name}),
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
    ${Columns.progress.timestamp} integer default (strftime('%s', 'now')),
    
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

  static final String selectCurrentProgressByHabitId = '''
  select sum(${Tables.progress}.${Columns.progress.value}), ${Tables.goal}.${Columns.goal.targetValue}
  from ${Tables.goal}
  inner join ${Tables.progress}
    on ${Tables.progress}.${Columns.progress.goalId} = ${Tables.goal}.${Columns.goal.id}
  inner join ${Tables.timeframe}
    on ${Tables.goal}.${Columns.goal.timeframe} = ${Tables.timeframe}.${Columns.timeframe.name}
  where ${Tables.goal}.${Columns.goal.habitId} = (
    select ${Tables.goal}.${Columns.goal.habitId}
    from ${Tables.goal}
    inner join ${Tables.habit} on ${Tables.habit}.${Columns.habit.id} = ${Tables.goal}.${Columns.goal.habitId}
    where ${Tables.goal}.${Columns.goal.habitId} = ?
    order by ${Tables.goal}.${Columns.goal.assignmentDate} desc
    limit 1
  )
  and ${Tables.progress}.${Columns.progress.timestamp} >= (
    case ${Tables.timeframe}.${Columns.timeframe.name}
      when '${Values.timeframe.day}' then
        strftime('%s', 'now', 'start of day')
      when '${Values.timeframe.week}' then
        strftime('%s', 'now', 'weekday 1', '-7 days', 'start of day')
      else
        strftime('%s', 'now', 'start of month')
    end
  );
  ''';

  static const String selectHabitsStatusesByTimeframe = '''
  select habit.*, current_goal.*, ifnull(sum(applicable_progress.value), 0) as current_progress
  from habit
  left join (
    select goal.*, max(goal.assignment_date)
    from habit
    inner join goal
      on goal.habit_id = habit.id
    group by habit.id
  ) as current_goal
    on current_goal.habit_id = habit.id
  left join timeframe
    on current_goal.timeframe = timeframe.name
  left join (
    select *
    from progress
    inner join goal
      on goal.id = progress.goal_id
    where progress.timestamp >= (
    case goal.timeframe
      when 'day' then
      strftime('%s', 'now', 'start of day')
      when 'week' then
      strftime('%s', 'now', 'weekday 1', '-7 days', 'start of day')
      else
      strftime('%s', 'now', 'start of month')
    end
    )
  ) as applicable_progress
  on applicable_progress.goal_id = current_goal.id
  where timeframe.name = ?
  group by habit.id
  ''';

  static const getProgressByHabitId = '''
  select
    current_goal.type,
    ifnull(sum(applicable_progress.value), 0) as current_progress,
    current_goal.target_value
  from habit
  left join (
    select goal.*, max(goal.assignment_date)
    from habit
    inner join goal
      on goal.habit_id = habit.id
    group by habit.id
  ) as current_goal
    on current_goal.habit_id = habit.id
  left join timeframe
    on current_goal.timeframe = timeframe.name
  left join (
    select *
    from progress
    inner join goal
      on goal.id = progress.goal_id
    where progress.timestamp >= (
    case goal.timeframe
      when 'day' then
      strftime('%s', 'now', 'start of day')
      when 'week' then
      strftime('%s', 'now', 'weekday 1', '-7 days', 'start of day')
      else
      strftime('%s', 'now', 'start of month')
    end
    )
  ) as applicable_progress
  on applicable_progress.goal_id = current_goal.id
  where habit.id = ?
  group by habit.id
  ''';

  static const addProgressToCurrentGoal = '''
  insert into progress (goal_id, value) values (
	(
    select goal.id
    from habit
    inner join goal
      on goal.habit_id = habit.id
    where habit.id = ?
    group by habit.id
    having goal.id = max(goal.id)
	),
	?
  )
  ''';

  static const selectHabitById = '''
  select habit.*, current_goal.*, ifnull(sum(applicable_progress.value), 0) as current_progress
  from habit
  left join (
    select goal.*, max(goal.assignment_date)
    from habit
    inner join goal
      on goal.habit_id = habit.id
    group by habit.id
  ) as current_goal
    on current_goal.habit_id = habit.id
  left join timeframe
    on current_goal.timeframe = timeframe.name
  left join (
    select *
    from progress
    inner join goal
      on goal.id = progress.goal_id
    where progress.timestamp >= (
    case goal.timeframe
      when 'day' then
      strftime('%s', 'now', 'start of day')
      when 'week' then
      strftime('%s', 'now', 'weekday 1', '-7 days', 'start of day')
      else
      strftime('%s', 'now', 'start of month')
    end
    )
  ) as applicable_progress
  on applicable_progress.goal_id = current_goal.id
  where habit.id = ?
  group by habit.id
  ''';
}
