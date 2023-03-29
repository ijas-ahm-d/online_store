import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_api/widgets/feeds_widget.dart';

import '../models/products_model.dart';
import '../services/api_handler.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductModel> productList = [];
  int limit = 10;
  // final bool _isLoading = false;
  final bool _isLimit = false;
  @override
  void initState() {
    getProduct();
    super.initState();
  }

  Future<void> getProduct() async {
    productList = await ApiHandler.getAllProducts(limit: limit.toString());
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _isLoading = true;
        limit += 10;
        if (limit == 200) {
          _isLimit == true;
          setState(() {
            
          });
          return;
        }
        await getProduct();
        // _isLoading = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 4,
        title: const Text('All Products'),
      ),
      body: productList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                              childAspectRatio: 0.68),
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                          value: productList[index],
                          child: const FeedsWidget(),
                        );
                      }),
                  if (!_isLimit)
                    const Center(child: CircularProgressIndicator())
                ],
              ),
            ),
    );
  }
}
