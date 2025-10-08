// lib/screens/cleaner_screen.dart
import 'package:flutter/material.dart';
import 'package:home_service_app/class/service_model.dart';
import 'package:get/get.dart';
import 'package:home_service_app/bookings/Personal_Info.dart';

class MechanicScreen extends StatefulWidget {
  MechanicScreen({Key? key}) : super(key: key);

  @override
  State<MechanicScreen> createState() => _MechanicScreenState();
}

class _MechanicScreenState extends State<MechanicScreen> {
  // sample data
  final List<Service> services = [
    Service(
      id: 's1',
      providerName: 'Shyamaji bhai',
      providerAvatarUrl: '//https://i.pravatar.cc/150?img=3',
      title: 'Complete Kitchen Cleaning',
      price: 799,
      originalPrice: 1800,
      rating: 5,
      reviews: 130,
      imageUrl:
          'https://images.unsplash.com/photo-1581579186584-9e6b3f0f7c6f?auto=format&fit=crop&w=1200&q=60',
    ),
    Service(
      id: 's2',
      providerName: 'Nayannhai',
      providerAvatarUrl: '//https://i.pravatar.cc/150?img=5',
      title: 'Window Cleaning',
      price: 880,
      originalPrice: 1000,
      rating: 5,
      reviews: 130,
      imageUrl:
          'https://images.unsplash.com/photo-1581579186584-9e6b3f0f7c6f?auto=format&fit=crop&w=1200&q=60',
    ),
  ];

  // ऊपर वाला card नहीं दिखाना
  final bool removeTop = true;

  @override
  Widget build(BuildContext context) {
    final List<Service> visible = removeTop
        ? services.skip(0).toList()
        : services;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Meachanic'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Get.to(HomeScreen());
        //     },
        //     icon: const Icon(Icons.search),
        //   ),
        //   //   IconButton(
        //   //     onPressed: () {},
        //   //     icon: const Icon(Icons.shopping_cart_outlined),
        //   //   ),
        // ],
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
      //   bottomNavigationBar: BottomNavigationBar(
      //     currentIndex: 1,
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //       BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
      //     ],
      //   ),
    );
  }

  Widget _buildServiceCard(Service service) {
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
              child: Image.network(
                service.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image, size: 48)),
                ),
              ),
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
                    Get.to(InfoFormPage());
                    // book action
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
