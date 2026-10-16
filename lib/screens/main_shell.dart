import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_overview.dart';
import 'courses_screen.dart';
import 'teachers_screen.dart';
import 'groups_screen.dart';
import 'students_screen.dart';
import 'attendance_screen.dart';
import 'teacher_groups_screen.dart';
import 'student_profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: Row(
        children: [
          // Left Sidebar
          _buildSidebar(context, crm),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                _buildTopBar(context, crm),

                // Active Page Content
                Expanded(
                  child: _buildCurrentScreen(crm),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(CrmProvider crm) {
    switch (crm.currentRole) {
      case UserRole.admin:
        switch (crm.selectedNavIndex) {
          case 0:
            return const DashboardOverview();
          case 1:
            return const CoursesScreen();
          case 2:
            return const TeachersScreen();
          case 3:
            return const GroupsScreen();
          case 4:
            return const StudentsScreen();
          case 5:
            return const AttendanceScreen();
          default:
            return const DashboardOverview();
        }

      case UserRole.teacher:
        switch (crm.selectedNavIndex) {
          case 0:
            return const TeacherGroupsScreen();
          case 1:
            return const AttendanceScreen();
          default:
            return const TeacherGroupsScreen();
        }

      case UserRole.student:
        return const StudentProfileScreen();
    }
  }

  Widget _buildSidebar(BuildContext context, CrmProvider crm) {
    return Container(
      width: 260,
      color: AppTheme.sidebarBg,
      child: Column(
        children: [
          // Brand Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.code, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CODIAL',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CRM Tizimi',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 16),

          // Menu Items based on Role
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                if (crm.currentRole == UserRole.admin) ...[
                  _sidebarSectionHeader('ADMIN BOSHQARUVI'),
                  _sidebarItem(
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    label: 'Umumiy Koʻrinish',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 1,
                    icon: Icons.menu_book_outlined,
                    label: 'Kurslar',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 2,
                    icon: Icons.person_outline,
                    label: 'Oʻqituvchilar',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 3,
                    icon: Icons.groups_outlined,
                    label: 'Guruhlar',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 4,
                    icon: Icons.school_outlined,
                    label: 'Oʻquvchilar',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 5,
                    icon: Icons.fact_check_outlined,
                    label: 'Davomat',
                    crm: crm,
                  ),
                ] else if (crm.currentRole == UserRole.teacher) ...[
                  _sidebarSectionHeader('OʻQITUVCHI PANELI'),
                  _sidebarItem(
                    index: 0,
                    icon: Icons.group_work_outlined,
                    label: 'Guruhlarim & Oʻquvchilar',
                    crm: crm,
                  ),
                  _sidebarItem(
                    index: 1,
                    icon: Icons.fact_check_outlined,
                    label: 'Davomat Olish',
                    crm: crm,
                  ),
                ] else ...[
                  _sidebarSectionHeader('OʻQUVCHI PANELI'),
                  _sidebarItem(
                    index: 0,
                    icon: Icons.person_pin_outlined,
                    label: 'Shaxsiy Profilim',
                    crm: crm,
                  ),
                ],
              ],
            ),
          ),

          // Bottom Role Badge
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primary,
                  child: Icon(
                    crm.currentRole == UserRole.admin
                        ? Icons.admin_panel_settings
                        : (crm.currentRole == UserRole.teacher ? Icons.person : Icons.school),
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crm.currentRole == UserRole.admin
                            ? 'Admin Paneli'
                            : (crm.currentRole == UserRole.teacher ? 'Oʻqituvchi Kabineti' : 'Oʻquvchi Kabineti'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Codial CRM v1.0',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 12, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _sidebarItem({
    required int index,
    required IconData icon,
    required String label,
    required CrmProvider crm,
  }) {
    final isSelected = crm.selectedNavIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => crm.setNavIndex(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CrmProvider crm) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // Role description tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  crm.currentRole == UserRole.admin
                      ? Icons.shield
                      : (crm.currentRole == UserRole.teacher ? Icons.cast_for_education : Icons.badge),
                  size: 16,
                  color: AppTheme.primaryDark,
                ),
                const SizedBox(width: 6),
                Text(
                  'Rejim: ${crm.currentRole == UserRole.admin ? "Admin" : (crm.currentRole == UserRole.teacher ? "Oʻqituvchi" : "Oʻquvchi")}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),



          // User Profile avatar
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primary,
                child: Text(
                  crm.currentRole == UserRole.admin
                      ? 'A'
                      : (crm.currentRole == UserRole.teacher ? 'V' : 'A'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crm.currentRole == UserRole.admin
                        ? 'Admin (Boshqaruvchi)'
                        : (crm.currentRole == UserRole.teacher
                            ? (crm.currentTeacher?.fullName ?? 'Vali Aliyev')
                            : (crm.currentStudent?.fullName ?? 'Akmalbek Fayz.')),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    crm.currentRole == UserRole.admin
                        ? 'Toʻliq huquqli'
                        : (crm.currentRole == UserRole.teacher ? 'Flutter Mentori' : 'Flutter-101 talabasi'),
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 20, color: AppTheme.danger),
                  tooltip: 'Tizimdan chiqish',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dCtx) => AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        titlePadding: const EdgeInsets.fromLTRB(24, 20, 20, 12),
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.logout_rounded, color: AppTheme.danger, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text('Tizimdan chiqish', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        content: const Text(
                          'Haqiqatan ham kabinetdan chiqmoqchimisiz? Boshqa profilga kirish uchun login va parol talab qilinadi.',
                          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                        ),
                        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        actions: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(dCtx),
                            child: const Text('Bekor qilish'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.danger,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(dCtx);
                              crm.logout();
                            },
                            child: const Text('Chiqish'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
