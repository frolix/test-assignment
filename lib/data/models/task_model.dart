class TaskModel {
  final String id;
  final List<String> field;
  final Map<String, int> start;
  final Map<String, int> end;

  TaskModel({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      field: List<String>.from(json['field']),
      start: Map<String, int>.from(json['start']),
      end: Map<String, int>.from(json['end']),
    );
  }

  // Add operator [] for dynamic property access
  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'field':
        return field;
      case 'start':
        return start;
      case 'end':
        return end;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}
