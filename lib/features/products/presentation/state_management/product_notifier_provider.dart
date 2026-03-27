import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zepto_clone/config/injection.dart';
import 'product_notifier.dart';
import 'product_state.dart';

final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(getIt(), getIt()),
);