import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
import '../widget/custom_container.dart';

class OptionsDialog extends StatelessWidget {
  const OptionsDialog(
      {Key key,
      this.optionOnTap,
      this.optionLabels,
      this.optionIcons,
      this.title})
      : super(key: key);
  final List<Function> optionOnTap;
  final List<String> optionLabels;
  final List<IconData> optionIcons;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey[800],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DialogTitle(title:title),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    runSpacing: 10,
                    runAlignment: WrapAlignment.spaceEvenly,
                    //mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(optionLabels.length, (i) {
                      return FloatingActionButton.extended(
                        backgroundColor: Colors.blueGrey[700],
                        onPressed: optionOnTap[i],
                        label: Text(optionLabels[i], style: dialogOptions),
                        icon: Icon(optionIcons[i]),
                      );
                    }),
                  ),
                )
              ],
            )),
          ),
        ));
  }
}
