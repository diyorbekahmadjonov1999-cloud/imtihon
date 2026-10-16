import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.admin;
  bool _obscurePassword = true;

  // Controllers
  final _adminLoginCtrl = TextEditingController(text: 'admin');
  final _adminPassCtrl = TextEditingController(text: '123456');

  final _teacherLoginCtrl = TextEditingController(text: 'vali');
  final _teacherPassCtrl = TextEditingController(text: '123456');

  final _studentLoginCtrl = TextEditingController(text: 'akmal');
  final _studentPassCtrl = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo & Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.code, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CODIAL',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Zamonaviy Taʼlim CRM Tizimi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Main Auth Card
              Container(
                width: 480,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tizimga Kirish',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Admin tomonidan taqdim etilgan login va parolni kiriting:',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),

                    // Role Selection Segment
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.scaffoldBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          _roleTab(
                            role: UserRole.admin,
                            icon: Icons.admin_panel_settings,
                            label: 'Admin',
                          ),
                          _roleTab(
                            role: UserRole.teacher,
                            icon: Icons.person,
                            label: 'Oʻqituvchi',
                          ),
                          _roleTab(
                            role: UserRole.student,
                            icon: Icons.school,
                            label: 'Oʻquvchi',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dynamic form based on selected role
                    if (_selectedRole == UserRole.admin) ...[
                      // Admin Login Form
                      const Text(
                        'Admin Hisobi',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _adminLoginCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Foydalanuvchi nomi (Login)',
                          hintText: 'admin',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _adminPassCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Maxfiy parol',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            tooltip: _obscurePassword ? 'Parolni koʻrsatish' : 'Parolni berkitish',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final err = crm.authenticateAndLogin(
                              role: UserRole.admin,
                              usernameOrPhone: _adminLoginCtrl.text,
                              password: _adminPassCtrl.text,
                            );
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(err), backgroundColor: AppTheme.danger),
                              );
                            }
                          },
                          child: const Text('Admin Paneliga Kirish'),
                        ),
                      ),
                    ] else if (_selectedRole == UserRole.teacher) ...[
                      // Teacher Login Form
                      const Text(
                        'Oʻqituvchi Hisobi',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _teacherLoginCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Login yoki Telefon raqam',
                          hintText: 'Masalan: vali yoki +998 90 123 45 67',
                          prefixIcon: Icon(Icons.person_pin_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _teacherPassCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Parol',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            tooltip: _obscurePassword ? 'Parolni koʻrsatish' : 'Parolni berkitish',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final err = crm.authenticateAndLogin(
                              role: UserRole.teacher,
                              usernameOrPhone: _teacherLoginCtrl.text,
                              password: _teacherPassCtrl.text,
                            );
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(err), backgroundColor: AppTheme.danger),
                              );
                            }
                          },
                          child: const Text('Oʻqituvchi Kabinetiga Kirish'),
                        ),
                      ),
                    ] else ...[
                      // Student Login Form
                      const Text(
                        'Oʻquvchi Hisobi',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _studentLoginCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Login yoki Telefon raqam',
                          hintText: 'Masalan: akmal yoki +998 94 456 78 90',
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _studentPassCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Parol',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            tooltip: _obscurePassword ? 'Parolni koʻrsatish' : 'Parolni berkitish',
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            final err = crm.authenticateAndLogin(
                              role: UserRole.student,
                              usernameOrPhone: _studentLoginCtrl.text,
                              password: _studentPassCtrl.text,
                            );
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(err), backgroundColor: AppTheme.danger),
                              );
                            }
                          },
                          child: const Text('Oʻquvchi Profiliga Kirish'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Quick Credentials Hint Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.vpn_key_rounded, size: 16, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Admin taqdim etgan sinov hisoblari:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _quickFillChip(
                                label: 'Admin (admin / 123456)',
                                onTap: () {
                                  setState(() {
                                    _selectedRole = UserRole.admin;
                                    _adminLoginCtrl.text = 'admin';
                                    _adminPassCtrl.text = '123456';
                                  });
                                },
                              ),
                              _quickFillChip(
                                label: 'Mentor Vali (vali / 123456)',
                                onTap: () {
                                  setState(() {
                                    _selectedRole = UserRole.teacher;
                                    _teacherLoginCtrl.text = 'vali';
                                    _teacherPassCtrl.text = '123456';
                                  });
                                },
                              ),
                              _quickFillChip(
                                label: 'Talaba Akmal (akmal / 123456)',
                                onTap: () {
                                  setState(() {
                                    _selectedRole = UserRole.student;
                                    _studentLoginCtrl.text = 'akmal';
                                    _studentPassCtrl.text = '123456';
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Codial CRM © 2026 • Barcha huquqlar himoyalangan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickFillChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _roleTab({
    required UserRole role,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
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
