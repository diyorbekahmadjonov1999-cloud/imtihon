import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  void _showQuickAddCourseDialog(BuildContext context, Function(String newCourseId) onCreated) {
    final nameCtrl = TextEditingController();
    final durationCtrl = TextEditingController(text: '6');
    final priceCtrl = TextEditingController(text: '1500000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 16, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_box, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Yangi Yoʻnalish Qoʻshish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Yoʻnalish nomi', hintText: 'Masalan: Go Backend'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Davomiyligi', suffixText: 'oy'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Oylik toʻlov', suffixText: 'soʻm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Bekor qilish')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final newId = 'c_${DateTime.now().millisecondsSinceEpoch}';
              final newCourse = Course(
                id: newId,
                name: nameCtrl.text.trim(),
                description: '${nameCtrl.text.trim()} kursi',
                durationMonths: int.tryParse(durationCtrl.text) ?? 6,
                price: double.tryParse(priceCtrl.text) ?? 1500000,
                colorHex: 0xFFDC2626,
              );
              context.read<CrmProvider>().addCourse(newCourse);
              Navigator.pop(ctx);
              onCreated(newId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${newCourse.name}" yoʻnalishi qoʻshildi!'), backgroundColor: AppTheme.success),
              );
            },
            child: const Text('Qoʻshish'),
          ),
        ],
      ),
    );
  }

  void _showAddEditTeacherDialog(BuildContext context, [Teacher? existing]) {
    final crm = context.read<CrmProvider>();
    final nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '+998 ');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final expCtrl = TextEditingController(text: existing?.experience ?? '3 yil');
    final loginCtrl = TextEditingController(
      text: existing?.login ?? (existing != null ? existing.fullName.toLowerCase().split(' ').first : ''),
    );
    final passCtrl = TextEditingController(text: existing?.password ?? '123456');
    String selectedCourseId = existing?.courseId ?? (crm.courses.isNotEmpty ? crm.courses.first.id : '');

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_add_alt_1, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? "Oʻqituvchi Qoʻshish" : "Oʻqituvchini Tahrirlash",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Mentor maʼlumotlarini kiriting va yoʻnalishini belgilang",
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(dialogCtx),
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Toʻliq ismi (F.I.SH)",
                      hintText: "Masalan: Vali Aliyev",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (val) {
                      if (existing == null && loginCtrl.text.isEmpty) {
                        final p = val.trim().toLowerCase().split(' ').first;
                        setDialogState(() => loginCtrl.text = p);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Telefon raqam',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: expCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Tajribasi',
                            hintText: '3 yil',
                            prefixIcon: Icon(Icons.history_edu_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Elektron pochta (Email)',
                      hintText: 'vali@codial.uz',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          menuMaxHeight: 260,
                          value: selectedCourseId.isNotEmpty ? selectedCourseId : null,
                          decoration: const InputDecoration(
                            labelText: "Yoʻnalishi (Mutaxassislik kursi)",
                            prefixIcon: Icon(Icons.menu_book_outlined),
                          ),
                          items: crm.courses.map((course) {
                            return DropdownMenuItem(
                              value: course.id,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Color(course.colorHex),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(course.name, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedCourseId = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Tooltip(
                        message: 'Yangi yoʻnalish qoʻshish',
                        child: InkWell(
                          onTap: () => _showQuickAddCourseDialog(context, (newId) {
                            setDialogState(() => selectedCourseId = newId);
                          }),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 18, color: AppTheme.primaryDark),
                                SizedBox(width: 4),
                                Text('Yangi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Admin taqdim etadigan Login & Parol
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.vpn_key_rounded, size: 16, color: AppTheme.primary),
                                SizedBox(width: 8),
                                Text(
                                  'Kirish Maʼlumotlari (Admin taqdim etadi)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                              icon: const Icon(Icons.auto_fix_high, size: 14),
                              label: const Text('Generatsiya', style: TextStyle(fontSize: 12)),
                              onPressed: () {
                                final base = nameCtrl.text.trim().toLowerCase().split(' ').first;
                                final genLogin = base.isNotEmpty ? base : 't_${DateTime.now().millisecondsSinceEpoch % 1000}';
                                setDialogState(() {
                                  loginCtrl.text = genLogin;
                                  passCtrl.text = '123456';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: loginCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Login (Foydalanuvchi nomi)',
                                  hintText: 'vali',
                                  prefixIcon: Icon(Icons.account_circle_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: passCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Maxfiy Parol',
                                  hintText: '123456',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check, size: 18),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;

                final teacher = Teacher(
                  id: existing?.id ?? 't_${DateTime.now().millisecondsSinceEpoch}',
                  fullName: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  courseId: selectedCourseId,
                  experience: expCtrl.text.trim(),
                  login: loginCtrl.text.trim().isNotEmpty
                      ? loginCtrl.text.trim()
                      : nameCtrl.text.trim().toLowerCase().split(' ').first,
                  password: passCtrl.text.trim().isNotEmpty ? passCtrl.text.trim() : '123456',
                );

                if (existing == null) {
                  crm.addTeacher(teacher);
                } else {
                  crm.updateTeacher(teacher);
                }

                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null ? 'Oʻqituvchi muvaffaqiyatli qoʻshildi!' : 'Maʼlumot yangilandi!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              label: Text(existing == null ? 'Qoʻshish' : 'Saqlash'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Oʻqituvchilar va Mentorlar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Markaz oʻqituvchilari, ularning yoʻnalishi va biriktirilgan guruhlari',
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditTeacherDialog(context),
                icon: const Icon(Icons.person_add_alt_1, size: 20),
                label: const Text('Oʻqituvchi Qoʻshish'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Teachers Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1000 ? 3 : (constraints.maxWidth > 650 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.25,
                ),
                itemCount: crm.teachers.length,
                itemBuilder: (context, index) {
                  final teacher = crm.teachers[index];
                  final course = crm.getCourseById(teacher.courseId);
                  final teacherGroups = crm.getGroupsByTeacher(teacher.id);

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(
                                teacher.fullName.substring(0, 1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    course?.name ?? 'Yoʻnalish koʻrsatilmagan',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 20, color: AppTheme.textSecondary),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  _showAddEditTeacherDialog(context, teacher);
                                } else if (val == 'delete') {
                                  crm.deleteTeacher(teacher.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Oʻqituvchi oʻchirildi')),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Tahrirlash')),
                                const PopupMenuItem(value: 'delete', child: Text('Oʻchirish', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _infoRow(Icons.phone_outlined, teacher.phone),
                        const SizedBox(height: 6),
                        _infoRow(Icons.email_outlined, teacher.email),
                        const SizedBox(height: 6),
                        _infoRow(Icons.history_edu, 'Tajribasi: ${teacher.experience}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.vpn_key_rounded, size: 14, color: AppTheme.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Login: ${teacher.login}  •  Parol: ${teacher.password}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Guruhlar: ${teacherGroups.length} ta',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.scaffoldBg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Text(
                                teacherGroups.map((g) => g.name).join(', '),
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
