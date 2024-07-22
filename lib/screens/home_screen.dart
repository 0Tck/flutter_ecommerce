import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedSortOption = 'price';
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 1000;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<ProductProvider>(context, listen: false).loadMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-commerce App'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                Provider.of<ProductProvider>(context, listen: false).searchProducts(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedSortOption,
                onChanged: (value) {
                  setState(() {
                    _selectedSortOption = value!;
                  });
                  Provider.of<ProductProvider>(context, listen: false).sortProducts(_selectedSortOption);
                },
                items: <String>['price', 'popularity', 'rating'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                hint: Text('Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  Provider.of<ProductProvider>(context, listen: false).filterProducts(_selectedCategory, _minPrice, _maxPrice);
                },
                items: <String>['electronics', 'jewelery', 'men\'s clothing', 'women\'s clothing']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return productProvider.products.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: productProvider.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: productProvider.products[index]);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
