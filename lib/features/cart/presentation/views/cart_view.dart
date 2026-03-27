import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zepto_clone/shared/widgets/custom_loader.dart';
import '../state_management/cart_notifier_provider.dart';
import '../state_management/cart_state.dart';
import '../widgets/cart_item_widget.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(cartNotifierProvider.notifier).fetchCartItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Builder(
        builder: (context) {
          if (state is CartInitial) {
            return const Center(child: Text('Your cart is empty'));
          } else if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final items = state.items;
            final totalPrice = state.totalPrice;

            if (items.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => CartItemWidget(
                      item: items[index],
                      onUpdate: (quantity) => ref
                          .read(cartNotifierProvider.notifier)
                          .updateItemQuantity(
                            items[index].product.id,
                            quantity,
                          ),
                      onRemove: () async {
                        AppCustomLoader.show();
                        await ref
                            .read(cartNotifierProvider.notifier)
                            .removeItemFromCart(items[index].product.id);
                        AppCustomLoader.hide();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total: ₹${totalPrice.toStringAsFixed(2)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout not implemented'),
                          ),
                        );
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
