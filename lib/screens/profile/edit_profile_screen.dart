import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock/mock_data.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _studentNumberController;

  String? _selectedUniversity;
  String? _selectedCampus;

  @override
  void initState() {
    super.initState();
    // Load existing profile data
    final student = MockData.studentProfile;
    _nameController = TextEditingController(text: student.fullName);
    _phoneController = TextEditingController(text: student.phone);
    _emailController = TextEditingController(text: student.email);
    _studentNumberController = TextEditingController(text: student.studentNumber);
    _selectedUniversity = student.university;
    _selectedCampus = student.campusId; // Using campus name temporarily for UI if ID doesn't match
    
    // In a real app we'd map campusId to the actual campus name from the list
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _studentNumberController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // In a real app we would update state/backend here.
      // For now we just go back and show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!', style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: AppTypography.labelLarge.copyWith(color: AppColors.orangeBright),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                      ),
                      child: Center(
                        child: Text(
                          MockData.studentProfile.avatarInitials ?? 'BS',
                          style: AppTypography.displaySmall.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.border),
                        ),
                        child: Icon(Icons.camera_alt_rounded, size: 16, color: colors.textMid),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Info
              Text(
                'Personal Information',
                style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                colors: colors,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                colors: colors,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                colors: colors,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 32),

              // Academic Info
              Text(
                'Academic Information',
                style: AppTypography.titleMedium.copyWith(color: colors.textHigh),
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _studentNumberController,
                label: 'Student Number',
                icon: Icons.badge_outlined,
                colors: colors,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // University Dropdown
              _buildDropdownField(
                value: _selectedUniversity,
                label: 'University',
                icon: Icons.school_outlined,
                items: MockData.universities.map((u) => u['name'] as String).toList(),
                colors: colors,
                onChanged: (val) {
                  setState(() {
                    _selectedUniversity = val;
                    // Reset campus when university changes
                    _selectedCampus = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Campus Dropdown
              _buildDropdownField(
                value: _selectedCampus,
                label: 'Campus',
                icon: Icons.business_outlined,
                items: MockData.campuses.map((c) => c['name'] as String).toList(),
                colors: colors,
                onChanged: (val) {
                  setState(() => _selectedCampus = val);
                },
              ),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required HostelHopColors colors,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.bodyMedium.copyWith(color: colors.textHigh),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodySmall.copyWith(color: colors.textLow),
        prefixIcon: Icon(icon, size: 20, color: colors.textMid),
        filled: true,
        fillColor: colors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orangeBright),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required HostelHopColors colors,
    required void Function(String?) onChanged,
  }) {
    // Ensure value is in items, else set to null to avoid assert error
    final safeValue = items.contains(value) ? value : null;
    
    return DropdownButtonFormField<String>(
      initialValue: safeValue,
      icon: Icon(Icons.arrow_drop_down_rounded, color: colors.textMid),
      style: AppTypography.bodyMedium.copyWith(color: colors.textHigh),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodySmall.copyWith(color: colors.textLow),
        prefixIcon: Icon(icon, size: 20, color: colors.textMid),
        filled: true,
        fillColor: colors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.orangeBright),
        ),
      ),
      dropdownColor: colors.surfaceElevated,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
