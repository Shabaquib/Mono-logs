class Note {
  final String? topic;
  final String? content;
  final DateTime createdOn;
  final Map<String, int> colorMap;

  Note(
      {required this.topic,
      required this.content,
      required this.colorMap,
      required this.createdOn});

  String get getTopic {
    return topic ?? " ";
  }

  String get getContent {
    return content ?? " ";
  }

  DateTime get getStamp {
    return createdOn;
  }

  Map<String, int> get getColor {
    return colorMap;
  }
}
