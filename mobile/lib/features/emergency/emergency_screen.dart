import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============================================
              // SUBTITLE - Centered with light blue transparent box
              // =============================================
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Tap phone icon to open dialer',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // =============================================
              // POLICE SECTION
              // =============================================
              const Text(
                'Police',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmergencyItem(
                      title: 'Police Control Room',
                      number: '100',
                    ),
                    const Divider(height: 16),
                    _buildEmergencyItem(
                      title: 'Traffic Police',
                      number: '103',
                    ),
                    const Divider(height: 16),
                    _buildEmergencyItem(
                      title: 'Tourist Police',
                      number: '01-4247041',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =============================================
              // MEDICAL SECTION
              // =============================================
              const Text(
                'Medical',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmergencyItem(
                      title: 'Ambulance',
                      number: '102',
                    ),
                    const Divider(height: 16),
                    _buildEmergencyItem(
                      title: 'Red Cross Ambulance',
                      number: '01-4228094',
                    ),
                    const Divider(height: 16),
                    _buildEmergencyItem(
                      title: 'Bir Hospital',
                      number: '01-4221119',
                    ),
                    const Divider(height: 16),
                    _buildEmergencyItem(
                      title: 'Patan Hospital',
                      number: '01-5522266',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyItem({
    required String title,
    required String number,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,  // ✅ Bold
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.blue,  // ✅ Blue (not red)
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            final url = 'tel:$number';
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          child: const Icon(
            Icons.phone,
            color: Colors.blue,  // ✅ Blue
            size: 20,
          ),
        ),
      ],
    );
  }
}