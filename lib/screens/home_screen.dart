import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:store_api/const/global_colors.dart';
import 'package:store_api/models/products_model.dart';
import 'package:store_api/screens/categories_screen.dart';
import 'package:store_api/screens/feeds_screen.dart';
import 'package:store_api/screens/users_screen.dart';
import 'package:store_api/services/api_handler.dart';
import 'package:store_api/widgets/appbar_icons.dart';
import 'package:store_api/widgets/feeds_grid.dart';
// import 'package:store_api/widgets/feeds_widget.dart';
import 'package:store_api/widgets/sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _textEditingController;
  // List<ProductModel> productList = [];

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   getProduct();
  //   super.didChangeDependencies();
  // }

  // Future<void> getProduct() async {
  //   productList = await ApiHandler.getAllProducts();
  // setState(() {

  // });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading: AppBarIcons(
            function: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const CategoriesScreen(),
                ),
              );
            },
            icon: IconlyBold.category,
          ),
          actions: [
            AppBarIcons(
              function: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const UsersScreen(),
                  ),
                );
              },
              icon: IconlyBold.user3,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  suffixIcon: Icon(
                    IconlyLight.search,
                    color: lightIconsColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: size.height * 0.25,
                      child: Swiper(
                        itemCount: 3,
                        itemBuilder: (ctx, index) {
                          return const SaleWidget();
                        },
                        autoplay: true,
                        pagination: const SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.white, activeColor: Colors.red)),
                        // control: const SwiperControl(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Latest Products",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          AppBarIcons(
                              function: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const FeedsScreen(),
                                  ),
                                );
                              },
                              icon: IconlyBold.arrowRight2),
                        ],
                      ),
                    ),
                    // GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: 3,
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //             crossAxisCount: 2,
                    //             crossAxisSpacing: 0.0,
                    //             mainAxisSpacing: 0.0,
                    //             childAspectRatio: 0.7),
                    //     itemBuilder: (ctx, index) {
                    //       return  FeedsWidget();
                    //     })

                    FutureBuilder<List<ProductModel>>(
                      future: ApiHandler.getAllProducts(limit:3.toString() ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                        else if(snapshot.hasError){
                           Center(
                            child: Text("An Error Occured ${snapshot.error}")
                          );
                        }
                        else if(snapshot.data==null){
                         const  Center(
                            child: Text("No Products")
                          );
                        }
                        return FeedsGridWidget(productList: snapshot.data!);
                      },
                    ),

                    // productList.isEmpty
                    // ?Container()
                    // :
                    // FeedsGridWidget(productList: productList)
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
