import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zepto_clone/config/injection.dart';
import 'cart_notifier.dart';
import 'cart_state.dart';

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(getIt(), getIt(), getIt(), getIt()),
);