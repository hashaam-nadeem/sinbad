import 'package:flutter/material.dart';
//import 'package:shop_app/models/Product.dart';

//import '../../../constants.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.filterName,
  }) : super(key: key);

  final filterName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        filterName.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
