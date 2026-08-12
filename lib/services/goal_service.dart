import '../database/database_helper.dart';
import '../models/user_goal.dart';

class GoalService {
  static Future<UserGoal> getGoals() async {
    return await DatabaseHelper.instance.getUserGoal();
  }

  static Future<void> updateGoals(UserGoal goal) async {
    await DatabaseHelper.instance.saveUserGoal(goal);
  }
}
