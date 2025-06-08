import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lovemyshow/Models/CityModels.dart';
import 'dart:convert';

class CityController extends GetxController {
  final RxList<City> cities = <City>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt countryId = 0.obs;
  final RxString countryName = ''.obs;
  final Rx<City?> selectedCity = Rx<City?>(null);

  List<City> get filteredCities {
    if (searchQuery.value.isEmpty) {
      return cities;
    }
    return cities.where((city) =>
        city.title.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  List<City> get popularCities {
    return cities.length > 9 ? cities.sublist(0, 9) : cities;
  }

  List<City> get otherCities {
    return cities.length > 9 ? cities.sublist(9) : [];
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      countryId.value = args['countryId'] ?? 0;
      countryName.value = args['countryName'] ?? '';
      fetchCities(countryId.value);
    }
  }

  Future<void> fetchCities(int id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://www.bme.seawindsolution.ae/api/f/city/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['responsedata'] != null) {
          final List<dynamic> citiesData = data['responsedata'];
          cities.value = citiesData
              .map((cityJson) => City.fromJson(cityJson))
              .toList();
          if (cities.isNotEmpty && selectedCity.value == null) {
            selectedCity.value = cities[0];
          }
        }
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cities: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void selectCity(City city) {
    selectedCity.value = city;
  }
}