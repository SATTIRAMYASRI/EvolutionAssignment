part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

class GetDataFromApi extends CartState {
  List<dynamic> productsList;
  bool isLoading;
  GetDataFromApi({required this.productsList, required this.isLoading});

  List<Object> get props => [productsList, isLoading];
}

final class AddToCart extends CartState {}

final class RemoveFromCart extends CartState {}

final class UpdateCart extends CartState {}
