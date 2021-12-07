const String lucidForm = 'forms';

class FormField {
  static final List<String> values = [
    id,
    name,
    mark,
    img,
    gender,
    dob,
    nation,
  ];
  static const String id = '_id';
  static const String name = '_name';
  static const String mark = '_mark';
  static const String img = '_img';
  static const String gender = '_gender';
  static const String dob = '_dob';
  static const String nation = '_nation';
}

class LucidForm {
  final int? id;
  final String name;
  final int mark;
  final String img;
  final String gender;
  final String dob;
  final String nation;

  LucidForm({
    this.id,
    required this.name,
    required this.mark,
    required this.img,
    required this.gender,
    required this.dob,
    required this.nation,
  });
  LucidForm copy({
    int? id,
    String? name,
    int? mark,
    String? img,
    String? gender,
    String? dob,
    String? nation,
  }) =>
      LucidForm(
        id: id ?? this.id,
        name: name ?? this.name,
        mark: mark ?? this.mark,
        img: img ?? this.img,
        gender: gender ?? this.gender,
        dob: dob ?? this.dob,
        nation: nation ?? this.nation,
      );

  static LucidForm fromJson(Map<String, Object?> json)=>LucidForm(
      id: json[FormField.id] as int?,
      name: json[FormField.name] as String,
      mark: json[FormField.mark] as int,
      img: json[FormField.img] as String,
      gender: json[FormField.gender] as String,
      dob: json[FormField.dob] as String,
      nation: json[FormField.nation] as String,
  );
  Map<String, Object?> toJson()=>{
    FormField.id:id,
    FormField.name:name,
    FormField.mark:mark,
    FormField.img:img,
    FormField.gender:gender,
    FormField.dob:dob,
    FormField.nation:nation,
  };
}
