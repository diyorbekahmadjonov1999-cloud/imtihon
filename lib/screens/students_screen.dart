import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _searchQuery = '';
  String? _selectedFilterGroupId;

  void _showStudentCredentialsDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 20, 12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.vpn_key_rounded, color: AppTheme.primary, size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Oʻquvchi Kirish Maʼlumotlari', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Oʻquvchi: ${student.fullName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Login (ID):', style: TextStyle(color: AppTheme.textSecondary)),
                        Text(student.login, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Maxfiy Parol:', style: TextStyle(color: AppTheme.textSecondary)),
                        Text(student.password, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ushbu login va parolni oʻquvchiga yoki uning ota-onasiga taqdim eting.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tushunarli'),
          ),
        ],
      ),
    );
  }

  void _showAddEditStudentDialog(BuildContext context, [Student? existing]) {
    final crm = context.read<CrmProvider>();
    final nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '+998 ');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final parentPhoneCtrl = TextEditingController(text: existing?.parentPhone ?? '+998 ');
    final loginCtrl = TextEditingController(
      text: existing?.login ?? (existing != null ? existing.fullName.toLowerCase().split(' ').first : ''),
    );
    final passCtrl = TextEditingController(text: existing?.password ?? '123456');

    String selectedGroupId = existing?.groupId ?? (crm.groups.isNotEmpty ? crm.groups.first.id : '');

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
                child: const Icon(Icons.person_add, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'Oʻquvchi Qoʻshish' : 'Oʻquvchini Tahrirlash',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Talaba kontaktlari va guruhini biriktiring',
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
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Toʻliq ismi (F.I.SH)",
                      hintText: "Masalan: Akmalbek Fayzullayev",
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
                            labelText: 'Oʻquvchi telefoni',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: parentPhoneCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Ota-onasi telefoni',
                            prefixIcon: Icon(Icons.family_restroom_outlined),
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
                      hintText: 'akmal@gmail.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    menuMaxHeight: 260,
                    value: selectedGroupId.isNotEmpty ? selectedGroupId : null,
                    decoration: const InputDecoration(
                      labelText: 'Biriktiriladigan Guruh',
                      prefixIcon: Icon(Icons.groups_outlined),
                    ),
                    items: crm.groups.map((group) {
                      final course = crm.getCourseById(group.courseId);
                      return DropdownMenuItem(
                        value: group.id,
                        child: Text('${group.name} (${course?.name ?? ""})', overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedGroupId = val);
                      }
                    },
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
                                final genLogin = base.isNotEmpty ? base : 's_${DateTime.now().millisecondsSinceEpoch % 1000}';
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
                                  hintText: 'akmal',
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

                final targetGroup = crm.getGroupById(selectedGroupId);

                final student = Student(
                  id: existing?.id ?? 's_${DateTime.now().millisecondsSinceEpoch}',
                  fullName: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  groupId: selectedGroupId,
                  courseId: targetGroup?.courseId ?? '',
                  joinedDate: existing?.joinedDate ?? DateTime.now(),
                  parentPhone: parentPhoneCtrl.text.trim(),
                  login: loginCtrl.text.trim().isNotEmpty
                      ? loginCtrl.text.trim()
                      : nameCtrl.text.trim().toLowerCase().split(' ').first,
                  password: passCtrl.text.trim().isNotEmpty ? passCtrl.text.trim() : '123456',
                );

                if (existing == null) {
                  crm.addStudent(student);
                } else {
                  crm.updateStudent(student);
                }

                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null ? 'Oʻquvchi muvaffaqiyatli qoʻshildi!' : 'Oʻquvchi maʼlumotlari yangilandi!'),
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

    var filteredStudents = crm.students.where((s) {
      final matchesSearch = s.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.phone.contains(_searchQuery);
      final matchesGroup = _selectedFilterGroupId == null || s.groupId == _selectedFilterGroupId;
      return matchesSearch && matchesGroup;
    }).toList();

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
                    'Oʻquvchilar Roʻyxati',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oʻquv markazidagi barcha talabalar, ularning guruhlari va kontaktlari',
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditStudentDialog(context),
                icon: const Icon(Icons.person_add, size: 20),
                label: const Text('Oʻquvchi Qoʻshish'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters & Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: AppTheme.textMuted),
                      hintText: 'Ism yoki telefon orqali qidirish...',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String?>(
                    isExpanded: true,
                    value: _selectedFilterGroupId,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.filter_list, color: AppTheme.textMuted),
                      labelText: 'Guruh boʻyicha filter',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Barcha guruhlar')),
                      ...crm.groups.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name))),
                    ],
                    onChanged: (val) => setState(() => _selectedFilterGroupId = val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Students Data Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columnSpacing: 24,
                        headingRowColor: WidgetStateProperty.all(AppTheme.scaffoldBg),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                        dataRowMinHeight: 56,
                        dataRowMaxHeight: 64,
                        columns: const [
                          DataColumn(label: Text('OʻQUVCHI (F.I.SH)')),
                          DataColumn(label: Text('TELEFON')),
                          DataColumn(label: Text('GURUH')),
                          DataColumn(label: Text('KURS')),
                          DataColumn(label: Text('OTA-ONASI')),
                          DataColumn(label: Text('QOʻSHILGAN SANA')),
                          DataColumn(label: Text('AMALLAR')),
                        ],
                        rows: filteredStudents.map((student) {
                          final group = crm.getGroupById(student.groupId);
                          final course = crm.getCourseById(student.courseId);

                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 220,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppTheme.primaryLight,
                                        child: Text(
                                          student.fullName.substring(0, 1),
                                          style: const TextStyle(
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              student.fullName,
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${student.email} • Login: ${student.login}',
                                              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(Text(student.phone, style: const TextStyle(fontSize: 13))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    group?.name ?? '-',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(course?.name ?? '-', style: const TextStyle(fontSize: 13))),
                              DataCell(Text(student.parentPhone, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary))),
                              DataCell(Text(DateFormat('dd.MM.yyyy').format(student.joinedDate), style: const TextStyle(fontSize: 12))),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.vpn_key_outlined, size: 18, color: AppTheme.primary),
                                      tooltip: 'Kirish maʼlumotlari (Login/Parol)',
                                      onPressed: () => _showStudentCredentialsDialog(context, student),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                                      onPressed: () => _showAddEditStudentDialog(context, student),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.danger),
                                      onPressed: () {
                                        crm.deleteStudent(student.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Oʻquvchi oʻchirildi')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
