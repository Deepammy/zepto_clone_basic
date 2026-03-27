import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state_management/product_notifier_provider.dart';
import '../state_management/product_state.dart';
import '../widgets/product_card.dart';

class ProductsListView extends ConsumerStatefulWidget {
  const ProductsListView({super.key});

  @override
  ConsumerState<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends ConsumerState<ProductsListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(productNotifierProvider.notifier).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Builder(
        builder: (context) {
          if (state is ProductInitial) {
            return const Center(child: Text('Welcome'));
          } else if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            final products = state.products;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  ProductCard(product: products[index]),
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
