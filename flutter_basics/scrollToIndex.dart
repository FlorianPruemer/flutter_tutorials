import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.looks_4_rounded),
          onPressed: () => itemScrollController.scrollTo(
              index: 4, duration: Duration(seconds: 1)),
        ),
      ),
      body: ScrollablePositionedList.builder(
          itemCount: 10,
          initialScrollIndex: 2,
          itemScrollController: itemScrollController,
          itemBuilder: (context, index) {
            return Center(
              heightFactor: 10,
              child: Text('$index'),
            );
          }),
    );
  }
}
