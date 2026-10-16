import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();
    final student = crm.currentStudent;

    if (student == null) {
      return const Center(child: Text('Oʻquvchi maʼlumotlari topilmadi'));
    }

    final group = crm.getGroupById(student.groupId);
    final course = crm.getCourseById(student.courseId);
    final teacher = group != null ? crm.getTeacherById(group.teacherId) : null;
    final stats = crm.getStudentAttendanceStats(student.id);

    final double rate = (stats['rate'] as num?)?.toDouble() ?? 100.0;
    final int presentCount = stats['present'] ?? 0;
    final int absentCount = stats['absent'] ?? 0;
    final int totalCount = stats['total'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Shaxsiy Profil (Oʻquvchi Kabineti)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Shaxsiy maʼlumotlaringiz, dars jadvalingiz va davomat monitoringi',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          // Main Profile & Course Card (2 columns on wide screens)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Student Details Card
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppTheme.primaryLight,
                        child: Text(
                          student.fullName.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        student.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          student.status,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.success,
                          ),
                        ),
                      ),
                      const Divider(height: 32),
                      _profileField(Icons.phone_outlined, 'Telefon raqam', student.phone),
                      const SizedBox(height: 12),
                      _profileField(Icons.email_outlined, 'Email', student.email),
                      const SizedBox(height: 12),
                      _profileField(Icons.family_restroom_outlined, 'Ota-onasi raqami', student.parentPhone),
                      const SizedBox(height: 12),
                      _profileField(
                        Icons.calendar_today_outlined,
                        'Roʻyxatga olingan',
                        DateFormat('dd MMMM yyyy').format(student.joinedDate),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Right Column: Course, Group and Attendance Progress
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Course & Group Details
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.school, color: AppTheme.primary, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course?.name ?? 'Kurs maʼlumoti',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Guruh: ${group?.name ?? "-"}',
                                      style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: _groupDetailItem('Dars kunlari', group?.days ?? '-'),
                              ),
                              Expanded(
                                child: _groupDetailItem('Dars vaqti', group?.time ?? '-'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _groupDetailItem('Oʻqituvchi (Mentor)', teacher?.fullName ?? '-'),
                              ),
                              Expanded(
                                child: _groupDetailItem('Xona / Auditoriya', group?.room ?? '-'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Attendance Statistics Card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Mening Davomatim',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${rate.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: rate >= 80 ? AppTheme.success : AppTheme.danger,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: rate / 100,
                              minHeight: 12,
                              backgroundColor: AppTheme.scaffoldBg,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                rate >= 80 ? AppTheme.success : AppTheme.warning,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _statCol('Qatnashgan darslar', '$presentCount ta', AppTheme.success),
                              _statCol('Qoldirilgan darslar', '$absentCount ta', AppTheme.danger),
                              _statCol('Jami darslar', '$totalCount ta', AppTheme.textPrimary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileField(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textMuted),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _groupDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _statCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
