import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  // 🔐 Simple Hash Function
  String _simpleHash(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = (hash * 31 + text.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.toString();
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill all fields');
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showSnackBar('Please enter a valid email');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

    if (_isLogin) {
      // Login Logic
      final savedEmail = prefs.getString('userEmail');
      final savedHashedPassword = prefs.getString('hashedPassword');

      if (savedEmail == _emailController.text.trim()) {
        final inputHashed = _simpleHash(_passwordController.text);
        
        if (savedHashedPassword == inputHashed) {
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userEmail', _emailController.text.trim());
          _showSnackBar('Login successful! ✅');
          if (mounted) {
            context.go('/home');
          }
        } else {
          _showSnackBar('Invalid email or password ❌');
        }
      } else {
        _showSnackBar('Invalid email or password ❌');
      }
    } else {
      // Sign Up Logic
      final hashedPassword = _simpleHash(_passwordController.text);
      
      await prefs.setString('userEmail', _emailController.text.trim());
      await prefs.setString('hashedPassword', hashedPassword);
      await prefs.setString('userName', _nameController.text.trim());
      await prefs.setBool('isLoggedIn', true);
      
      _showSnackBar('Account created successfully! ✅');
      if (mounted) {
        context.go('/home');
      }
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('✅') 
            ? AppColors.primary
            : AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleLoginMode() {
    setState(() {
      _isLogin = !_isLogin;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(  // ✅ FIXED: Scrollable
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Sajilo Yatra',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your guide to Kathmandu Valley',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceLight,
                ),
              ),
              const SizedBox(height: 40),

              // Welcome
              Text(
                _isLogin ? 'Welcome Back' : 'Create Account',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin ? 'Login to continue' : 'Sign up to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceLight,
                ),
              ),
              const SizedBox(height: 30),

              // Name (Sign Up only)
              if (!_isLogin)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 16),

              // Email
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.outline.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.outline.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password (min 6 chars)',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.outline,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Forgot Password
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _showSnackBar('Reset link sent to your email');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Login/Signup Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    style: TextStyle(
                      color: AppColors.onSurfaceLight,
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleLoginMode,
                    child: Text(
                      _isLogin ? 'Sign Up' : 'Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.outline.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: AppColors.onSurfaceLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.outline.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Guest
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}