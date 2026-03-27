import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/injection.dart';
import '../../products/domain/usecases/add_product.dart';
import 'admin_notifier.dart';
import 'admin_state.dart';

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AdminState>((
  ref,
) {
  return AdminNotifier(getIt<AddProduct>());
});
