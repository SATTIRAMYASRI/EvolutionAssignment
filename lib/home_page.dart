import 'package:evolution_assignment/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CartCubit _cartCubit;

  @override
  void initState() {
    super.initState();
    _cartCubit = CartCubit();
    _cartCubit.getDataFromApi();
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double aspectRatio = 4;

    if (screenWidth < 600) {
      aspectRatio = 1;
    } else if (screenWidth < 1200) {
      aspectRatio = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        bloc: _cartCubit,
        builder: (context, state) {
          return _cartCubit.isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _cartCubit.ProductsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final product = _cartCubit.ProductsList[index];
                    final isElementInCartList = _cartCubit.cartList.any(
                      (cartItem) => cartItem["id"] == product["id"],
                    );
                    final productCount = _cartCubit.cartList.firstWhere(
                      (cartItem) => cartItem["id"] == product["id"],
                      orElse: () => {"count": 0},
                    )["count"];

                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            product["image"].toString(),
                            width: 80,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product["title"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product["category"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product["description"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product["price"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    if (isElementInCartList)
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _cartCubit
                                                  .removeFromCart(product);
                                            },
                                            child:
                                                const Text("Remove From Cart"),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              _cartCubit.updateCart(product);
                                            },
                                            child: Text(
                                                "Increase Cart Element $productCount"),
                                          ),
                                        ],
                                      )
                                    else
                                      ElevatedButton(
                                        onPressed: () {
                                          _cartCubit.addToCart(product);
                                        },
                                        child: const Text("Add to Cart"),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
