import 'package:flutter/material.dart';

// Switch 있으면 Stateful 해야 눌렀을 때 계속 유지된다고 함
// Stateless로 하면 누른 손 떼자마자 돌아감 ㅋㅋ;;
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 설정 추가할 때 편하려고 map으로 제작
  final Map<String, List<String>> settings = {
    'Account': ['Change e-mail', 'Change Phone No.', 'Change Location'],
    'General': ['Set the unit in kg'],
    'Notification': ['알람 권한 허용/제거'],
    'Accessibility': ['접근성 Talkback', 'Font Size', 'Dark Mode'],
  };

  bool _isKgEnabled = false; // kg인지 lbs인지 체크할 때 쓸 거임
  String _fontSize = 'M'; // 기본 크기 M
  final double baseFontSize = 20.0; // 기본 크기 20 -> 나중에 쉽게 변경하려고 따로 설정함

  // S, M, L에 따라 폰트 크기 리턴
  double getFontSize() {
    switch (_fontSize) {
      case 'S':
        return baseFontSize * 0.8;
      case 'L':
        return baseFontSize * 1.2;
      case 'M':
      default:
        return baseFontSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: settings.entries.map((entry) {
          return SettingsSection(
            title: entry.key,
            children: entry.value.map((item) {
              if (item == 'Set the unit in kg') {
                return SettingsTile(
                  title: item,
                  fontSize: getFontSize(),
                  trailing: Switch(
                    value: _isKgEnabled,
                    activeColor: const Color(0xff29dead), // 스위치 On이면 초록색으로
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
                  fontSize: getFontSize(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['S', 'M', 'L'].map((size) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fontSize = size;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _fontSize == size ? Color(0xff29dead) : Colors.grey, // 초록, 회색으로
                          ),
                          child: Text(size),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return SettingsTile(
                  title: item,
                  fontSize: getFontSize(),
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

  const SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(), // 섹션 간 구분선 추가
      ],
    );
  }
}


class SettingsTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final double fontSize;

  const SettingsTile({
    required this.title,
    this.trailing,
    this.fontSize = 20.0, // 기본 폰트 20
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize),
      ),
      trailing: trailing,
    );
  }
}
