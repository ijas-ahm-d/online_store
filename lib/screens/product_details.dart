// import 'dart:math';

import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:store_api/const/global_colors.dart';
import 'package:store_api/models/products_model.dart';
import 'package:store_api/services/api_handler.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.id});
  final String id;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final titleStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  ProductModel? productModel;
  bool isError = false;
  String errorStr = '';
  Future<void> getProductInfo() async {
    try {
      productModel = await ApiHandler.getProductById(id: widget.id);
    } catch (error) {
      isError = true;
      errorStr = error.toString();
      log("error $error");
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    getProductInfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: isError
              ?  Center(
                  child: Text(
                    "An Error Occured $errorStr",
                    style:const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : productModel == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          const BackButton(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productModel!.category!.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Text(
                                        productModel!.title.toString(),
                                        textAlign: TextAlign.start,
                                        style: titleStyle,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: '\$',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            color:
                                                Color.fromRGBO(33, 150, 243, 1),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: productModel!.price
                                                  .toString(),
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: lightTextColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.4,
                            child: Swiper(
                              itemCount: productModel!.images!.length,
                              itemBuilder: (context, index) {
                                return FancyShimmerImage(
                                  width: double.infinity,
                                  imageUrl:
                                      productModel!.images![index].toString(),
                                  boxFit: BoxFit.fill,
                                );
                              },
                              autoplay: true,
                              pagination: const SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                  color: Colors.white,
                                  activeColor: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description', style: titleStyle),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  productModel!.description.toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
    );
  }
}
