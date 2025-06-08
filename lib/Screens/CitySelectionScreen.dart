import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/CityController.dart';
import 'package:lovemyshow/Models/CityModels.dart';

class CitySelectionScreen extends StatelessWidget {
  const CitySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CityController controller = Get.put(CityController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pick a Region',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: controller.updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search for your city',
                    prefixIcon: const Icon(Icons.search, color: Colors.pink),
                    suffixIcon: const Icon(Icons.mic, color: Colors.pink),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                    );
                  }
                  if (controller.cities.isEmpty) {
                    return const Center(
                      child: Text('No cities available'),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POPULAR CITIES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: controller.popularCities.length,
                          itemBuilder: (context, index) {
                            final city = controller.popularCities[index];
                            return _buildCityItem(city);
                          },
                        ),
                        if (controller.otherCities.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'OTHER CITIES',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.otherCities.length,
                            itemBuilder: (context, index) {
                              final city = controller.otherCities[index];
                              return _buildCityListItem(city);
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityItem(City city) {
    bool isSelected = false;

    return GestureDetector(
      onTap: () {
        Get.offAllNamed('/home', arguments: {
          'selectedCity': city,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              isSelected ? city.activeImage : city.image,
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.location_city, size: 50);
              },
            ),
            const SizedBox(height: 8),
            Text(
              city.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.pink : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityListItem(City city) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        title: Text(
          city.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          Get.offAllNamed('/home', arguments: {
            'selectedCity': city,
          });
        },
      ),
    );
  }
}