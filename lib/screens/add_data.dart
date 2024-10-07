import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../model/product_model.dart';


class AddProductScreen extends StatefulWidget {
  final Function onProductAdded;

  AddProductScreen({required this.onProductAdded});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  double price = 0.0;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Create a new product
      Product product = Product(name: name, description: description, price: price);
      await DBHelper().insertProduct(product.toMap());
      // Notify the parent screen
      widget.onProductAdded();
      Navigator.pop(context); // Go back to the product list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column( children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
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
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
