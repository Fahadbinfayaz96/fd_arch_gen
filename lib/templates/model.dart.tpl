import '../../domain/entities/{{snake}}_entity.dart';

class {{Feature}}Model extends {{Feature}}Entity {
  const {{Feature}}Model({
    required super.id,
    required super.name,
  });

  factory {{Feature}}Model.fromJson(Map<String, dynamic> json) {
    return {{Feature}}Model(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  
  // Helper for lists
  static List<{{Feature}}Model> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => {{Feature}}Model.fromJson(json)).toList();
  }
  
  static List<Map<String, dynamic>> toJsonList(List<{{Feature}}Model> models) {
    return models.map((model) => model.toJson()).toList();
  }
}