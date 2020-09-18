import 'package:flutter/material.dart';
import 'package:todo/models/item.dart';

class TodoCard extends StatelessWidget {
  final Item item;
  final Function switchDone;
  final Function remove;

  TodoCard({ this.item, this.switchDone, this.remove });

  @override
  Widget build(BuildContext context) {
    if (item.done) {
      return Dismissible(
        child: CheckboxListTile(
          value: item.done,
          key: Key(item.title),
          title: Text(
            item.title,
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          subtitle: Text(
            item.creationTime,
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          onChanged: (value) {
            switchDone(value);
          },
        ),
        key: Key(item.title),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red.withOpacity(0.4),
        ),
        onDismissed: (direction) {
          remove(item);
        },
      );
    } else {
      return Dismissible(
        child: CheckboxListTile(
          value: item.done,
          key: Key(item.title),
          title: Text(item.title),
          subtitle: Text(item.creationTime),
          onChanged: (value) {
            switchDone(value);
          },
        ),
        key: Key(item.title),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red.withOpacity(0.4),
        ),
        onDismissed: (direction) {
          remove(item);
        },
      );
    }
  }
}
