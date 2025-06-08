import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              color: const Color(0xFFE91E63),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Spacer(),
                      user != null
                          ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFFE91E63),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            user.phoneNumber ?? 'No number available',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : ElevatedButton(
                        onPressed: () => Get.offNamed('/signin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.white, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  _buildDrawerItem(icon: Icons.person_outline, title: 'My Profile', onTap: () => Get.toNamed('/profile')),
                  _buildDrawerItem(icon: Icons.calendar_today_outlined, title: 'List Your Show', onTap: () {}),
                  _buildDrawerItem(icon: Icons.local_offer_outlined, title: 'Offers', onTap: () {}),
                  _buildDrawerItem(icon: Icons.info_outline, title: 'About', onTap: () {}),
                  _buildDrawerItem(icon: Icons.phone_outlined, title: 'Contact', onTap: () {}),
                  _buildDrawerItem(icon: Icons.help_outline, title: 'FAQ', onTap: () {}),
                  _buildDrawerItem(icon: Icons.support_outlined, title: 'Help & Support', onTap: () {}),
                  const SizedBox(height: 8),
                  if (user != null)
                    _buildDrawerItem(icon: Icons.logout, title: 'Sign Out', onTap: () => _showSignOutDialog(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
      onTap: () {
        Get.back();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      horizontalTitleGap: 10,
      minVerticalPadding: 2,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        backgroundColor: Colors.white,
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
              Get.offAllNamed('/signin');
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}