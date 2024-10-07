import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../model/product_model.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;
  final Function onProductUpdated;

  UpdateProductScreen({required this.product, required this.onProductUpdated});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late double price;

  @override
  void initState() {
    super.initState();
    name = widget.product.name;
    description = widget.product.description;
    price = widget.product.price;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Update the product
      Product updatedProduct = Product(
        id: widget.product.id,
        name: name,
        description: description,
        price: price,
      );
      await DBHelper().updateProduct(updatedProduct.toMap(), updatedProduct.id!);
      // Notify the parent screen
      widget.onProductUpdated();
      Navigator.pop(context); // Go back to the product list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                initialValue: name,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a product name.';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                initialValue: description,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a description.';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                initialValue: price.toString(),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a price.';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    price = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
