// lib/models/service_model.dart
class Service {
  final String id;
  final String providerName;
  final String providerAvatarUrl;
  final String title;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviews;
  final String imageUrl;

  Service({
    required this.id,
    required this.providerName,
    required this.providerAvatarUrl,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });
}
