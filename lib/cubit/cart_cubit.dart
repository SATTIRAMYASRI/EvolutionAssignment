import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  List<dynamic> ProductsList = [];

  List<Map<String, dynamic>> cartList = [];

  bool isLoading = true;

  CartCubit() : super(CartInitial());

  getDataFromApi() async {
    if (ProductsList.isNotEmpty) return;
    var response =
        await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      ProductsList = jsonResponse;
      isLoading = false;
      emit(GetDataFromApi(productsList: ProductsList, isLoading: isLoading));
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  addToCart(product) {
    Map<String, dynamic> newElement = {
      "id": product["id"],
      "count": 1,
    };

    cartList.add(newElement);
    debugPrint('testing cart list ${cartList}');
    emit(AddToCart());
  }

  removeFromCart(product) {
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i]["id"] == product["id"]) {
        cartList.remove(cartList[i]);
      }
    }

    debugPrint('testing cart list ${cartList}');
    emit(RemoveFromCart());
  }

  updateCart(product) {
    for (int i = 0; i < cartList.length; i++) {
      if (cartList[i]["id"] == product["id"]) {
        cartList[i]["count"] = cartList[i]["count"] + 1;
      }
    }

    debugPrint('testing cart list ${cartList}');
    emit(UpdateCart());
  }
}
