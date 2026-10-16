import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({super.key});

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  String? _selectedGroupId;

  void _showTransferDialog(BuildContext context, Student student) {
    final crm = context.read<CrmProvider>();
    // Teacher can transfer student to another group in the SAME course!
    final eligibleGroups = crm.groups.where((g) => g.courseId == student.courseId && g.id != student.groupId).toList();

    if (eligibleGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ushbu yoʻnalishda oʻtkazish uchun boshqa guruh mavjud emas!'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    String targetGroupId = eligibleGroups.first.id;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Oʻquvchini Boshqa Guruhga Oʻtkazish', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Faqat oʻz yoʻnalishingizdagi parallel guruhlar', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(dialogCtx)),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        children: [
                          const Icon(Icons.person_outline, size: 18, color: AppTheme.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              student.fullName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Joriy guruh: ${crm.getGroupById(student.groupId)?.name ?? "-"}',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Qaysi guruhga oʻtkazilsin?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  menuMaxHeight: 260,
                  value: targetGroupId,
                  decoration: const InputDecoration(labelText: 'Maqsadli Guruh'),
                  items: eligibleGroups.map((g) {
                    final t = crm.getTeacherById(g.teacherId);
                    return DropdownMenuItem(
                      value: g.id,
                      child: Text(
                        '${g.name} (${g.days} ${g.time} • ${t?.fullName ?? ""})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => targetGroupId = val);
                    }
                  },
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
            ElevatedButton(
              onPressed: () {
                crm.transferStudent(student.id, targetGroupId);
                Navigator.pop(dialogCtx);
                final newGroupName = crm.getGroupById(targetGroupId)?.name ?? '';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${student.fullName} muvaffaqiyatli "$newGroupName" guruhiga oʻtkazildi!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
              child: const Text('Oʻtkazish'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditStudentInGroupDialog(BuildContext context, String groupId, [Student? existing]) {
    final crm = context.read<CrmProvider>();
    final group = crm.getGroupById(groupId);
    final nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '+998 ');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final parentPhoneCtrl = TextEditingController(text: existing?.parentPhone ?? '+998 ');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                existing == null ? Icons.person_add_rounded : Icons.edit_rounded,
                color: AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'Guruhga Oʻquvchi Qoʻshish' : 'Oʻquvchini Tahrirlash',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Guruh: ${group?.name ?? ""}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(dialogCtx)),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Toʻliq ismi (F.I.SH)',
                  hintText: 'Masalan: Shohruh Abdullayev',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Oʻquvchi telefoni'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextField(
                      controller: parentPhoneCtrl,
                      decoration: const InputDecoration(labelText: 'Ota-onasi telefoni'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email manzili'),
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
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;

              final student = Student(
                id: existing?.id ?? 's_${DateTime.now().millisecondsSinceEpoch}',
                fullName: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                groupId: groupId,
                courseId: group?.courseId ?? '',
                joinedDate: existing?.joinedDate ?? DateTime.now(),
                parentPhone: parentPhoneCtrl.text.trim(),
                login: existing?.login.isNotEmpty == true
                    ? existing!.login
                    : nameCtrl.text.trim().toLowerCase().split(' ').first,
                password: existing?.password.isNotEmpty == true ? existing!.password : '123456',
              );

              if (existing == null) {
                crm.addStudent(student);
              } else {
                crm.updateStudent(student);
              }

              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(existing == null ? 'Oʻquvchi guruhga qoʻshildi!' : 'Oʻquvchi tahrirlandi!'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: Text(existing == null ? 'Qoʻshish' : 'Saqlash'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();
    final teacher = crm.currentTeacher;
    final teacherCourse = teacher != null ? crm.getCourseById(teacher.courseId) : null;
    final teacherGroups = teacher != null ? crm.getGroupsByTeacher(teacher.id) : <Group>[];

    if (_selectedGroupId == null && teacherGroups.isNotEmpty) {
      _selectedGroupId = teacherGroups.first.id;
    } else if (teacherGroups.isNotEmpty && !teacherGroups.any((g) => g.id == _selectedGroupId)) {
      _selectedGroupId = teacherGroups.first.id;
    }

    final selectedGroup = _selectedGroupId != null ? crm.getGroupById(_selectedGroupId!) : null;
    final groupStudents = _selectedGroupId != null ? crm.getStudentsByGroup(_selectedGroupId!) : <Student>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher Info Header Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    teacher?.fullName.substring(0, 1) ?? 'T',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            teacher?.fullName ?? 'Oʻqituvchi',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              teacherCourse?.name ?? 'Mutaxassis',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Siz faqat oʻzingizning yoʻnalishingizdagi guruhlarni boshqara olasiz va oʻquvchilarni tahrirlay/oʻtkaza olasiz.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => crm.setNavIndex(1), // Go to Attendance
                  icon: const Icon(Icons.fact_check, size: 18),
                  label: const Text('Davomat Olish'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Group selector tabs
          Row(
            children: [
              const Text(
                'Mening Guruhlarim: ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: teacherGroups.map((group) {
                    final isSelected = group.id == _selectedGroupId;
                    final studentCount = crm.getStudentsByGroup(group.id).length;

                    return ChoiceChip(
                      selected: isSelected,
                      label: Text('${group.name} ($studentCount talaba)'),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                      selectedColor: AppTheme.primary,
                      backgroundColor: Colors.white,
                      onSelected: (val) {
                        if (val) setState(() => _selectedGroupId = group.id);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Selected Group Details & Student Management Card
          if (selectedGroup != null) ...[
            Container(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${selectedGroup.name} guruhi oʻquvchilari',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.scaffoldBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppTheme.border),
                                ),
                                child: Text(
                                  '${selectedGroup.days} • ${selectedGroup.time} • ${selectedGroup.room}',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jami: ${groupStudents.length} nafar oʻquvchi',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddEditStudentInGroupDialog(context, selectedGroup.id),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Guruhga Oʻquvchi Qoʻshish'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Students List with Transfer action
                  if (groupStudents.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: Text('Ushbu guruhda oʻquvchilar yoʻq')),
                    )
                  else
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2.5),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: AppTheme.scaffoldBg),
                          children: [
                            _tableHeader('Oʻquvchi (F.I.SH)'),
                            _tableHeader('Telefon'),
                            _tableHeader('Ota-onasi'),
                            _tableHeader('Sana'),
                            _tableHeader('Amallar & Oʻtkazish'),
                          ],
                        ),
                        ...groupStudents.map((student) {
                          return TableRow(
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppTheme.divider)),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: AppTheme.primaryLight,
                                      child: Text(
                                        student.fullName.substring(0, 1),
                                        style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        student.fullName,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _tableCell(student.phone),
                              _tableCell(student.parentPhone),
                              _tableCell(DateFormat('dd.MM.yyyy').format(student.joinedDate)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Row(
                                  children: [
                                    // Transfer student button
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        side: const BorderSide(color: AppTheme.info),
                                        foregroundColor: AppTheme.info,
                                      ),
                                      onPressed: () => _showTransferDialog(context, student),
                                      icon: const Icon(Icons.swap_horiz, size: 16),
                                      label: const Text('Guruhini oʻzgartirish', style: TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                                      onPressed: () => _showAddEditStudentInGroupDialog(context, selectedGroup.id, student),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.danger),
                                      onPressed: () {
                                        crm.deleteStudent(student.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Oʻquvchi guruhdan oʻchirildi')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ],
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

  static Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
      ),
    );
  }
}
