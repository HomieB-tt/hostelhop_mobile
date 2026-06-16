import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/utils/snackbar_utils.dart';
import '../../data/providers/data_providers.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../widgets/otp_verification_sheet.dart';


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

  late TextEditingController _campusController;

  String? _selectedCampusName;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _studentNumberController = TextEditingController();
    _campusController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _studentNumberController.dispose();
    _campusController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(String userId) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCampusName == null || _selectedCampusName!.isEmpty) {
        SnackBarUtils.showError(context, 'Please search and select your university/campus');
        return;
      }

      try {
        await ref.read(profileRepositoryProvider).updateProfile(
              userId: userId,
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              studentNumber: _studentNumberController.text.trim(),
              campusId: _selectedCampusName,
            );
        // ignore: unused_result
        ref.refresh(currentProfileProvider);
        if (mounted) {
          SnackBarUtils.showSuccess(context, 'Profile updated successfully!');
          context.pop();
        }
      } catch (e) {
        if (mounted) SnackBarUtils.showError(context, 'Failed to update profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hhColors;
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return profileAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: Text('Edit Profile', style: AppTypography.titleLarge.copyWith(color: colors.textHigh))),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: Text('Edit Profile', style: AppTypography.titleLarge.copyWith(color: colors.textHigh))),
        body: const Center(child: Text('Failed to load profile')),
      ),
      data: (student) {
        if (!_isInitialized && student != null) {
          _nameController.text = student.fullName;
          _phoneController.text = student.phone;
          _emailController.text = student.email ?? '';
          _studentNumberController.text = student.studentNumber ?? '';
          _selectedCampusName = student.campusId;
          _campusController.text = student.campusId ?? '';
          _isInitialized = true;
        }

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: AppTypography.titleLarge.copyWith(color: colors.textHigh),
            ),
            actions: [
              TextButton(
                onPressed: () => _saveProfile(user.id),
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
                          student?.avatarInitials ?? 'BS',
                          style: AppTypography.displaySmall.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          SnackBarUtils.showError(context, 'Camera functionality not yet implemented');
                        },
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
              if (student != null && !student.isPhoneConfirmed) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    final confirmed = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => OTPVerificationSheet(phoneNumber: student.phone),
                    );
                    if (confirmed == true) {
                      // ignore: unused_result
                      ref.refresh(currentProfileProvider);
                    }
                  },
                  child: const Text('Confirm Phone Number'),
                ),
              ],
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
                label: 'Student Number (Optional)',
                icon: Icons.badge_outlined,
                colors: colors,
              ),
              const SizedBox(height: 16),
              // University / Campus AutoComplete
              Text(
                'University / Campus',
                style: AppTypography.bodySmall.copyWith(color: colors.textLow),
              ),
              const SizedBox(height: 8),
              GooglePlaceAutoCompleteTextField(
                textEditingController: _campusController,
                googleAPIKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
                inputDecoration: InputDecoration(
                  hintText: 'Search university or campus',
                  prefixIcon: Icon(Icons.school_outlined, size: 20, color: colors.textMid),
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
                debounceTime: 800,
                countries: const ["ug"],
                isLatLngRequired: false,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  _selectedCampusName = prediction.description;
                },
                itemClick: (Prediction prediction) {
                  _campusController.text = prediction.description ?? '';
                  _campusController.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0));
                  _selectedCampusName = prediction.description;
                },
                seperatedBuilder: const Divider(),
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: colors.textLow, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            prediction.description ?? "",
                            style: AppTypography.bodyMedium.copyWith(color: colors.textHigh),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
      },
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

}
