import 'dart:io';

abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoaded extends AdminState {
  final bool isUploading;

  const AdminLoaded({
    this.isUploading = false,
  });

  AdminLoaded copyWith({
    bool? isUploading,
  }) {
    return AdminLoaded(
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class AdminLoading extends AdminState {
  final File? selectedImage;

  const AdminLoading({this.selectedImage});
}

class AdminSuccess extends AdminState {
  final String message;

  const AdminSuccess(this.message);
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);
}