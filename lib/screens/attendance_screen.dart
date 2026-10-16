import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final String? initialGroupId;

  const AttendanceScreen({super.key, this.initialGroupId});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late String _selectedGroupId;
  DateTime _selectedDate = DateTime.now();
  Map<String, AttendanceStatus> _currentRecords = {};
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final crm = context.read<CrmProvider>();
      // If teacher role, select their first group if available
      if (crm.currentRole == UserRole.teacher && crm.currentTeacher != null) {
        final teacherGroups = crm.getGroupsByTeacher(crm.currentTeacher!.id);
        _selectedGroupId = teacherGroups.isNotEmpty ? teacherGroups.first.id : (crm.groups.isNotEmpty ? crm.groups.first.id : '');
      } else {
        _selectedGroupId = widget.initialGroupId ?? (crm.groups.isNotEmpty ? crm.groups.first.id : '');
      }
      _loadAttendance();
      _isInitialized = true;
    }
  }

  void _loadAttendance() {
    final crm = context.read<CrmProvider>();
    if (_selectedGroupId.isNotEmpty) {
      final records = crm.getAttendance(_selectedGroupId, _selectedDate);
      setState(() {
        _currentRecords = Map.from(records);
      });
    }
  }

  void _markAll(AttendanceStatus status) {
    final crm = context.read<CrmProvider>();
    final students = crm.getStudentsByGroup(_selectedGroupId);
    setState(() {
      for (var s in students) {
        _currentRecords[s.id] = status;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<CrmProvider>();

    // Filter available groups if teacher role
    final availableGroups = crm.currentRole == UserRole.teacher && crm.currentTeacher != null
        ? crm.getGroupsByTeacher(crm.currentTeacher!.id)
        : crm.groups;

    if (availableGroups.isNotEmpty && !availableGroups.any((g) => g.id == _selectedGroupId)) {
      _selectedGroupId = availableGroups.first.id;
      _loadAttendance();
    }
    final groupStudents = _selectedGroupId.isNotEmpty ? crm.getStudentsByGroup(_selectedGroupId) : <Student>[];

    int presentCount = 0;
    int absentCount = 0;
    int excusedCount = 0;

    for (var s in groupStudents) {
      final st = _currentRecords[s.id] ?? AttendanceStatus.present;
      if (st == AttendanceStatus.present) presentCount++;
      if (st == AttendanceStatus.absent) absentCount++;
      if (st == AttendanceStatus.excused) excusedCount++;
    }

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
                  Text(
                    crm.currentRole == UserRole.teacher ? 'Dars Davomati Olish' : 'Davomat Nazorati',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kunlik dars davomatini belgilash va statistikani yuritish',
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  crm.saveAttendance(_selectedGroupId, _selectedDate, _currentRecords);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Davomat muvaffaqiyatli saqlandi!'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline, size: 20),
                label: const Text('Davomatni Saqlash'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Controls Row: Group selector & Date Picker
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedGroupId.isNotEmpty ? _selectedGroupId : null,
                    decoration: const InputDecoration(
                      labelText: 'Guruhni tanlang',
                      prefixIcon: Icon(Icons.group, color: AppTheme.textMuted),
                    ),
                    items: availableGroups.map((g) {
                      final course = crm.getCourseById(g.courseId);
                      return DropdownMenuItem(
                        value: g.id,
                        child: Text(
                          '${g.name} — ${course?.name ?? ""} (${g.days} ${g.time})',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedGroupId = val;
                          _loadAttendance();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2027),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                          _loadAttendance();
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: AppTheme.textSecondary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMMM yyyy, EEEE').format(_selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => _markAll(AttendanceStatus.present),
                  icon: const Icon(Icons.done_all, size: 18, color: AppTheme.success),
                  label: const Text('Barchasini BOR qilish'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Attendance Quick Counters
          Row(
            children: [
              _statChip('Jami oʻquvchilar', '${groupStudents.length} nafar', AppTheme.textSecondary, Colors.grey.shade100),
              const SizedBox(width: 12),
              _statChip('Kelganlar (Bor)', '$presentCount nafar', AppTheme.success, AppTheme.successBg),
              const SizedBox(width: 12),
              _statChip('Kelmaganlar (Yoʻq)', '$absentCount nafar', AppTheme.danger, AppTheme.dangerBg),
              const SizedBox(width: 12),
              _statChip('Sabablilar', '$excusedCount nafar', AppTheme.warning, AppTheme.warningBg),
            ],
          ),
          const SizedBox(height: 20),

          // Students Attendance Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: groupStudents.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('Ushbu guruhda oʻquvchilar mavjud emas'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groupStudents.length,
                    separatorBuilder: (ctx, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final student = groupStudents[index];
                      final currentStatus = _currentRecords[student.id] ?? AttendanceStatus.present;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(
                                student.fullName.substring(0, 1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    student.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Attendance selection chips
                            Wrap(
                              spacing: 8,
                              children: [
                                _statusButton(
                                  label: 'Bor (+)',
                                  isSelected: currentStatus == AttendanceStatus.present,
                                  color: AppTheme.success,
                                  bgColor: AppTheme.successBg,
                                  onTap: () {
                                    setState(() {
                                      _currentRecords[student.id] = AttendanceStatus.present;
                                    });
                                  },
                                ),
                                _statusButton(
                                  label: 'Yoʻq (-)',
                                  isSelected: currentStatus == AttendanceStatus.absent,
                                  color: AppTheme.danger,
                                  bgColor: AppTheme.dangerBg,
                                  onTap: () {
                                    setState(() {
                                      _currentRecords[student.id] = AttendanceStatus.absent;
                                    });
                                  },
                                ),
                                _statusButton(
                                  label: 'Sababli',
                                  isSelected: currentStatus == AttendanceStatus.excused,
                                  color: AppTheme.warning,
                                  bgColor: AppTheme.warningBg,
                                  onTap: () {
                                    setState(() {
                                      _currentRecords[student.id] = AttendanceStatus.excused;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(color: textColor, fontSize: 12)),
          Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _statusButton({
    required String label,
    required bool isSelected,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : AppTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
