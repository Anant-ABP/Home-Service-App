// lib/screens/cleaner_screen.dart
import 'package:flutter/material.dart';
import 'package:home_service_app/class/service_model.dart';
import 'package:get/get.dart';
// Assuming Personal_Info.dart contains the InfoFormPage widget
import 'package:home_service_app/bookings/Personal_Info.dart';

class CarpenterScreen extends StatefulWidget {
  const CarpenterScreen({super.key});

  @override
  State<CarpenterScreen> createState() => _CarpenterScreenState();
}

class _CarpenterScreenState extends State<CarpenterScreen> {
  // sample data
  final List<Service> services = [
    Service(
      id: 's1',
      providerName: 'Shyamaji bhai',
      providerAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      title: 'Custom Furniture Repair',
      price: 999,
      originalPrice: 1500,
      rating: 5,
      reviews: 130,
      // *** MODIFIED to use your local asset '1.jpg' ***
      imageUrl: 'assets/1.png',
    ),
    Service(
      id: 's2',
      providerName: 'Nayanbhai',
      providerAvatarUrl: 'https://i.pravatar.cc/150?img=5',
      title: 'Door and Window Frame Installation',
      price: 880,
      originalPrice: 1000,
      rating: 5,
      reviews: 130,
      // Kept as a network image
      imageUrl: 'assets/2.jpeg',
    ),
  ];

  final bool removeTop = false;

  @override
  Widget build(BuildContext context) {
    final List<Service> visible = removeTop
        ? services.skip(1).toList()
        : services;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Carpenter'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final service = visible[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    // Determine if the image is a local asset or a network URL
    final bool isAsset = service.imageUrl.startsWith('assets/');

    // Select the correct Image widget based on the source
    Widget imageWidget;
    if (service.imageUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        service.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: Text(
              "Asset Not Found",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      );
    } else {
      // Use Image.network for web URLs
      imageWidget = Image.network(
        service.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image, size: 48)),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: imageWidget, // Use the dynamically created widget
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(service.providerAvatarUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 10),
                // details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.providerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "Rs. ${service.price.toStringAsFixed(0)}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Rs. ${service.originalPrice.toStringAsFixed(0)}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < service.rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(${service.reviews} Reviews)",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const InfoFormPage());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  child: const Text("Book"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
