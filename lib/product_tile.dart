import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final int? id;
   final String? title;
   final num? price;
   final String? description;
   final String? category;
   final String? image;
   final Map<String,num>? rating;

  const ProductTile({super.key,this.id,this.title,this.price,this.description,this.category,this.image,this.rating});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}