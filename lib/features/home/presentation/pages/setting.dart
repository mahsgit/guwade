// lib/features/profile/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _darkModeEnabled = false;
  double _textSize = 1.0; // 1.0 = normal, 0.8 = small, 1.2 = large

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('App Settings'),
          _buildSettingSwitch(
            'Notifications',
            'Receive notifications about new content',
            _notificationsEnabled,
            (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSettingSwitch(
            'Sound Effects',
            'Play sounds when interacting with the app',
            _soundEnabled,
            (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          _buildSettingSwitch(
            'Dark Mode',
            'Use dark theme for the app',
            _darkModeEnabled,
            (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          
          _buildSectionHeader('Reading Settings'),
          _buildTextSizeSelector(),
          
          _buildSectionHeader('Account Settings'),
          _buildSettingItem(
            'Change Password',
            'Update your account password',
            Icons.lock_outline,
            () {},
          ),
          _buildSettingItem(
            'Linked Accounts',
            'Manage connected social accounts',
            Icons.link,
            () {},
          ),
          
          _buildSectionHeader('About'),
          _buildSettingItem(
            'Version',
            'App version 1.0.0',
            Icons.info_outline,
            () {},
            showArrow: false,
          ),
          _buildSettingItem(
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description_outlined,
            () {},
          ),
          _buildSettingItem(
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip_outlined,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool showArrow = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: showArrow ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  Widget _buildTextSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          title: Text('Text Size'),
          subtitle: Text('Adjust the size of text in stories'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('A', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Slider(
                  value: _textSize,
                  min: 0.8,
                  max: 1.2,
                  divisions: 2,
                  label: _getTextSizeLabel(),
                  onChanged: (value) {
                    setState(() {
                      _textSize = value;
                    });
                  },
                ),
              ),
              const Text('A', style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ],
    );
  }

  String _getTextSizeLabel() {
    if (_textSize <= 0.8) return 'Small';
    if (_textSize <= 1.0) return 'Medium';
    return 'Large';
  }
}