import 'package:flutter/material.dart';
import 'package:meme_generator/utils/painter.dart';
import 'package:meme_generator/utils/text_styles.dart';
import './image_to_generate.dart';


class HomeView extends StatefulWidget {
  final String url;
  final int imgHeight, imgWidth;
  const HomeView({Key key, this.url, this.imgHeight, this.imgWidth}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width,
                  child: CustomPaint(
                    painter: ContainerPainter(
                      color: Color(0xFF202540),
                      tlFactor: 0.05,
                      trFactor: 0.05,
                      blFactor: 0.2,
                      brFactor: 0.2,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      // margin: EdgeInsets.all(8),
                      width: width * 0.5,
                      //height: height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: <Widget>[
                          Image.asset(
                            'assets/images/haha.png',
                            width: width / 3,
                          ),
                          Text(
                            'Let\'s MEME',
                            style: mainTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height*0.01 ),
                widget.url!=null?ImageToGenerate(
                  height: widget.imgHeight.toDouble(),
                  width: widget.imgWidth.toDouble(),
                  url: widget.url,
                ) :
                ImageToGenerate(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
