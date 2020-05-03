import 'package:flutter/material.dart';
import '../utils/text_styles.dart';


class ContainerWithPadding extends StatelessWidget {
  final child;
  const ContainerWithPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }
}


class DialogTitle extends StatelessWidget {
  const DialogTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: <Widget>[
          Container(
            child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white70), onPressed: (){
              Navigator.pop(context);
            }),
          ),
          Container(
              child: Text(title,
                  style:
                      dialogTitleStyle),
          ),
        ],
      ),
    );
  }
}
