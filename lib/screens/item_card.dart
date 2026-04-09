import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCard extends StatefulWidget {
  final image;
  final title;
  final titleAr;
  final Id;
  final Function press;

  const ItemCard({
    Key key,
    this.image,
    this.title,
    this.Id,
    this.press,
    this.titleAr,
  }) : super(key: key);

  @override
  _ItemCardState createState() =>
      _ItemCardState(image, title, titleAr, Id, press);
}

class _ItemCardState extends State<ItemCard> {
  final image;
  final title;
  final titleAr;
  final Id;
  final Function press;
  var lang;
  var langChanged;

  _ItemCardState(this.image, this.title, this.titleAr, this.Id, this.press);

  @override
  void initState() {
    // TODO: implement initState
    //_getDepartmentData();
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    if (token != null) {
      setState(() {
        //_isLoggedIn = true;
        //_getCartItemCount();

        //print("User Is Logged In");
        // _gotoMainpage();
      });
    } else {
      print("User Is Not Logged In");
//      Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(builder: (context) => LoginPage()),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = AssetImage("images/applogo.png");
    return GestureDetector(
      onTap: widget.press,
      child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(2.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: widget.image == null
                          ? placeholder
                          : NetworkImage(widget.image))),
              // decoration: BoxDecoration(
              //   //color: product.color,
              //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
              // ),
              // child: Hero(
              //   tag: "${widget.Id}",
              //   child: ClipRRect(

              //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0),),
              //       child: ),
              // ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lang == "Ar" && langChanged != "English"
                    ? Flexible(
                        child: Text(
                          // products is out demo list
                          widget.titleAr,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Flexible(
                        child: Text(
                          // products is out demo list
                          widget.title,
                          // overflow: TextOverflow.clip,
                          // maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
              ],
            ),
          ),
          // Text(
          //   "\$${product.price}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
}
