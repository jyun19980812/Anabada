import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/settings/font_size_provider.dart';
import '/settings/edit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, List<String>> settings = {
    'Account': ['Change Profile'],
    'General': ['Set the unit in kg'],
    'Notification': ['알람 권한 허용/제거'],
    'Accessibility': ['접근성 Talkback', 'Font Size', 'Dark Mode'],
  };

  bool _isKgEnabled = false;

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: settings.entries.map((entry) {
          return SettingsSection(
            title: entry.key,
            fontSize: baseFontSize,
            getFontSize: fontSizeProvider.getFontSize,
            children: entry.value.map((item) {
              if (item == 'Set the unit in kg') {
                return SettingsTile(
                  title: item,
                  fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  trailing: Switch(
                    value: _isKgEnabled,
                    activeColor: const Color(0xff29dead),
                    onChanged: (bool value) {
                      setState(() {
                        _isKgEnabled = value;
                      });
                    },
                  ),
                );
              } else if (item == 'Font Size') {
                return SettingsTile(
                  title: item,
                  fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['S', 'M', 'L'].map((size) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            fontSizeProvider.setFontSize(size);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fontSizeProvider.fontSize == size ? const Color(0xff29dead) : Colors.grey,
                          ),
                          child: Text(size),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else if (item == 'Change Profile'){
                return SettingsTile(
                  title: item,
                  fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                );
              }
              else {
                return SettingsTile(
                  title: item,
                  fontSize: fontSizeProvider.getFontSize(baseFontSize),
                );
              }
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double fontSize;
  final double Function(double) getFontSize;

  const SettingsSection({super.key, 
    required this.title,
    required this.children,
    required this.fontSize,
    required this.getFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: getFontSize(fontSize),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final double fontSize;
  final VoidCallback? onTap;

  const SettingsTile({super.key, 
    required this.title,
    this.trailing,
    this.fontSize = 20.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
