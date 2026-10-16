import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

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
            IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Yoʻnalish nomi', hintText: 'Masalan: Node.js'),
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
                colorHex: 0xFF0284C7,
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

  void _showQuickAddTeacherDialog(BuildContext context, String currentCourseId, Function(String newTeacherId) onCreated) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: '+998 ');

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
              child: const Icon(Icons.person_add, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Yangi Oʻqituvchi Qoʻshish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'F.I.SH (Toʻliq ismi)', hintText: 'Masalan: Alisher Zokirov'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Telefon raqam'),
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
              final newId = 't_${DateTime.now().millisecondsSinceEpoch}';
              final newTeacher = Teacher(
                id: newId,
                fullName: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: 'teacher@codial.uz',
                courseId: currentCourseId,
                experience: '3 yil',
              );
              context.read<CrmProvider>().addTeacher(newTeacher);
              Navigator.pop(ctx);
              onCreated(newId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${newTeacher.fullName}" oʻqituvchi qoʻshildi!'), backgroundColor: AppTheme.success),
              );
            },
            child: const Text('Qoʻshish'),
          ),
        ],
      ),
    );
  }

  void _showAddEditGroupDialog(BuildContext context, [Group? existing]) {
    final crm = context.read<CrmProvider>();
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final roomCtrl = TextEditingController(text: existing?.room ?? '2-xona (Mac Lab)');
    final timeCtrl = TextEditingController(text: existing?.time ?? '14:00 - 16:00');
    final daysCtrl = TextEditingController(text: existing?.days ?? 'Du-Chor-Jum');

    String selectedCourseId = existing?.courseId ?? (crm.courses.isNotEmpty ? crm.courses.first.id : '');
    String selectedTeacherId = existing?.teacherId ?? (crm.teachers.isNotEmpty ? crm.teachers.first.id : '');

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
                child: const Icon(Icons.group_add, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'Yangi Guruh Yaratish' : 'Guruhni Tahrirlash',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Dars jadvali, xona va oʻqituvchini biriktiring',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Guruh nomi',
                    hintText: 'Masalan: Flutter-103',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        menuMaxHeight: 260,
                        value: selectedCourseId.isNotEmpty ? selectedCourseId : null,
                        decoration: const InputDecoration(
                          labelText: 'Kurs / Yoʻnalish',
                          prefixIcon: Icon(Icons.menu_book_outlined),
                        ),
                        items: crm.courses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedCourseId = val);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Yangi yoʻnalish qoʻshish',
                      child: InkWell(
                        onTap: () => _showQuickAddCourseDialog(context, (newId) {
                          setDialogState(() => selectedCourseId = newId);
                        }),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.add, size: 20, color: AppTheme.primaryDark),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        menuMaxHeight: 260,
                        value: selectedTeacherId.isNotEmpty ? selectedTeacherId : null,
                        decoration: const InputDecoration(
                          labelText: 'Oʻqituvchi (Mentor)',
                          prefixIcon: Icon(Icons.person_pin_outlined),
                        ),
                        items: crm.teachers.map((t) => DropdownMenuItem(value: t.id, child: Text(t.fullName, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedTeacherId = val);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Yangi oʻqituvchi qoʻshish',
                      child: InkWell(
                        onTap: () => _showQuickAddTeacherDialog(context, selectedCourseId, (newId) {
                          setDialogState(() => selectedTeacherId = newId);
                        }),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: const Icon(Icons.add, size: 20, color: AppTheme.primaryDark),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: daysCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Dars kunlari',
                          hintText: 'Du-Chor-Jum',
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: timeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Dars vaqti',
                          hintText: '14:00 - 16:00',
                          prefixIcon: Icon(Icons.access_time_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: roomCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Xona / Auditoriya',
                    hintText: '2-xona (Mac Lab)',
                    prefixIcon: Icon(Icons.meeting_room_outlined),
                  ),
                ),
              ],
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

                final group = Group(
                  id: existing?.id ?? 'g_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  courseId: selectedCourseId,
                  teacherId: selectedTeacherId,
                  room: roomCtrl.text.trim(),
                  days: daysCtrl.text.trim(),
                  time: timeCtrl.text.trim(),
                );

                if (existing == null) {
                  crm.addGroup(group);
                } else {
                  crm.updateGroup(group);
                }

                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null ? 'Yangi guruh ochildi!' : 'Guruh yangilandi!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              label: Text(existing == null ? 'Yaratish' : 'Saqlash'),
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
                    'Guruhlar Boshqaruvi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Markazdagi barcha faol guruhlar, dars jadvallari va oʻquvchilar soni',
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditGroupDialog(context),
                icon: const Icon(Icons.group_add, size: 20),
                label: const Text('Guruh Yaratish'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Groups list cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100 ? 3 : (constraints.maxWidth > 700 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.35,
                ),
                itemCount: crm.groups.length,
                itemBuilder: (context, index) {
                  final group = crm.groups[index];
                  final course = crm.getCourseById(group.courseId);
                  final teacher = crm.getTeacherById(group.teacherId);
                  final students = crm.getStudentsByGroup(group.id);

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
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                group.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryDark,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.successBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                group.status,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.success,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 18, color: AppTheme.textSecondary),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  _showAddEditGroupDialog(context, group);
                                } else if (val == 'delete') {
                                  crm.deleteGroup(group.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Guruh oʻchirildi')),
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
                        const SizedBox(height: 12),
                        Text(
                          course?.name ?? 'Kurs topilmadi',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_pin, size: 15, color: AppTheme.textMuted),
                            const SizedBox(width: 6),
                            Text(
                              teacher?.fullName ?? 'Oʻqituvchi tayinlanmagan',
                              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.scaffoldBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.textSecondary),
                                  const SizedBox(width: 5),
                                  Text(
                                    group.days,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                                  const SizedBox(width: 5),
                                  Text(
                                    group.time,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.meeting_room_outlined, size: 15, color: AppTheme.textMuted),
                                const SizedBox(width: 5),
                                Text(
                                  group.room,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                            Text(
                              '${students.length} nafar oʻquvchi',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
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
}
