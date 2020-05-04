import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/screens/netowrk_memes.dart';
import 'package:meme_generator/utils/custom_page_router.dart';
import 'package:meme_generator/utils/painter.dart';
import 'package:meme_generator/utils/resizeable.dart';
import 'package:meme_generator/utils/text_properties.dart';
import 'package:meme_generator/utils/text_styles.dart';
import 'package:meme_generator/widget/floating_action_extended_animator.dart';
import 'package:meme_generator/widget/draggable_text.dart';
import 'package:meme_generator/widget/options_dialog.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageToGenerate extends StatefulWidget {
  ImageToGenerate({
    Key key,
    this.height,
    this.width,
    this.url,
  }) : super(key: key);

  final double height;
  final double width;
  final String url;

  @override
  ImageToGenerateState createState() => ImageToGenerateState();
}

class ImageToGenerateState extends State<ImageToGenerate> {
  final GlobalKey _imageKey = new GlobalKey();
  GlobalKey _containerKey = GlobalKey();
  File _image;
  Size sizeContainer = Size(0, 0);
  File _imageSaved;
  List<Widget> movableItems = [];
  Random random = new Random();
  bool imageSelected = false;
  double imageHeight, imageWidth;
  String imgUrl;
  @override
  void initState() {
    super.initState();
    imgUrl = widget.url;
  }

  _getSize() {
    setState(() {
      final RenderBox renderContainer =
          _containerKey.currentContext.findRenderObject();
      sizeContainer = renderContainer.size;
      print(sizeContainer);
    });
  }

  getImageFromStorage() {
    imgUrl = null;
    getImage();
  }

  getImageFromNetwork() {
    Navigator.push(
      context,
      CustomPageRoute(widget: ImageFromNetwork()),
    );
  }

  share() async {
    RenderRepaintBoundary boundary =
        _imageKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    await Share.file(
      'Share this meme',
      'LetsMeme.png',
      pngBytes,
      'image/png',
    );
  }

  Future<Size> getImageSize() async {
    if (_image != null) {
      var decodedSize = await decodeImageFromList(_image.readAsBytesSync());
      imageHeight = decodedSize.height.toDouble();
      imageWidth = decodedSize.width.toDouble();
      return Size(imageWidth, imageHeight);
    }
    if (imgUrl != null) {
      imageHeight = widget.height;
      imageWidth = widget.width;
      return Size(imageWidth, imageHeight);
    }
    return Size(0, 0);
  }

  takeScreenShot() async {
    RenderRepaintBoundary boundary =
        _imageKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File('$directory/screenshot${random.nextInt(2000)}.png');
    setState(() {
      _imageSaved = imgFile;
    });
    _saveImage(_imageSaved);
    imgFile.writeAsBytes(pngBytes);
    print('Saved');
  }

  _saveImage(File file) async {
    await _askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
    print(result);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Saved successfully.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  _askPermission() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.photos, Permission.storage].request();
    print('$permissions[Permission.photos], $permissions[Permission.storage]');
  }

  Future getImage() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (platformException) {
      print('Not Allowed' + platformException.toString());
    }

    setState(() {
      if (image != null) {
        imageSelected = true;
      }
      _image = image;
    });
    new Directory('storage/emulated/0/' + 'MemeGenerator')
        .create(recursive: true);
  }

  editText() async {
    setState(() {
      _getSize();
    });
    TextProperties textProperties = new TextProperties(
      fontSize: 30,
      fontColor: Colors.black,
      text: '',
      bgColor: Colors.white,
      isTrasparent: false,
    );
    await showDialog<double>(
      context: context,
      builder: (context) => EditTextProperties(
        textProperties: textProperties,
      ),
      barrierDismissible: false,
    ).then((_) {
      setState(() {});
    });
    setState(() {
      _getSize();
      movableItems.add(ResizebleWidget(
        bottomBoundary: sizeContainer.height,
        rightBoundary: sizeContainer.width,
        textProperties: textProperties,
      ));
    });
  }

  editImage() async {
    await showDialog(
      context: context,
      builder: (context) => OptionsDialog(
          optionIcons: [Icons.storage, Icons.network_wifi],
          optionLabels: ['From Storage', 'From Network'],
          optionOnTap: [getImageFromStorage, getImageFromNetwork],
          title: 'Change the template'),
      barrierDismissible: false,
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return imageSelected
        ? showImageSelected()
        : imgUrl != null
            ? showImageSelected()
            : showImageNotSelected(width, height);
  }

  optionWhenNotSelected() {
    return AddAnimation(
      functions: [getImageFromStorage, getImageFromNetwork],
      icons: [Icons.storage, Icons.network_wifi],
      labels: ['From Storage', 'From Network'],
      primaryIcon: Icons.image,
      primaryLabel: 'Get an image',
    );
  }

  optionWhenSelected() {
    return AddAnimation(
      functions: [editText, editImage],
      icons: [Icons.text_fields, Icons.image],
      labels: ['Add Text', 'Change Image'],
      primaryIcon: Icons.edit,
      primaryLabel: 'Edit',
    );
  }

  showImageNotSelected(width, height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              painter: ContainerPainter(
                color: Color(0xFF202540),
                tlFactor: 0.2,
                trFactor: 0.2,
                blFactor: 0.8,
                brFactor: 0.8,
              ),
              child: Container(
                padding: EdgeInsets.all(8),
                // margin: EdgeInsets.all(8),
                width: width,
                height: height * 0.4,
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'To get started, pick an image from the storage or the network.\nCreate memes and share instantly.',
                      textAlign: TextAlign.center,
                      style: bodyStyle,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: optionWhenNotSelected()),
      ],
    );
  }

  showImageSelected() {
    return FutureBuilder(
      future: getImageSize(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            Size imageSize = snapshot.data;
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FloatingActionButton.extended(
                            onPressed: () async {
                              takeScreenShot();
                            },
                            label: Text('Save', style: dialogOptions),
                            icon: Icon(Icons.file_download)),
                        FloatingActionButton.extended(
                            onPressed: () async {
                              share();
                            },
                            label: Text('Share', style: dialogOptions),
                            icon: Icon(Icons.share)),
                      ],
                    ),
                  ),
                  FittedBox(
                    child: RepaintBoundary(
                      key: _imageKey,
                      child: Container(
                        color: Colors.white,
                        key: _containerKey,
                        height: imageSize.height,
                        width: imageSize.width,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                height: imageSize.height,
                                width: imageSize.width,
                                child: _image != null
                                    ? Image.file(
                                        _image,
                                        fit: BoxFit.contain,
                                      )
                                    : imgUrl != null
                                        ? Image.network(
                                            imgUrl,
                                            fit: BoxFit.contain,
                                          )
                                        : Container(),
                              ),
                            ),
                            Stack(
                              children: movableItems,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: optionWhenSelected()),
                ],
              ),
            );
          } else
            return CircularProgressIndicator();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
