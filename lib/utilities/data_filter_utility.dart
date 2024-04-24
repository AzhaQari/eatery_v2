import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatery/meal_model.dart';

class DataFilterUtility {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Meal>> fetchMeals(String userId) async {
    var snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('trackedMeals')
        .get();
    return snapshot.docs
        .map((doc) => Meal.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<int> computeAllTimeProtein(String userId) async {
    List<Meal> meals = await fetchMeals(userId);
    return meals.fold<int>(0, (int total, Meal meal) => total + meal.protein);
  }

  static Future<int> computeTodayProtein(String userId) async {
    List<Meal> meals = await fetchMeals(userId);
    DateTime today = DateTime.now();
    return meals
        .where((meal) => meal.dateTracked.isSameDate(today))
        .fold<int>(0, (int total, Meal meal) => total + meal.protein);
  }

  static Future<int> computeTodayCalories(String userId) async {
    List<Meal> meals = await fetchMeals(userId);
    DateTime today = DateTime.now();
    return meals
        .where((meal) => meal.dateTracked.isSameDate(today))
        .fold<int>(0, (int total, Meal meal) => total + meal.calories);
  }

  static Future<double> computeMonthBudget(String userId) async {
    List<Meal> meals = await fetchMeals(userId);
    DateTime today = DateTime.now();
    return meals
        .where((meal) =>
            meal.dateTracked.year == today.year &&
            meal.dateTracked.month == today.month)
        .fold<double>(0.0, (double total, Meal meal) => total + meal.price);
  }

  static Future<double> computeAllTimeBudget(String userId) async {
    List<Meal> meals = await fetchMeals(userId);
    return meals.fold<double>(
        0.0, (double total, Meal meal) => total + meal.price);
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
