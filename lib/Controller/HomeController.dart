import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lovemyshow/Models/CategoryModels.dart';
import 'dart:convert';
import 'package:lovemyshow/Models/SliderModels.dart';

class HomeController extends GetxController {
  final RxList<SliderItem> sliders = <SliderItem>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoadingSliders = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxInt currentSliderIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
    fetchCategories();
  }

  Future<void> fetchSliders() async {
    isLoadingSliders.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://www.bme.seawindsolution.ae/api/f/slider'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['responsedata'] != null) {
          final List<dynamic> slidersData = data['responsedata'];
          sliders.value = slidersData
              .map((sliderJson) => SliderItem.fromJson(sliderJson))
              .toList();
        }
      } else {
        throw Exception('Failed to load sliders');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sliders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSliders.value = false;
    }
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://www.bme.seawindsolution.ae/api/f/category'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['responsedata'] != null) {
          final List<dynamic> categoriesData = data['responsedata'];
          categories.value = categoriesData
              .map((categoryJson) => Category.fromJson(categoryJson))
              .toList();
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void updateSliderIndex(int index) {
    currentSliderIndex.value = index;
  }
}