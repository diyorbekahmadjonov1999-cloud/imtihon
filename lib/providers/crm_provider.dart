import 'package:flutter/material.dart';
import '../models/models.dart';

class CrmProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.admin;
  String _currentTeacherId = 't1'; // Default teacher: Vali Aliyev (Flutter)
  String _currentStudentId = 's1'; // Default student: Akmalbek Fayzullayev

  UserRole get currentRole => _currentRole;
  String get currentTeacherId => _currentTeacherId;
  String get currentStudentId => _currentStudentId;

  // Selected navigation tab index
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  bool _isLoggedIn = false; // Start on LoginScreen
  bool get isLoggedIn => _isLoggedIn;

  void login(UserRole role, {String? teacherId, String? studentId}) {
    _currentRole = role;
    if (teacherId != null) _currentTeacherId = teacherId;
    if (studentId != null) _currentStudentId = studentId;
    _selectedNavIndex = 0;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _selectedNavIndex = 0;
    notifyListeners();
  }

  // --- Authentication with admin-provided credentials ---
  String _adminUsername = 'admin';
  String _adminPassword = '123456';

  String get adminUsername => _adminUsername;
  String get adminPassword => _adminPassword;

  void updateAdminCredentials({required String username, required String password}) {
    _adminUsername = username;
    _adminPassword = password;
    notifyListeners();
  }

  // Attempt login with role and credentials
  // Returns null on success, or an error message string on failure
  String? authenticateAndLogin({
    required UserRole role,
    required String usernameOrPhone,
    required String password,
  }) {
    final cleanInput = usernameOrPhone.trim().toLowerCase();
    final cleanPass = password.trim();

    if (cleanInput.isEmpty || cleanPass.isEmpty) {
      return 'Iltimos, login va parolni toʻliq kiriting!';
    }

    if (role == UserRole.admin) {
      if (cleanInput == _adminUsername.toLowerCase() && cleanPass == _adminPassword) {
        _currentRole = UserRole.admin;
        _selectedNavIndex = 0;
        _isLoggedIn = true;
        notifyListeners();
        return null;
      } else {
        return 'Admin logini yoki maxfiy paroli notoʻgʻri!';
      }
    } else if (role == UserRole.teacher) {
      final teacher = _teachers.cast<Teacher?>().firstWhere(
        (t) =>
            t != null &&
            (t.login.toLowerCase() == cleanInput ||
             t.phone.replaceAll(' ', '') == cleanInput.replaceAll(' ', '') ||
             t.email.toLowerCase() == cleanInput),
        orElse: () => null,
      );

      if (teacher == null) {
        return 'Bunday login yoki telefon raqamli oʻqituvchi topilmadi!';
      }
      if (teacher.password != cleanPass) {
        return 'Oʻqituvchi paroli notoʻgʻri!';
      }

      _currentRole = UserRole.teacher;
      _currentTeacherId = teacher.id;
      _selectedNavIndex = 0;
      _isLoggedIn = true;
      notifyListeners();
      return null;
    } else {
      final student = _students.cast<Student?>().firstWhere(
        (s) =>
            s != null &&
            (s.login.toLowerCase() == cleanInput ||
             s.phone.replaceAll(' ', '') == cleanInput.replaceAll(' ', '') ||
             s.email.toLowerCase() == cleanInput),
        orElse: () => null,
      );

      if (student == null) {
        return 'Bunday login yoki telefon raqamli oʻquvchi topilmadi!';
      }
      if (student.password != cleanPass) {
        return 'Oʻquvchi paroli notoʻgʻri!';
      }

      _currentRole = UserRole.student;
      _currentStudentId = student.id;
      _selectedNavIndex = 0;
      _isLoggedIn = true;
      notifyListeners();
      return null;
    }
  }

  void switchRole(UserRole role) {
    _currentRole = role;
    _selectedNavIndex = 0; // Reset tab on role switch
    notifyListeners();
  }

  void setCurrentTeacher(String teacherId) {
    _currentTeacherId = teacherId;
    notifyListeners();
  }

  void setCurrentStudent(String studentId) {
    _currentStudentId = studentId;
    notifyListeners();
  }

  // --- Initial Mock Data ---
  final List<Course> _courses = [
    Course(
      id: 'c1',
      name: 'Flutter & Dart Mobile',
      description: 'Cross-platform Android & iOS mobil dasturlar ishlab chiqish',
      durationMonths: 6,
      price: 1500000,
      colorHex: 0xFF0284C7,
    ),
    Course(
      id: 'c2',
      name: 'Frontend Development',
      description: 'HTML, CSS, JavaScript, React va Next.js web ilovalar',
      durationMonths: 5,
      price: 1300000,
      colorHex: 0xFFE11D48,
    ),
    Course(
      id: 'c3',
      name: 'Python & Django Backend',
      description: 'REST API, Maʼlumotlar bazasi, Django & FastAPI',
      durationMonths: 6,
      price: 1400000,
      colorHex: 0xFF16A34A,
    ),
    Course(
      id: 'c4',
      name: 'Grafik Dizayn & UI/UX',
      description: 'Figma, Adobe Photoshop, Illustrator va zamonaviy interfeyslar',
      durationMonths: 4,
      price: 1200000,
      colorHex: 0xFF7C3AED,
    ),
  ];

  final List<Teacher> _teachers = [
    Teacher(
      id: 't1',
      fullName: 'Vali Aliyev',
      phone: '+998 90 123 45 67',
      email: 'vali.aliyev@codial.uz',
      courseId: 'c1',
      experience: '4 yil',
      login: 'vali',
      password: '123456',
    ),
    Teacher(
      id: 't2',
      fullName: 'Sardor Rahimov',
      phone: '+998 91 234 56 78',
      email: 'sardor.rahimov@codial.uz',
      courseId: 'c2',
      experience: '3 yil',
      login: 'sardor',
      password: '123456',
    ),
    Teacher(
      id: 't3',
      fullName: 'Dilshod Karimov',
      phone: '+998 93 345 67 89',
      email: 'dilshod.karimov@codial.uz',
      courseId: 'c3',
      experience: '5 yil',
      login: 'dilshod',
      password: '123456',
    ),
  ];

  final List<Group> _groups = [
    Group(
      id: 'g1',
      name: 'Flutter-101',
      courseId: 'c1',
      teacherId: 't1',
      room: '2-xona (Mac Lab)',
      days: 'Du-Chor-Jum',
      time: '14:00 - 16:00',
      status: 'Faol',
    ),
    Group(
      id: 'g2',
      name: 'Flutter-102 (Intensiv)',
      courseId: 'c1',
      teacherId: 't1',
      room: '2-xona (Mac Lab)',
      days: 'Se-Pay-Shan',
      time: '16:30 - 18:30',
      status: 'Faol',
    ),
    Group(
      id: 'g3',
      name: 'Frontend-201',
      courseId: 'c2',
      teacherId: 't2',
      room: '4-xona',
      days: 'Du-Chor-Jum',
      time: '10:00 - 12:00',
      status: 'Faol',
    ),
    Group(
      id: 'g4',
      name: 'Python-301',
      courseId: 'c3',
      teacherId: 't3',
      room: '1-xona',
      days: 'Se-Pay-Shan',
      time: '18:30 - 20:30',
      status: 'Faol',
    ),
  ];

  final List<Student> _students = [
    Student(
      id: 's1',
      fullName: 'Akmalbek Fayzullayev',
      phone: '+998 94 456 78 90',
      email: 'akmal.fayz@gmail.com',
      groupId: 'g1',
      courseId: 'c1',
      joinedDate: DateTime(2026, 2, 10),
      parentPhone: '+998 90 999 11 22',
      status: "O'qimoqda",
      login: 'akmal',
      password: '123456',
    ),
    Student(
      id: 's2',
      fullName: 'Javohir Toshpoʻlatov',
      phone: '+998 97 567 89 01',
      email: 'javohir.t@gmail.com',
      groupId: 'g1',
      courseId: 'c1',
      joinedDate: DateTime(2026, 2, 10),
      parentPhone: '+998 91 888 22 33',
      status: "O'qimoqda",
      login: 'javohir',
      password: '123456',
    ),
    Student(
      id: 's3',
      fullName: 'Madina Umarova',
      phone: '+998 93 678 90 12',
      email: 'madina.u@gmail.com',
      groupId: 'g1',
      courseId: 'c1',
      joinedDate: DateTime(2026, 2, 12),
      parentPhone: '+998 93 777 33 44',
      status: "O'qimoqda",
      login: 'madina',
      password: '123456',
    ),
    Student(
      id: 's4',
      fullName: 'Bekzod Ergashev',
      phone: '+998 99 789 01 23',
      email: 'bekzod.e@gmail.com',
      groupId: 'g2',
      courseId: 'c1',
      joinedDate: DateTime(2026, 2, 15),
      parentPhone: '+998 94 666 44 55',
      status: "O'qimoqda",
      login: 'bekzod',
      password: '123456',
    ),
    Student(
      id: 's5',
      fullName: 'Shahzod Mirzayev',
      phone: '+998 90 890 12 34',
      email: 'shahzod.m@gmail.com',
      groupId: 'g2',
      courseId: 'c1',
      joinedDate: DateTime(2026, 2, 15),
      parentPhone: '+998 95 555 55 66',
      status: "O'qimoqda",
      login: 'shahzod',
      password: '123456',
    ),
    Student(
      id: 's6',
      fullName: 'Zilola Qosimova',
      phone: '+998 91 901 23 45',
      email: 'zilola.q@gmail.com',
      groupId: 'g3',
      courseId: 'c2',
      joinedDate: DateTime(2026, 2, 1),
      parentPhone: '+998 97 444 66 77',
      status: "O'qimoqda",
      login: 'zilola',
      password: '123456',
    ),
    Student(
      id: 's7',
      fullName: 'Otabek Nazarov',
      phone: '+998 94 012 34 56',
      email: 'otabek.n@gmail.com',
      groupId: 'g4',
      courseId: 'c3',
      joinedDate: DateTime(2026, 2, 5),
      parentPhone: '+998 98 333 77 88',
      status: "O'qimoqda",
      login: 'otabek',
      password: '123456',
    ),
  ];

  // Attendance history: key is 'groupId_YYYY-MM-DD' -> Map<studentId, AttendanceStatus>
  final Map<String, Map<String, AttendanceStatus>> _attendanceStore = {
    'g1_2026-10-14': {
      's1': AttendanceStatus.present,
      's2': AttendanceStatus.present,
      's3': AttendanceStatus.absent,
    },
    'g1_2026-10-12': {
      's1': AttendanceStatus.present,
      's2': AttendanceStatus.excused,
      's3': AttendanceStatus.present,
    },
  };

  // Getters
  List<Course> get courses => List.unmodifiable(_courses);
  List<Teacher> get teachers => List.unmodifiable(_teachers);
  List<Group> get groups => List.unmodifiable(_groups);
  List<Student> get students => List.unmodifiable(_students);

  // Helper getters
  Teacher? get currentTeacher {
    try {
      return _teachers.firstWhere((t) => t.id == _currentTeacherId);
    } catch (_) {
      return _teachers.isNotEmpty ? _teachers.first : null;
    }
  }

  Student? get currentStudent {
    try {
      return _students.firstWhere((s) => s.id == _currentStudentId);
    } catch (_) {
      return _students.isNotEmpty ? _students.first : null;
    }
  }

  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Teacher? getTeacherById(String id) {
    try {
      return _teachers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Group? getGroupById(String id) {
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Student> getStudentsByGroup(String groupId) {
    return _students.where((s) => s.groupId == groupId).toList();
  }

  List<Group> getGroupsByTeacher(String teacherId) {
    return _groups.where((g) => g.teacherId == teacherId).toList();
  }

  List<Group> getGroupsByCourse(String courseId) {
    return _groups.where((g) => g.courseId == courseId).toList();
  }

  // --- CRUD Operations for Courses (+ k) ---
  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void updateCourse(Course course) {
    final idx = _courses.indexWhere((c) => c.id == course.id);
    if (idx != -1) {
      _courses[idx] = course;
      notifyListeners();
    }
  }

  void deleteCourse(String id) {
    _courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // --- CRUD Operations for Teachers (+ t) ---
  void addTeacher(Teacher teacher) {
    final cleanLogin = teacher.login.trim().isNotEmpty
        ? teacher.login.trim()
        : teacher.fullName.toLowerCase().split(' ').first;
    final cleanPass = teacher.password.trim().isNotEmpty ? teacher.password.trim() : '123456';
    _teachers.add(teacher.copyWith(login: cleanLogin, password: cleanPass));
    notifyListeners();
  }

  void updateTeacher(Teacher teacher) {
    final idx = _teachers.indexWhere((t) => t.id == teacher.id);
    if (idx != -1) {
      _teachers[idx] = teacher;
      notifyListeners();
    }
  }

  void deleteTeacher(String id) {
    _teachers.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // --- CRUD Operations for Groups (+ g) ---
  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void updateGroup(Group group) {
    final idx = _groups.indexWhere((g) => g.id == group.id);
    if (idx != -1) {
      _groups[idx] = group;
      notifyListeners();
    }
  }

  void deleteGroup(String id) {
    _groups.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  // --- CRUD Operations for Students (+ s) ---
  void addStudent(Student student) {
    final cleanLogin = student.login.trim().isNotEmpty
        ? student.login.trim()
        : student.fullName.toLowerCase().split(' ').first;
    final cleanPass = student.password.trim().isNotEmpty ? student.password.trim() : '123456';
    _students.add(student.copyWith(login: cleanLogin, password: cleanPass));
    notifyListeners();
  }

  void updateStudent(Student student) {
    final idx = _students.indexWhere((s) => s.id == student.id);
    if (idx != -1) {
      _students[idx] = student;
      notifyListeners();
    }
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // Transfer Student to another group (e.g. Teacher panel feature)
  void transferStudent(String studentId, String newGroupId) {
    final idx = _students.indexWhere((s) => s.id == studentId);
    if (idx != -1) {
      final targetGroup = getGroupById(newGroupId);
      _students[idx] = _students[idx].copyWith(
        groupId: newGroupId,
        courseId: targetGroup?.courseId ?? _students[idx].courseId,
      );
      notifyListeners();
    }
  }

  // --- Attendance Operations (+ D / Teacher D) ---
  String _dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  Map<String, AttendanceStatus> getAttendance(String groupId, DateTime date) {
    final key = "${groupId}_${_dateKey(date)}";
    if (_attendanceStore.containsKey(key)) {
      return Map.from(_attendanceStore[key]!);
    }
    // Default: all students present if not yet saved
    final studentsInGroup = getStudentsByGroup(groupId);
    final map = <String, AttendanceStatus>{};
    for (var s in studentsInGroup) {
      map[s.id] = AttendanceStatus.present;
    }
    return map;
  }

  void saveAttendance(String groupId, DateTime date, Map<String, AttendanceStatus> records) {
    final key = "${groupId}_${_dateKey(date)}";
    _attendanceStore[key] = Map.from(records);
    notifyListeners();
  }

  // Attendance stats for student
  Map<String, dynamic> getStudentAttendanceStats(String studentId) {
    int total = 0;
    int present = 0;
    int absent = 0;
    int excused = 0;

    _attendanceStore.forEach((_, records) {
      if (records.containsKey(studentId)) {
        total++;
        switch (records[studentId]!) {
          case AttendanceStatus.present:
            present++;
            break;
          case AttendanceStatus.absent:
            absent++;
            break;
          case AttendanceStatus.excused:
            excused++;
            break;
        }
      }
    });

    final percent = total == 0 ? 100.0 : ((present + (excused * 0.5)) / total * 100);
    return {
      'total': total,
      'present': present,
      'absent': absent,
      'excused': excused,
      'rate': percent.clamp(0.0, 100.0),
    };
  }
}
