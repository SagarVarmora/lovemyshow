import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lovemyshow/Models/CountryModels.dart';
import 'dart:convert';

class CountryController extends GetxController {
  final RxList<Country> countries = <Country>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  List<Country> get filteredCountries {
    if (searchQuery.value.isEmpty) {
      return countries;
    }
    return countries.where((country) =>
        country.title.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://www.bme.seawindsolution.ae/api/f/country'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['responsedata'] != null) {
          final List<dynamic> countriesData = data['responsedata'];
          countries.value = countriesData
              .map((countryJson) => Country.fromJson(countryJson))
              .toList();
        }
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load countries: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}