import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
class AddAnimation extends StatefulWidget {
  AddAnimation({
    Key key,
    this.functions,
    this.icons,
    this.labels,
    this.primaryLabel,
    this.primaryIcon,
  }) : super(key: key);
  final List<Function> functions;
  final List<IconData> icons;
  final List<String> labels;
  final String primaryLabel;
  final IconData primaryIcon;
  @override
  _AddAnimationState createState() => _AddAnimationState();
}

class _AddAnimationState extends State<AddAnimation>
    with TickerProviderStateMixin {
  List<IconData> icons;
  List<String> labels;
  List<Function> onPressed;
  String primaryLabel;
  IconData primaryIcon;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    icons = widget.icons;
    labels = widget.labels;
    onPressed = widget.functions;
    primaryIcon = widget.primaryIcon;
    primaryLabel = widget.primaryLabel;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(AddAnimation oldWidget) {
    if (oldWidget.icons != widget.icons) {
      icons = widget.icons;
      labels = widget.labels;
      onPressed = widget.functions;
      primaryIcon = widget.primaryIcon;
      primaryLabel = widget.primaryLabel;
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: FloatingActionButton.extended(
            onPressed: () {
              if (_controller.isDismissed)
                _controller.forward();
              else
                _controller.reverse();
            },
            label: Text(primaryLabel, style: dialogOptions),
            icon: Icon(primaryIcon),
            heroTag: null,
          )),
        ),
        Wrap(
          runSpacing: 10,
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
          children: List.generate(icons.length, (i) {
            Widget child = Container(
              margin: EdgeInsets.only(left: 8),
              child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    reverseCurve: Interval(0, 1.0, curve: Curves.easeOutCubic),
                    curve: Interval(0.0, 1.0, curve: Curves.easeInCubic),
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: onPressed[i],
                    label: Text(labels[i], style: dialogOptions),
                    icon: Icon(icons[i]),
                    heroTag: null,
                  )),
            );
            return child;
          }).toList(),
        ),
      ],
    );
  }
}
