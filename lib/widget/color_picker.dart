import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

import '../utils/text_properties.dart';
import '../utils/text_styles.dart';

class WheelPickerPage extends StatefulWidget {
  final textProperties;
  final bool fontColor;

  const WheelPickerPage({Key key, this.textProperties, this.fontColor})
      : super(key: key);
  @override
  WheelPickerPageState createState() => new WheelPickerPageState();
}

class WheelPickerPageState extends State<WheelPickerPage> {
  static TextProperties editProperties;
  HSVColor color;
  void onChanged(HSVColor color) => this.color = color;

  @override
  void initState() {
    super.initState();
    editProperties = widget.textProperties;
  }

  @override
  void didUpdateWidget(WheelPickerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textProperties != widget.textProperties) {
      editProperties = widget.textProperties;
    }
  }

  @override
  Widget build(BuildContext context) {
    color = widget.fontColor
        ? HSVColor.fromColor(editProperties.fontColor)
        : HSVColor.fromColor(editProperties.bgColor);
    return Dialog(
      backgroundColor: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        widget.fontColor
                            ? 'Edit Font Color'
                            : 'Edit Background Color',
                        style: dialogTitleStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        editProperties.text,
                        style: TextStyle(
                            backgroundColor: editProperties.bgColor,
                            color: editProperties.fontColor,
                            fontSize: editProperties.fontSize),
                      ),
                    ),
                  ),
                  new FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    backgroundColor: this.color.toColor(),
                  ),
                  new Container(
                    child: new WheelPicker(
                        color: this.color,
                        onChanged: (value) {
                          super.setState(() {
                            this.onChanged(value);
                            widget.fontColor
                                ? editProperties.fontColor = value.toColor()
                                : editProperties.isTrasparent
                                    ? editProperties.bgColor =
                                        Colors.transparent
                                    : editProperties.bgColor = value.toColor();
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                      onPressed: () => Navigator.pop(context),
                      label: Text('Done'),
                      icon: Icon(Icons.done),
                      backgroundColor: Colors.blueGrey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
