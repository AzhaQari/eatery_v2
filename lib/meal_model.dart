import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String name;
  final String restaurant;
  final int calories;
  final int protein;
  final int price;
  final DateTime dateTracked; // Add this line

  Meal({
    required this.name,
    required this.restaurant,
    required this.calories,
    required this.protein,
    required this.price,
    required this.dateTracked, // Add this line
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    // Parsing the 'dateTracked' field correctly depending on its type
    DateTime parsedDateTracked;
    if (map['dateTracked'] is Timestamp) {
      parsedDateTracked = (map['dateTracked'] as Timestamp).toDate();
    } else if (map['dateTracked'] is String) {
      parsedDateTracked = DateTime.parse(map['dateTracked']);
    } else {
      // Default to current date if parsing fails
      parsedDateTracked = DateTime.now();
    }

    return Meal(
      name: map['item name'] as String? ?? 'N/A',
      restaurant: map['restaurant'] as String? ?? 'N/A',
      calories: int.tryParse(map['calories']?.toString() ?? '0') ?? 0,
      protein: int.tryParse(map['protein']?.toString() ?? '0') ?? 0,
      price: int.tryParse(map['0']?.toString() ?? '0') ?? 0,
      dateTracked: parsedDateTracked,
    );
  }
}
