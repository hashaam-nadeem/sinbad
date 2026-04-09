import 'package:flutter/material.dart';


class ProductItems extends StatelessWidget {
  final image;
  final title;
  final price;
  final Id;
  final Function press;
  const ProductItems({
    Key key,
    this.image,this.title,this.Id,
    this.press, this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[
          Expanded(
            child: Container(
              height: 120,
              width: 120,
              padding: EdgeInsets.all(10.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 320,
              // width: 240,
              // decoration: BoxDecoration(
              //   //color: product.color,
              //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
              // ),
              child: Hero(
                tag: "${Id}",
                child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0),),
                    child: Image.network(image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0.0, 0, 0),
            //padding: const EdgeInsets.symmetric(vertical: 10 / 4, horizontal: 20.0),
            child: Text(
              // products is out demo list
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,fontSize: 14.0, fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0.0, 0, 0),
            child: Text("Price - ${price.toString()}"
              // products is out demo list
              ,
              style: TextStyle(
                color: Theme.of(context).primaryColor,fontSize: 14.0, fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Align(alignment: Alignment.topLeft,
          // child: Text("Price - ${price.toString()}"
          //   // products is out demo list
          //   ,
          //   style: TextStyle(
          //     color: Theme.of(context).primaryColor,fontSize: 14.0, fontWeight: FontWeight.bold,
          //   ),
          // ),)
          // Text(
          //   "\$${product.price}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
}