enum UserRole {
  admin,
  teacher,
  student,
}

enum AttendanceStatus {
  present, // Bor
  absent,  // Yo'q
  excused, // Sababli
}

class Course {
  final String id;
  final String name;
  final String description;
  final int durationMonths;
  final double price;
  final int colorHex;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMonths,
    required this.price,
    this.colorHex = 0xFFE53935,
  });

  Course copyWith({
    String? id,
    String? name,
    String? description,
    int? durationMonths,
    double? price,
    int? colorHex,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationMonths: durationMonths ?? this.durationMonths,
      price: price ?? this.price,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}

class Teacher {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String courseId; // Yo'nalishi (masalan, Flutter)
  final String experience;
  final String login;
  final String password;

  Teacher({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.courseId,
    required this.experience,
    this.login = '',
    this.password = '123456',
  });

  Teacher copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? courseId,
    String? experience,
    String? login,
    String? password,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      courseId: courseId ?? this.courseId,
      experience: experience ?? this.experience,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

class Group {
  final String id;
  final String name;
  final String courseId;
  final String teacherId;
  final String room;
  final String days; // Masalan: Du-Chor-Jum
  final String time; // Masalan: 14:00 - 16:00
  final String status; // Faol, Tugagan, Yangi

  Group({
    required this.id,
    required this.name,
    required this.courseId,
    required this.teacherId,
    required this.room,
    required this.days,
    required this.time,
    this.status = 'Faol',
  });

  Group copyWith({
    String? id,
    String? name,
    String? courseId,
    String? teacherId,
    String? room,
    String? days,
    String? time,
    String? status,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      teacherId: teacherId ?? this.teacherId,
      room: room ?? this.room,
      days: days ?? this.days,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}

class Student {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String groupId;
  final String courseId;
  final DateTime joinedDate;
  final String parentPhone;
  final String status; // O'qimoqda, Bitirgan, Muzlatilgan
  final String login;
  final String password;

  Student({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.groupId,
    required this.courseId,
    required this.joinedDate,
    required this.parentPhone,
    this.status = "O'qimoqda",
    this.login = '',
    this.password = '123456',
  });

  Student copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? groupId,
    String? courseId,
    DateTime? joinedDate,
    String? parentPhone,
    String? status,
    String? login,
    String? password,
  }) {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      groupId: groupId ?? this.groupId,
      courseId: courseId ?? this.courseId,
      joinedDate: joinedDate ?? this.joinedDate,
      parentPhone: parentPhone ?? this.parentPhone,
      status: status ?? this.status,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

class AttendanceEntry {
  final String studentId;
  final AttendanceStatus status;
  final String note;

  AttendanceEntry({
    required this.studentId,
    required this.status,
    this.note = '',
  });
}

class GroupAttendance {
  final String groupId;
  final DateTime date;
  final Map<String, AttendanceStatus> records; // studentId -> status

  GroupAttendance({
    required this.groupId,
    required this.date,
    required this.records,
  });
}
