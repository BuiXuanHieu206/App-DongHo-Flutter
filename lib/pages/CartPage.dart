import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controllers/cart_controller.dart';
import '../models/cartmodel.dart';
import '../widgets/CartAppBar.dart';

class CartPage extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                //    child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            check = false;
            return Center(
              child: Column(
                children: [
                  CartAppBar(),
                  Container(height: 100,),
                  Text(
                    "Không có sản phẩm!",
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.data != null) {
            check = true;
            return ListView(
              children: [
                CartAppBar(),
                Container(
                      height: 700,
                      padding: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFEDECF2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          CartModel cartModel = CartModel(
                            productID: productData['productID'],
                            categoryId: productData['categoryId'],
                            productName: productData['productName'],
                            categoryName: productData['categoryName'],
                            price: productData['price'],
                            productImages: productData['productImages'],
                            productDescription: productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt'],
                            productQuantity: productData['productQuantity'],
                            productTotalPrice: double.parse(
                                productData['productTotalPrice'].toString()),
                          );
                          String giaString = cartModel.price.replaceAll('.', '');
                          double giaDouble = double.parse(giaString);
                          double total = cartModel.productTotalPrice;


                          final formatter = NumberFormat('#,###');
                          String totalString = formatter.format(total);
                          //calculate price
                          productPriceController.fetchProductPrice();

                          return SwipeActionCell(
                            backgroundColor: Color(0xFFEDECF2),
                            key: ObjectKey(cartModel.productID),
                            trailingActions: [
                              SwipeAction(
                                title: "Delete",
                                forceAlignmentToBoundary: true,
                                performsFirstActionWithFullSwipe: true,
                                onTap: (CompletionHandler handler) async {
                                  print('deleted');
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(user!.uid)
                                      .collection('cartOrders')
                                      .doc(cartModel.productID)
                                      .delete();
                                },
                              )
                            ],
                            child: Container(
                              height: 110,
                              margin:EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Radio(
                                    value: "",
                                    groupValue: "",
                                    activeColor: Color(0xFF4C53A5),
                                    onChanged: (index) {},
                                  ),
                                  Container(
                                    height: 70,
                                    width: 70,
                                    margin: EdgeInsets.only(right: 15),
                                    child: Image.network(cartModel.productImages),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          cartModel.productName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4C53A5),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          totalString + " VNĐ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4C53A5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartModel.productQuantity > 0) {
                                                  await FirebaseFirestore.instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('cartOrders')
                                                      .doc(cartModel.productID)
                                                      .update({
                                                    'productQuantity':
                                                    cartModel.productQuantity + 1,
                                                    'productTotalPrice':
                                                    (giaDouble)  +
                                                        (giaDouble) *
                                                            (cartModel.productQuantity)
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                      Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.plus,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                '${cartModel.productQuantity}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF4C53A5),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartModel.productQuantity > 1) {
                                                  await FirebaseFirestore.instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('cartOrders')
                                                      .doc(cartModel.productID)
                                                      .update({
                                                    'productQuantity':
                                                    cartModel.productQuantity - 1,
                                                    'productTotalPrice':
                                                    ((giaDouble) *
                                                        (cartModel.productQuantity - 1))
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                      Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.minus,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              ],
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng cộng:",
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => Text(
                    " ${NumberFormat('#,###').format(productPriceController.totalPrice.value)} VND",
                    style: TextStyle(
                      color: Color(0xFF4C53A5),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF4C53A5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed:() async{
                    if(check==true)
                      _clearCartAndShowSuccessDialog();
                    else{
                      Get.snackbar(
                        "Giỏ hàng không có sản phẩm để thanh toán!",
                        "",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: Color(0xFF4C53A5),
                      );
                    }
                  },
                  child: Text(
                    "Thanh toán",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _clearCartAndShowSuccessDialog() async {
    // Clear cart items
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
    Get.snackbar(
      "Thanh toán thành công!",
      "",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Color(0xFF4C53A5),
    );
  }
  Future<void> deleteCartItem() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user!.uid)
          .collection('cartOrders')
          .doc('productId')
          .delete();
      Get.snackbar(
        "Thanh toán thành công!",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Color(0xFF4C53A5),
      );
    } catch (e) {
      print('Lỗi khi xóa sản phẩm: $e');
      // Xử lý lỗi nếu cần thiết
    }
  }
}
