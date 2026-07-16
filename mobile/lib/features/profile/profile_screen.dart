import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _userEmail = prefs.getString('userEmail') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============================================
            // PROFILE HEADER
            // =============================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isLoggedIn ? Icons.person : Icons.person_outline,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoggedIn ? _userEmail.split('@').first : 'Guest User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLoggedIn ? _userEmail : 'guest@sajiloyatra.com',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isLoggedIn
                                ? Colors.green.withOpacity(0.3)
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isLoggedIn ? '🟢 Active' : '🟡 Guest',
                            style: TextStyle(
                              fontSize: 11,
                              color: _isLoggedIn ? Colors.green.shade300 : Colors.orange.shade300,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // =============================================
            // ACCOUNT SECTION
            // =============================================
            const Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            if (!_isLoggedIn) ...[
              _buildMenuItem(
                icon: Icons.login,
                title: 'Sign In',
                subtitle: 'Login to your account',
                onTap: () {
                  context.push('/login');
                },
              ),
              _buildMenuItem(
                icon: Icons.person_add,
                title: 'Create Account',
                subtitle: 'Sign up for free',
                onTap: () {
                  context.push('/login');
                },
              ),
            ] else ...[
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: _logout,
                color: Colors.red,
              ),
            ],

            const SizedBox(height: 24),

            // =============================================
            // APP SECTION
            // =============================================
            const Text(
              'APP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.outline,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            _buildMenuItem(
              icon: Icons.bookmark,
              title: 'Saved Plans',
              subtitle: 'View your saved routes and places',
              onTap: () {
                context.push('/saved');
              },
            ),
            _buildMenuItem(
              icon: Icons.emergency,
              title: 'Emergency Contacts',
              subtitle: 'Quick access to emergency numbers',
              onTap: () {
                context.push('/emergency');
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Version 1.0.0',
              onTap: () {
                _showAboutDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // =============================================
            // VERSION
            // =============================================
            Center(
              child: Text(
                'Sajilo Yatra v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color ?? AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color ?? Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceLight,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.outline,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('About Sajilo Yatra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🚌 Sajilo Yatra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your guide to Kathmandu Valley',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceLight,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 4),
            Text(
              'Made with ❤️ for Nepal',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}