import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zepto_clone/features/products/domain/entities/product.dart';
import 'package:zepto_clone/features/products/presentation/state_management/product_notifier_provider.dart';
import 'package:zepto_clone/shared/widgets/custom_loader.dart';
import '../../state_management/admin_notifier_provider.dart';
import '../../state_management/admin_state.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  bool _isAvailable = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    ref.listenManual<AdminState>(adminNotifierProvider, (previous, next) {
      if (next is AdminError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
      }

      if (next is AdminSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
        _clearForm();
        ref.read(adminNotifierProvider.notifier).reset();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select an image')));
        return;
      }

      AppCustomLoader.show();

      await ref.read(adminNotifierProvider.notifier).addNewProduct(
        Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: '',
          category: _categoryController.text,
          isAvailable: _isAvailable,
        ),
        _selectedImage!,
        () {
          ref.read(productNotifierProvider.notifier).fetchProducts();
          setState(() {
            _selectedImage = null;
          });
        },
      );

      AppCustomLoader.hide();
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _categoryController.clear();
    setState(() => _isAvailable = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminNotifierProvider);

    File? selectedImage;
    bool isUploading = false;

    if (state is AdminLoaded) {
      selectedImage = _selectedImage;
      isUploading = state.isUploading;
    } else if (state is AdminLoading) {
      selectedImage = state.selectedImage;
      isUploading = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    double.tryParse(value!) == null ? 'Invalid price' : null,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        selectedImage,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: isUploading ? null : pickImage,
                    child: const Text('Select Image from Gallery'),
                  ),
                ],
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isUploading ? null : _addProduct,
                child: Text(isUploading ? 'Adding...' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
