import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/crm_provider.dart';
import '../theme/app_theme.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  void _showAddEditCourseDialog(BuildContext context, [Course? existing]) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final durationCtrl = TextEditingController(text: existing?.durationMonths.toString() ?? '6');
    final priceCtrl = TextEditingController(text: existing?.price.toInt().toString() ?? '1500000');
    int selectedColor = existing?.colorHex ?? 0xFFDC2626;

    final colorOptions = [
      0xFFDC2626, // Red
      0xFF0284C7, // Blue
      0xFF16A34A, // Green
      0xFF7C3AED, // Purple
      0xFFEA580C, // Orange
      0xFF0D9488, // Teal
    ];

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
                child: const Icon(Icons.menu_book, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'Yangi Yoʻnalish / Kurs Qoʻshish' : 'Kursni Tahrirlash',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Oʻquv dasturi va toʻlov shartlarini belgilang',
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
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kurs / Yoʻnalish nomi',
                    hintText: 'Masalan: Flutter & Dart Mobile',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Tavsif',
                    hintText: 'Kurs haqida qisqacha maʼlumot...',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Davomiyligi (oy)',
                          suffixText: 'oy',
                          prefixIcon: Icon(Icons.timelapse_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Oylik toʻlov',
                          suffixText: 'soʻm',
                          prefixIcon: Icon(Icons.payments_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Yoʻnalish kartasi rangi:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: colorOptions.map((colorVal) {
                    final isSel = selectedColor == colorVal;
                    return InkWell(
                      onTap: () => setDialogState(() => selectedColor = colorVal),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(colorVal),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSel ? Colors.black : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: isSel ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                      ),
                    );
                  }).toList(),
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
                final crm = context.read<CrmProvider>();

                final course = Course(
                  id: existing?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  durationMonths: int.tryParse(durationCtrl.text) ?? 6,
                  price: double.tryParse(priceCtrl.text) ?? 1500000,
                  colorHex: selectedColor,
                );

                if (existing == null) {
                  crm.addCourse(course);
                } else {
                  crm.updateCourse(course);
                }

                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null ? 'Yangi yoʻnalish qoʻshildi!' : 'Kurs yangilandi!'),
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
                    'Kurslar va Yoʻnalishlar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oʻquv markazidagi barcha oʻquv dasturlari va mutaxassisliklar',
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditCourseDialog(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Kurs Qoʻshish'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Course cards grid
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
                  childAspectRatio: 1.45,
                ),
                itemCount: crm.courses.length,
                itemBuilder: (context, index) {
                  final course = crm.courses[index];
                  final groupsCount = crm.getGroupsByCourse(course.id).length;

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
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(course.colorHex).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color: Color(course.colorHex),
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.textSecondary),
                              onPressed: () => _showAddEditCourseDialog(context, course),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.danger),
                              onPressed: () {
                                crm.deleteCourse(course.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kurs oʻchirildi')),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            course.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 15, color: AppTheme.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  '${course.durationMonths} oy',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${course.price.toStringAsFixed(0)} soʻm/oy',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ),
                            Text(
                              '$groupsCount ta guruh',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
