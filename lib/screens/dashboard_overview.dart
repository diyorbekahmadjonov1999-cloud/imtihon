import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();
    final studentsCount = crm.students.length;
    final groupsCount = crm.groups.length;
    final teachersCount = crm.teachers.length;
    final coursesCount = crm.courses.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Quick Action Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Boshqaruv Paneli (Admin)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Codial taʼlim markazi faoliyati va asosiy koʻrsatkichlari',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => crm.setNavIndex(5), // Navigate to attendance (+ D)
                icon: const Icon(Icons.fact_check_outlined, size: 18),
                label: const Text('Bugungi Davomat'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPI Stat Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100 ? 4 : (constraints.maxWidth > 700 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                children: [
                  StatCard(
                    title: "Jami Oʻquvchilar",
                    value: '$studentsCount ta',
                    icon: Icons.people_alt_outlined,
                    color: AppTheme.info,
                    subtitle: 'Barcha guruhlarda',
                  ),
                  StatCard(
                    title: "Faol Guruhlar",
                    value: '$groupsCount ta',
                    icon: Icons.groups_outlined,
                    color: AppTheme.success,
                    subtitle: 'Darslar jadvalida',
                  ),
                  StatCard(
                    title: "Oʻqituvchilar",
                    value: '$teachersCount nafar',
                    icon: Icons.person_outline,
                    color: AppTheme.warning,
                    subtitle: 'Mentorlar tarkibi',
                  ),
                  StatCard(
                    title: "Yoʻnalishlar",
                    value: '$coursesCount ta',
                    icon: Icons.menu_book_outlined,
                    color: AppTheme.primary,
                    subtitle: 'Dasturlash & Dizayn',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Active Groups and Courses section
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final groupsCard = Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Faol Guruhlar roʻyxati',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => crm.setNavIndex(3), // Navigate to Groups
                          child: const Text('Barchasini koʻrish →'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: AppTheme.scaffoldBg,
                          ),
                          children: [
                            _tableHeader('Guruh'),
                            _tableHeader('Kurs'),
                            _tableHeader("O'qituvchi"),
                            _tableHeader("O'quvchilar"),
                          ],
                        ),
                        ...crm.groups.take(4).map((group) {
                          final course = crm.getCourseById(group.courseId);
                          final teacher = crm.getTeacherById(group.teacherId);
                          final count = crm.getStudentsByGroup(group.id).length;

                          return TableRow(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.divider),
                              ),
                            ),
                            children: [
                              _tableCell(group.name, isBold: true),
                              _tableCell(course?.name ?? '-'),
                              _tableCell(teacher?.fullName ?? '-'),
                              _tableCell('$count nafar'),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              );

              final coursesCard = Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Yoʻnalishlar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => crm.setNavIndex(1), // Navigate to Courses
                          child: const Text('Barchasi →'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...crm.courses.map((course) {
                      final groupsInCourse = crm.getGroupsByCourse(course.id).length;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.scaffoldBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(course.colorHex),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${course.durationMonths} oy • ${course.price.toStringAsFixed(0)} soʻm',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Text(
                                '$groupsInCourse guruh',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: groupsCard),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: coursesCard),
                  ],
                );
              } else {
                return Column(
                  children: [
                    groupsCard,
                    const SizedBox(height: 20),
                    coursesCard,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  static Widget _tableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  static Widget _tableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
