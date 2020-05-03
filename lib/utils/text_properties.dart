import 'package:flutter/material.dart';

import '../widget/color_picker.dart';
import '../widget/custom_container.dart';
import '../utils/text_styles.dart';

class TextProperties {
  String text;
  double fontSize;
  Color fontColor;
  double textBoxWidth;
  Color bgColor;
  bool isTrasparent;
  TextProperties(
      {this.text,
      this.fontSize,
      this.fontColor,
      this.textBoxWidth,
      this.bgColor,
      this.isTrasparent});
}

class EditTextProperties extends StatefulWidget {
  EditTextProperties({Key key, this.textProperties, this.maxTextWidth}) : super(key: key);
  final textProperties;
  final maxTextWidth;

  @override
  EditTextPropertiesState createState() => EditTextPropertiesState();
}

class EditTextPropertiesState extends State<EditTextProperties> {
  var _controller;
  TextProperties editProperties;

  double maxFontSize;
  double minFontSize;

  double maxTextWidth;
  double minTextWidth;



  EditTextPropertiesState();

  @override
  void initState() {
    super.initState();
    maxFontSize = 100;
    minFontSize = 10;
    editProperties = widget.textProperties;
    maxTextWidth=widget.maxTextWidth;
    _controller = TextEditingController(text: editProperties.text);
  }

  Widget drawEditDialog(TextProperties textProperties) {
    
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: Colors.blueGrey[800],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Edit text properties', style: dialogTitleStyle),
              ),
              ContainerWithPadding(
                child: TextField(
                  style: dialogOptions,
                  decoration: InputDecoration(
                    hintText: 'Enter text here',
                    hintStyle: dialogOptions,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  controller: _controller,
                  onChanged: (val) {
                    setState(() {
                      textProperties.text = val;
                    });
                  },
                ),
              ),
              ContainerWithPadding(
                child: ListTile(
                  title: Text(
                    'Change Font Size',
                    style: dialogOptions,
                  ),
                  subtitle: Slider(
                      max: maxFontSize,
                      min: minFontSize,
                      value: textProperties.fontSize,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.black,
                      onChanged: (val) {
                        setState(() {
                          textProperties.fontSize = val;
                        });
                      }),
                ),
              ),
              ContainerWithPadding(
                child: ListTile(
                  title: Text(
                    'Change Text Box Width',
                    style: dialogOptions,
                  ),
                  subtitle: Slider(
                      max: maxTextWidth,
                      min: maxTextWidth*0.1,
                      value: textProperties.textBoxWidth,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.black,
                      onChanged: (val) {
                        setState(() {
                          textProperties.textBoxWidth = val;
                          //print(selectedTextWidth);
                        });
                      }),
                ),
              ),
              changeColor(true),
              changeColor(false),
              ContainerWithPadding(
                child: CheckboxListTile(
                  title: Text('Transparent Background', style: dialogOptions),
                  activeColor: Colors.indigo,
                  value: editProperties.isTrasparent,
                  onChanged: (bool val) {
                    setState(() {
                      editProperties.isTrasparent = val;
                      editProperties.isTrasparent
                          ? editProperties.bgColor = Colors.transparent
                          : editProperties.bgColor = Colors.white;
                    });
                  },
                ),
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
    );
  }

  Widget changeColor(bool fontColor) {
    return ContainerWithPadding(
      child: ListTile(
        title: fontColor
            ? Text('Change Font color', style: dialogOptions)
            : Text('Change BackGround color', style: dialogOptions),
        onTap: () async {
          await showDialog<double>(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (BuildContext context, setState) {
                return WheelPickerPage(
                  fontColor: fontColor,
                  textProperties: editProperties,
                );
              },
            ),
            barrierDismissible: false,
          ).then((_) {
            setState(() {});
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return drawEditDialog(editProperties);
  }
}

class IndividualColorContainer extends StatefulWidget {
  const IndividualColorContainer({
    Key key,
    @required this.isSelected,
    this.onTap,
    this.color,
  }) : super(key: key);

  final bool isSelected;
  final Function onTap;
  final Color color;
  @override
  _IndividualColorContainerState createState() =>
      _IndividualColorContainerState();
}

class _IndividualColorContainerState extends State<IndividualColorContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.isSelected ? 30 : 15,
        width: widget.isSelected ? 30 : 15,
        decoration:
            BoxDecoration(border: Border.all(width: 2), color: widget.color),
      ),
    );
  }
}
