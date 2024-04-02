import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/productmodel.dart';
import '../pages/ItemPage.dart';

class ItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(
            child: Text("loi"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 300,
            child: Center(
              // child: CupertinoActionSheet(),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text("khong co san pham nao!"),
          );
        }
        if(snapshot.data != null){
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
            itemBuilder: (context,index){
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
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ItemPage(singleProduct: productModel),
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
                                productModel.price +" VNĐ",
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
    );
    // return GridView.count(
    //   childAspectRatio: 0.68,
    //   physics: NeverScrollableScrollPhysics(),
    //   crossAxisCount: 2,
    //   shrinkWrap: true,
    //   children: [
    //     for(int i=1; i<8; i++)
    //       Container(
    //       padding: EdgeInsets.only(left: 15, right: 15, top: 10),
    //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Container(
    //                 padding: EdgeInsets.all(5),
    //                 decoration: BoxDecoration(
    //                   color: Color(0xFF4C53A5),
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 child: Text(
    //                   "-50%",
    //                   style: TextStyle(
    //                     fontSize: 14,
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //               Icon(
    //                 Icons.favorite_border,
    //                 color: Colors.red,
    //               ),
    //             ],
    //           ),
    //           InkWell(
    //             onTap: (){
    //               Navigator.pushNamed(context, "itemPage");
    //             },
    //             child: Container(
    //               margin: EdgeInsets.all(10),
    //               child: Image.asset(
    //                 "images/$i.png",
    //                 height: 120,
    //                 width: 120,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.only(bottom: 8),
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               "Tiêu đề sản phẩm",
    //               style: TextStyle(
    //                 fontSize: 18,
    //                 color: Color(0xFF4C53A5),
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           Container(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               "Description",
    //               style: TextStyle(
    //                 fontSize: 15,
    //                 color: Color(0xFF4C53A5),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.symmetric(vertical: 10),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   "\$55",
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                     color: Color(0xFF4C53A5),
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 Icon(
    //                   Icons.shopping_cart_checkout,
    //                   color: Color(0xFF4C53A5),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
