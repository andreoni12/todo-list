class Item {
  String title;
  bool done;
  String creationTime;

  Item({
    this.title,
    this.done,
    this.creationTime
  });

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
    creationTime = json['creationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    data['creationTime'] = creationTime;

    return data;
  }
}