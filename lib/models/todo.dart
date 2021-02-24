class Todo {
  final String title;
  List<dynamic> items;

  Todo({this.title, this.items});

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        items = new List<String>.from(json['items']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'items': items,
      };
}
