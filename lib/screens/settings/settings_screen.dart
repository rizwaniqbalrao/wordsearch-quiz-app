import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordsearch_quiz/providers/stats_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4f46e5), Color(0xFF7c3aed)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionHeader(title: 'Gameplay'),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.timer_rounded,
                      iconColor: const Color(0xFF6366f1),
                      title: 'Show Timer',
                      subtitle: 'Display elapsed time during gameplay',
                      value: stats.timerVisible,
                      onChanged: stats.setTimerVisible,
                    ),
                    const Divider(height: 1),
                    _SwitchTile(
                      icon: Icons.vibration_rounded,
                      iconColor: const Color(0xFF8b5cf6),
                      title: 'Vibration',
                      subtitle: 'Haptic feedback when finding words',
                      value: stats.vibrationEnabled,
                      onChanged: stats.setVibrationEnabled,
                    ),
                    const Divider(height: 1),
                    _SwitchTile(
                      icon: Icons.volume_up_rounded,
                      iconColor: const Color(0xFF06b6d4),
                      title: 'Sound Effects',
                      subtitle: 'Audio feedback during gameplay',
                      value: stats.soundEnabled,
                      onChanged: stats.setSoundEnabled,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionHeader(title: 'Appearance'),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: const Color(0xFF374151),
                      title: 'Dark Mode',
                      subtitle: 'Use dark theme throughout the app',
                      value: stats.darkMode,
                      onChanged: stats.setDarkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionHeader(title: 'About'),
                _SettingsCard(
                  children: [
                    _InfoTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: const Color(0xFF6366f1),
                      title: 'Version',
                      trailing: '1.0.0',
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      icon: Icons.grid_view_rounded,
                      iconColor: const Color(0xFF22c55e),
                      title: 'Total Puzzles',
                      trailing: '1,918',
                    ),
                    const Divider(height: 1),
                    _InfoTile(
                      icon: Icons.category_rounded,
                      iconColor: const Color(0xFFf59e0b),
                      title: 'Categories',
                      trailing: '25',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionHeader(title: 'Legal'),
                _SettingsCard(
                  children: [
                    _NavTile(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: const Color(0xFF6366f1),
                      title: 'Privacy Policy',
                      onTap: () => _showLegalDialog(
                        context,
                        'Privacy Policy',
                        _privacyPolicyText,
                      ),
                    ),
                    const Divider(height: 1),
                    _NavTile(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFF8b5cf6),
                      title: 'Terms of Service',
                      onTap: () => _showLegalDialog(
                        context,
                        'Terms of Service',
                        _termsOfServiceText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'WordSearchQuiz © 2025\nAll 1,918 puzzles · Play offline · Free',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static const _privacyPolicyText = '''
Privacy Policy for WordSearchQuiz
Last Updated: January 2025

1. Information We Collect
   We do NOT collect personal information. Anonymous usage data may be stored locally for app improvement. All game progress is stored only on your device.

2. How We Use Information
   App usage data is used solely to improve the gameplay experience. We do not share data with third parties.

3. Data Storage
   All game data is stored locally on your device. No cloud synchronization. Data is deleted when the app is uninstalled.

4. Children's Privacy
   This app is suitable for ages 4+. We do not knowingly collect data from children.

5. Contact
   Website: https://www.wordsearchquiz.com
''';

  static const _termsOfServiceText = '''
Terms of Service for WordSearchQuiz
Last Updated: January 2025

1. Acceptance of Terms
   By using this app, you agree to these terms.

2. License to Use App
   You are granted a non-exclusive, non-transferable license to use the app for personal, non-commercial purposes.

3. User Conduct
   You agree not to reverse engineer, copy, or redistribute the app or its content.

4. Intellectual Property
   All puzzles, content, and code are owned by WordSearchQuiz.

5. Disclaimer of Warranties
   The app is provided "as is" without warranties of any kind.

6. Limitation of Liability
   WordSearchQuiz shall not be liable for any indirect or incidental damages.

7. Contact
   Website: https://www.wordsearchquiz.com
''';
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final Future<void> Function(bool) onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF6366f1),
        activeTrackColor: const Color(0xFF6366f1).withValues(alpha: 0.4),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String trailing;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: Text(
        trailing,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
