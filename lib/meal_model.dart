class Meal {
  final String name;
  final String restaurant;
  final int calories;
  final int protein;
  final int price;

  Meal({
    required this.name,
    required this.restaurant,
    required this.calories,
    required this.protein,
    required this.price,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['item name'] as String? ?? 'N/A',
      restaurant: map['restaurant'] as String? ?? 'N/A',
      calories: int.tryParse(map['calories']?.toString() ?? '0') ?? 0,
      protein: int.tryParse(map['protein']?.toString() ?? '0') ?? 0,
      // Check if 'price' exists and is not an empty string; if it is, use default value 0
      price: (map['0'] as String?)?.isEmpty ?? true
          ? 0
          : int.tryParse(map['price'] ?? '0') ?? 0,
    );
  }
}
