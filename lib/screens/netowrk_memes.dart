import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meme_generator/utils/custom_page_router.dart';
import 'package:meme_generator/utils/text_styles.dart';

import 'home.dart';

import 'package:meme_generator/widget/options_dialog.dart';

class ImageFromNetwork extends StatefulWidget {
  @override
  _ImageFromNetworkState createState() => _ImageFromNetworkState();
}

class _ImageFromNetworkState extends State<ImageFromNetwork> {
  String url;
  String name;
  List allMemes = [];
  List filteredMemes = [];
  bool isSearching = false;
  bool isLoading = true;
  final searchInputController = TextEditingController();
  void findCountry(value) {
    filteredMemes = allMemes
        .where(
          (meme) => (meme['name'].toLowerCase()).contains(value.toLowerCase()),
        )
        .toList();
  }

// toggle appbar icon
  GestureDetector toggleAppBarIcon() {
    GestureDetector displayedIcon;
    if (isSearching) {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.cancel,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
            filteredMemes = allMemes;
            // reassign filteredMemes to original list when the search bar collapses
          });
        },
      );
    } else {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.search,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
      );
    }
    return displayedIcon;
  }

  Future getData() async {
    http.Response response =
        await http.get('https://api.imgflip.com/get_memes');
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      Map<String, dynamic> map = jsonDecode(response.body);
      //print(map);
      setState(() {
        allMemes = map['data']['memes'];
        filteredMemes = allMemes;
        isLoading = false;
      });
      // print(allMemes);
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pop(context);
        },),
        title: isSearching
            ? Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  //color: widget.isDark ? kBoxDarkColor : Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        style:dialogOptions,
                        controller: searchInputController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintStyle: dialogOptions,
                          hintText: 'Search',
                        ),
                        onChanged: (value) {
                          setState(() {
                            value == ''
                                ? filteredMemes = allMemes
                                : findCountry((value.toLowerCase()));
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            : Text('All Memes', style: bodyStyle,),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: toggleAppBarIcon(),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: (filteredMemes.length != 0)
                      ? List.generate(filteredMemes.length, (i) {
                          return ShowMeme(
                            meme: filteredMemes.elementAt(i),
                          );
                        })
                      : <Widget>[
                          SizedBox(
                            height: height / 2.5,
                          ),
                          Center(child: Text('No match found', style: memeName,), )
                        ],
                ),
              ),
            ),
    );
  }
}

class ShowMeme extends StatelessWidget {
  final Map meme;
  const ShowMeme({Key key, this.meme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    memeSelected() {
      Navigator.pushReplacement(
          context,
          CustomPageRoute(
              widget: HomeView(
            url: meme['url'],
            imgHeight: meme['height'],
            imgWidth: meme['width'],
          )));
    }

    memeNotSelected() {
      Navigator.pop(context);
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          await showDialog<double>(
            context: context,
            builder: (context) => OptionsDialog(
                optionIcons: [Icons.add_a_photo, Icons.navigate_next],
                optionLabels: ['Use this template', 'Find another'],
                optionOnTap: [memeSelected, memeNotSelected],
                title: 'Like this template?'),
            barrierDismissible: false,
          );
        },
        child: Container(
          width: double.infinity,
          // margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: Colors.green,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 3,
              color: Colors.black87,
            ),
          ),

          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.4,
                width: width,
                margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Image.network(meme['url'], fit: BoxFit.contain),
              ),
              Container(
                child: Text(
                  meme['name'],
                  textAlign: TextAlign.center,
                  style: memeName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemeImage extends StatelessWidget {
  final meme;
  const MemeImage({Key key, this.meme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 3,
                color: Colors.black87,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.network(meme['url'], fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
