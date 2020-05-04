import 'package:flutter/material.dart';
import 'package:meme_generator/utils/resizeable.dart';
import '../utils/text_properties.dart';

class MoveableStackItem extends StatefulWidget {
  final double bottom, right;

  final textProperties;

  MoveableStackItem({
    Key key,
    this.bottom,
    this.right,
    this.textProperties,
  }) : super(key: key);
  @override
  _MoveableStackItemState createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition;
  double yPosition;

  bool _dragging = false;
  GlobalKey _textKey = GlobalKey();

  Size sizeText = Size(0, 0);

  TextProperties textProperties;

  _getSize() {
    final RenderBox renderContainer =
        _textKey.currentContext.findRenderObject();
    sizeText = renderContainer.size;
  }

  @override
  void initState() {
    xPosition = 0;
    yPosition = widget.bottom / 2 - sizeText.height / 2;
    textProperties = widget.textProperties;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(sizeText);
    return Stack(
      children: <Widget>[
        Positioned(
          top: yPosition,
          left: xPosition,
          child: GestureDetector(
            onPanEnd: (tapInfo) {
              setState(() {
                _dragging = false;
              });
            },
            onPanUpdate: (tapInfo) {
              setState(() {
                _dragging = true;
                _getSize();
                //print(sizeText);
                if (xPosition < 0 ||
                    xPosition + sizeText.width > widget.right) {
                  if (xPosition < 0)
                    xPosition = 0;
                  else
                    xPosition = widget.right - sizeText.width;
                } else {
                  xPosition = xPosition + tapInfo.delta.dx;
                }
                if (yPosition < 0 ||
                    yPosition + sizeText.height > widget.bottom) {
                  if (yPosition < 0)
                    yPosition = 0;
                  else
                    yPosition = widget.bottom - sizeText.height;
                } else {
                  yPosition = yPosition + tapInfo.delta.dy;
                }
              });
            },
            child: GestureDetector(
              onTap: () async {
                await showDialog<double>(
                  context: context,
                  builder: (context) => EditTextProperties(
                    textProperties: textProperties,
                  ),
                  barrierDismissible: false,
                ).then((_) {
                  setState(() {});
                });
              },
              child: Container(
                key: _textKey,
                decoration: BoxDecoration(
                    border: _dragging
                        ? Border.all(
                            color: Colors.black26,
                            width: 3,
                            style: BorderStyle.solid)
                        : Border.all(style: BorderStyle.none)),
                child: Center(
                  child: Text(
                    textProperties.text.toUpperCase(),
                    textAlign: TextAlign.center,
                    textScaleFactor: 2,
                    style: TextStyle(
                      backgroundColor: textProperties.bgColor,
                      fontSize: textProperties.fontSize,
                      color: textProperties.fontColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
