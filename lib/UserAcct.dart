import 'package:flutter/material.dart';

import 'AppStore.dart';

class UserAcctScreen extends StatefulWidget {
  const UserAcctScreen({super.key});

  @override
  State<UserAcctScreen> createState() => _UserAcctScreenState();
}

class _UserAcctScreenState extends State<UserAcctScreen> {
  final _profileFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final account = AppStore.instance.currentAccount;
    _usernameController.text = account?.username ?? '';
    _emailController.text = account?.email ?? '';
    _phoneController.text = account?.phone ?? '';
    _addressController.text = account?.address ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_profileFormKey.currentState!.validate()) return;
    final error = AppStore.instance.updateProfile(
      username: _usernameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated.')));
  }

  void _cancelEditing() {
    _loadProfile();
    setState(() => _isEditing = false);
  }

  void _logOut() {
    AppStore.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _changePassword() async {
    final formKey = GlobalKey<FormState>();
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    final changed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current password',
                  ),
                  validator: (value) =>
                      value != AppStore.instance.currentAccount?.password
                      ? 'Current password is incorrect.'
                      : null,
                ),
                TextFormField(
                  controller: newController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Use at least 6 characters.';
                    }
                    if (value == currentController.text) {
                      return 'Choose a different password.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm new password',
                  ),
                  validator: (value) => value != newController.text
                      ? 'Passwords do not match.'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final success = AppStore.instance.changePassword(
                currentPassword: currentController.text,
                newPassword: newController.text,
              );
              Navigator.pop(dialogContext, success);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF29191),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Password'),
          ),
        ],
      ),
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (changed == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password changed.')));
    }
  }

  Widget _profileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (!_isEditing) return null;
          if (label == 'Username' &&
              (value == null || value.trim().length < 3)) {
            return 'Use at least 3 characters.';
          }
          if (label == 'Email address' &&
              (value == null ||
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim()))) {
            return 'Enter a valid email address.';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: controller.text.isEmpty ? 'Not set' : null,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCFBFA),
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: const Color(0xFFF29191),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFFAD4D4),
                  child: Icon(Icons.person, size: 42, color: Color(0xFFF29191)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF29191),
                  ),
                ),
                const SizedBox(height: 22),
                _profileField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person_outline,
                ),
                _profileField(
                  controller: _emailController,
                  label: 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                _profileField(
                  controller: _phoneController,
                  label: 'Phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                _profileField(
                  controller: _addressController,
                  label: 'Delivery address',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                ),
                if (_isEditing)
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _cancelEditing,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF29191),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isEditing = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF29191),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _changePassword,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFF29191),
                            side: const BorderSide(color: Color(0xFFF29191)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Change Password'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _logOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
