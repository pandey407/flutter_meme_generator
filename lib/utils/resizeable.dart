import 'package:flutter/material.dart';
import 'package:meme_generator/utils/text_properties.dart';

class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({
    this.bottomBoundary,
    this.rightBoundary,
    this.textProperties,
  });
  final textProperties;
  final double bottomBoundary, rightBoundary;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

bool isEditing = false;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  double height;
  double width;

  double top;
  double left;

  double ballDiameter;

  double textFactor = 1;

  double initialTextFactor = 1;

  TextProperties textProperties;

  GlobalKey _textKey = GlobalKey();

  Size sizeText = Size(0, 0);

  @override
  void initState() {
    super.initState();
    initialTextFactor = 1;
    textFactor = initialTextFactor;
    height = widget.bottomBoundary * 0.3;
    width = widget.rightBoundary / 3;
    top = widget.bottomBoundary / 2 - height / 2;
    left = 0;
    ballDiameter = 20;
    textProperties = widget.textProperties;
  }

  @override
  Widget build(BuildContext context) {
    double right = widget.rightBoundary;
    double bottom = widget.bottomBoundary;
    checkBoundary() {
      if (top < 0 || (top + height) > bottom) {
        if (top < 0) {
          top = 0;
        } else {
          top = bottom - height;
        }
      }
      if (left < 0 || left + width > right) {
        if (left < 0) {
          left = 0;
        } else {
          left = right - width;
        }
      }
    }

    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            onScaleUpdate: (ScaleUpdateDetails scale) {
              setState(() {
                print(scale.scale);
                textFactor = initialTextFactor * scale.scale;
              });
            },
            onScaleStart: (ScaleStartDetails scale) {
              initialTextFactor = textFactor;
            },
            onDoubleTap: () async {
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
                height: height,
                width: width,
                decoration: BoxDecoration(
                  border: isEditing
                      ? Border.all(
                          width: 5,
                          color: Colors.black,
                        )
                      : Border.all(style: BorderStyle.none),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        textProperties.text.toUpperCase(),
                        textAlign: TextAlign.center,
                        textScaleFactor: textFactor,
                        style: TextStyle(
                          backgroundColor: textProperties.bgColor,
                          fontSize: textProperties.fontSize,
                          color: textProperties.fontColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        // top left
        isEditing
            ? Positioned(
                top: top - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;
                    var newHeight = height - 2 * mid;
                    var newWidth = width - 2 * mid;
                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top + mid;
                      left = left + mid;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.CIRCLE,
                ),
              )
            : Container(),

        // top middle
        isEditing
            ? Positioned(
                top: top - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var newHeight = height - dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      top = top + dy;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.SQUARE,
                ),
              )
            : Container(),
        // top right
        isEditing
            ? Positioned(
                top: top - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var mid = (dx + (dy * -1)) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.CIRCLE,
                ),
              )
            : Container(),
        // center right
        isEditing
            ? Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var newWidth = width + dx;
                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.SQUARE,
                ),
              )
            : Container(),
        // bottom right
        isEditing
            ? Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var mid = (dx + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.CIRCLE,
                ),
              )
            : Container(),
        // bottom center
        isEditing
            ? Positioned(
                top: top + height - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var newHeight = height + dy;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.SQUARE,
                ),
              )
            : Container(),
        // bottom left
        isEditing
            ? Positioned(
                top: top + height - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var mid = ((dx * -1) + dy) / 2;

                    var newHeight = height + 2 * mid;
                    var newWidth = width + 2 * mid;

                    setState(() {
                      height = newHeight > 0 ? newHeight : 0;
                      width = newWidth > 0 ? newWidth : 0;
                      top = top - mid;
                      left = left - mid;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.CIRCLE,
                ),
              )
            : Container(),
        //left center
        isEditing
            ? Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    var newWidth = width - dx;

                    setState(() {
                      width = newWidth > 0 ? newWidth : 0;
                      left = left + dx;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.SQUARE,
                ),
              )
            : Container(),

        //center
        isEditing
            ? Positioned(
                top: top + height / 2 - ballDiameter / 2,
                left: left + width / 2 - ballDiameter / 2,
                child: ManipulatingBall(
                  ballDiameter: ballDiameter * 2,
                  handlerColor: Colors.black,
                  onDrag: (dx, dy) {
                    setState(() {
                      top = top + dy;
                      left = left + dx;
                      checkBoundary();
                    });
                  },
                  handlerWidget: HandlerWidget.CIRCLE,
                ),
              )
            : Container(),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall(
      {Key key,
      this.onDrag,
      this.handlerWidget,
      this.handlerColor,
      this.ballDiameter});

  final Function onDrag;
  final HandlerWidget handlerWidget;
  final Color handlerColor;
  final double ballDiameter;
  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

enum HandlerWidget { CIRCLE, SQUARE }

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;
  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = (details.globalPosition.dx - initX) * 3;
    var dy = (details.globalPosition.dy - initY) * 3;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: widget.ballDiameter,
        height: widget.ballDiameter,
        decoration: BoxDecoration(
          color: widget.handlerColor,
          shape: this.widget.handlerWidget == HandlerWidget.CIRCLE
              ? BoxShape.circle
              : BoxShape.rectangle,
        ),
      ),
    );
  }
}
