import 'package:flutter/material.dart';
import 'package:sqflite_crud_project/screens/add_data.dart';
import 'package:sqflite_crud_project/screens/update_product.dart';

import 'helper/database_helper.dart';
import 'model/product_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late DBHelper dbHelper;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _fetchProducts();
  }

  _fetchProducts() async {
    final data = await dbHelper.fetchProducts();
    setState(() {
      products = data.map((product) => Product.fromMap(product)).toList();
    });
  }

  void _onProductAdded() {
    _fetchProducts();
  }

  void _onProductUpdated() {
    _fetchProducts();
  }

  void _updateProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          product: product,
          onProductUpdated: _onProductUpdated,
        ),
      ),
    );
  }

  void _deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);
    _fetchProducts(); // Refresh the product list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.description} - \$${product.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateProduct(product),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteProduct(product.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(onProductAdded: _onProductAdded),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
