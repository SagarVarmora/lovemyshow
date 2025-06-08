import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lovemyshow/Controller/HomeController.dart';
import 'package:lovemyshow/Models/CityModels.dart';
import 'package:lovemyshow/Widgets/AppDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    City? selectedCity;
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('selectedCity')) {
      selectedCity = args['selectedCity'] as City;
    }
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE91E63),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(selectedCity),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchAndButtonsSection(),
                    _buildCategoriesChips(controller),
                    _buildSliderSection(controller),
                    _buildNewExperienceSection(controller),
                    _buildPremiereSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(City? selectedCity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFE91E63),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'BOOK MY\nEVENT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          selectedCity?.title ?? 'Mumbai',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('🇮🇳', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: const Icon(Icons.menu, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndButtonsSection() {
    return Container(
      color: const Color(0xFFE91E63),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 8, right: 4),
                    child: const Icon(
                      Icons.search,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'ListYourShow',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Offers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesChips(HomeController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE91E63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        child: Obx(() {
          if (controller.isLoadingCategories.value) {
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              ),
            );
          }
          if (controller.categories.isEmpty) {
            final defaultCategories = [
              'Workshop',
              'Kids',
              'Comedy',
              'Music',
              'Theatre',
              'Sports',
              'Online',
            ];
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: defaultCategories.length,
                clipBehavior: Clip.hardEdge,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(
                        defaultCategories[index],
                        style: const TextStyle(
                          color: Color(0xFFE91E63),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE91E63), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: controller.categories.length,
              clipBehavior: Clip.hardEdge,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      category.title,
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE91E63), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSliderSection(HomeController controller) {
    return Obx(() {
      if (controller.isLoadingSliders.value) {
        return Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
            ),
          ),
        );
      }
      if (controller.sliders.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: controller.sliders.length,
              itemBuilder: (context, index, realIndex) {
                final slider = controller.sliders[index];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      slider.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  controller.updateSliderIndex(index);
                },
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.sliders.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentSliderIndex.value == index
                        ? const Color(0xFFE91E63)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            )),
          ],
        ),
      );
    });
  }

  Widget _buildNewExperienceSection(HomeController controller) {
    final List<Map<String, dynamic>> categoryStyles = [
      {'color': const Color(0xFFFF6B35), 'icon': Icons.build},
      {'color': const Color(0xFF9C27B0), 'icon': Icons.theater_comedy},
      {'color': const Color(0xFF2196F3), 'icon': Icons.music_note},
      {'color': const Color(0xFF4CAF50), 'icon': Icons.theaters},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Find New Experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFFE91E63),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Engage, Investigate, Draft a Plan',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingCategories.value) {
              return Container(
                height: 120,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                  ),
                ),
              );
            }
            final categoriesToShow = controller.categories.isEmpty
                ? [
              {'title': 'Workshop', 'image': 'https://picsum.photos/seed/workshop/140/120'},
              {'title': 'Kids', 'image': 'https://picsum.photos/seed/kids/140/120'},
              {'title': 'Comedy', 'image': 'https://picsum.photos/seed/comedy/140/120'},
              {'title': 'Music', 'image': 'https://picsum.photos/seed/music/140/120'},
              {'title': 'Theatre', 'image': 'https://picsum.photos/seed/theatre/140/120'},
              {'title': 'Sports', 'image': 'https://picsum.photos/seed/sports/140/120'},
              {'title': 'Online', 'image': 'https://picsum.photos/seed/online/140/120'},
            ]
                : controller.categories
                .map((category) => {
              'title': category.title,
              'image': category.image.isNotEmpty
                  ? category.image
                  : category.hidImage.isNotEmpty
                  ? category.hidImage
                  : 'https://picsum.photos/seed/${category.title}/140/120',
            })
                .toList();
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesToShow.length,
                itemBuilder: (context, index) {
                  final category = categoriesToShow[index];
                  final style = categoryStyles[index % categoryStyles.length];
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        // Image with loader
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            category['image'] as String,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return Stack(
                                  children: [
                                    child,
                                    Container(
                                      decoration: BoxDecoration(
                                        color: (style['color'] as Color).withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container(
                                height: 140,
                                width: 140,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 140,
                                width: 140,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPremiereSection() {
    final events = [
      {
        'title': 'GARBA KING',
        'image': 'https://picsum.photos/seed/event1/150/200',
        'organizer': 'HDL Concerts presents Kirtidan Gadhvi',
        'language': 'Gujarati',
        'genre': 'Music'
      },
      {
        'title': 'COMEDY NIGHT',
        'image': 'https://picsum.photos/seed/event2/150/200',
        'organizer': 'Stand Up Comedy Show',
        'language': 'Hindi',
        'genre': 'Comedy'
      },
      {
        'title': 'ROCK CONCERT',
        'image': 'https://picsum.photos/seed/event3/150/200',
        'organizer': 'Live Music Performance',
        'language': 'English',
        'genre': 'Music'
      },
      {
        'title': 'THEATRE PLAY',
        'image': 'https://picsum.photos/seed/event4/150/200',
        'organizer': 'Drama Performance',
        'language': 'Hindi',
        'genre': 'Theatre'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'PREMIERE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFFE91E63),
                    size: 20,
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFFE91E63),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Watch new Popular events',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event['image'] as String,
                          height: 180,
                          width: 160,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              width: 160,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: 160,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          event['organizer'] as String,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}