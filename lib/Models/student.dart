class StudentModel {
  String? name;
  num? studentClass;
  num? roll;
  String? section;
  String? id;

  StudentModel({this.name, this.studentClass, this.roll, this.section, this.id});

  StudentModel.fromJson({required Map<String, dynamic> json}) {
    name = json['name'];
    studentClass = json['class'];
    roll = json['roll'];
    section = json['section'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'class': studentClass,
        'roll': roll,
        'section': section,
      };
}
