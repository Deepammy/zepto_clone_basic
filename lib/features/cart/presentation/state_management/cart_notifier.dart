import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/update_cart_item.dart';
import '../../domain/usecases/remove_from_cart.dart';
import 'cart_state.dart';

class CartNotifier extends StateNotifier<CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final UpdateCartItem updateCartItem;
  final RemoveFromCart removeFromCart;

  CartNotifier(
    this.getCartItems,
    this.addToCart,
    this.updateCartItem,
    this.removeFromCart,
  ) : super(CartInitial());

  Future<void> fetchCartItems() async {
    state = CartLoading();
    final result = await getCartItems(NoParams());
    result.fold(
      (failure) => state = const CartError('Failed to load cart'),
      (items) => state = CartLoaded(items),
    );
  }

  Future<void> addItemToCart(CartItem item) async {
    final currentState = state;

    if (currentState is CartLoaded) {
      final updatedItems = List<CartItem>.from(currentState.items);

      final index = updatedItems.indexWhere(
        (cartItem) => cartItem.product.id == item.product.id,
      );

      if (index != -1) {
        final existingItem = updatedItems[index];
        updatedItems[index] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
      } else {
        updatedItems.add(item);
      }

      state = currentState.copyWith(items: updatedItems);
    }

    final result = await addToCart(AddToCartParams(item));

    result.fold((failure) {
      if (currentState is CartLoaded) {
        state = currentState;
      } else {
        state = const CartError('Failed to add item');
      }
    }, (_) {});
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final oldItems = List<CartItem>.from(currentState.items);

    final updatedItems = currentState.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = currentState.copyWith(items: updatedItems);

    final result = await updateCartItem(
      UpdateCartItemParams(productId, quantity),
    );

    result.fold((failure) {
      state = currentState.copyWith(items: oldItems);
    }, (_) {});
  }

  Future<void> removeItemFromCart(String productId) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    final oldItems = List<CartItem>.from(currentState.items);

    final updatedItems = currentState.items
        .where((item) => item.product.id != productId)
        .toList();

    state = currentState.copyWith(items: updatedItems);

    final result = await removeFromCart(RemoveFromCartParams(productId));

    result.fold((failure) {
      state = currentState.copyWith(items: oldItems);
    }, (_) {});
  }
}
