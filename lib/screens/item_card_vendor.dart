import 'package:flutter/material.dart';


class ItemCard extends StatelessWidget {
  final image;
  final title;
  final Id;
  final Function press;
  const ItemCard({
    Key key,
    this.image,this.title,this.Id,
    this.press,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var placeholder = AssetImage("images/applogo.png");
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              height: 320,
              width: 240,
              // decoration: BoxDecoration(
              //   //color: product.color,
              //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
              // ),
              child: Hero(
                tag: "${Id}",
                child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),/*bottom: Radius.circular(25.0),*/),
                    child: image == null? placeholder :Image.network(image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10 / 5),
            child: Center(
              child: Text(
                // products is out demo list
                title,
                style: TextStyle(
                  color: Colors.white,fontSize: 14.0, fontWeight: FontWeight.bold,
                ),
              ),
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