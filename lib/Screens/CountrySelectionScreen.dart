import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovemyshow/Controller/CountryController.dart';
import 'package:lovemyshow/Models/CountryModels.dart';

class CountrySelectionScreen extends StatelessWidget {
  const CountrySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CountryController controller = Get.put(CountryController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Country',
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
                    hintText: 'Search Country',
                    prefixIcon: const Icon(Icons.search, color: Colors.pink),
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
                  if (controller.countries.isEmpty) {
                    return const Center(
                      child: Text('No countries available'),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = controller.filteredCountries[index];
                      return _buildCountryItem(country);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryItem(Country country) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/city', arguments: {
          'countryId': country.id,
          'countryName': country.title,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                country.image,
                height: 150,
                width: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: child,
                    );
                  }
                  return Container(
                    height: 150,
                    width: 300,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 300,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              country.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}