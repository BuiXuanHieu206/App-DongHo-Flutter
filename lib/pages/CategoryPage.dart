import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/categoriesmodel.dart';
import '../models/productmodel.dart';
import 'ItemPage.dart';

class CategoryPage extends StatefulWidget {
  final CategoriesModel singleCategory;

  const CategoryPage({super.key, required this.singleCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Sản phẩm",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .where('categoryId',
                      isEqualTo: widget.singleCategory.categoryId)
                  .get(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(
                    child: Text("loi"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: Get.height / 5,
                    child: Center(
                        //     child: CupertinoActionSheet(),
                        ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("No category found!"),
                  );
                }
                if (snapshot.data != null) {
                  return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.90,
                    ),
                    itemBuilder: (context, index) {
                      final productData = snapshot.data!.docs[index];
                      ProductModel productModel = ProductModel(
                        categoryId: productData['categoryId'],
                        productID: productData['productID'],
                        categoryName: productData['categoryName'],
                        price: productData['price'],
                        productDescription: productData['productDescription'],
                        productImages: productData['productImages'],
                        productName: productData['productName'],
                        createdAt: productData['createdAt'],
                        updatedAt: productData['updatedAt'],
                        discount: productData['discount'],
                      );
                      return Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4C53A5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    productModel.discount,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ItemPage(singleProduct: productModel),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Image.network(
                                  productModel.productImages,
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                productModel.productName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF4C53A5),
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    productModel.price + " VNĐ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4C53A5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.shopping_cart_checkout,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
