import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_node_store/app_router.dart';
import 'package:flutter_node_store/components/image_not_found.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/services/rest_api.dart';
import 'package:flutter_node_store/themes/colors.dart';
import 'package:flutter_node_store/utils/constants.dart';
import 'package:flutter_node_store/utils/utility.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {

    // รับค่า arguments ที่ส่งมาจากหน้าก่อนหน้า
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    // Utility().logger.d(arguments);

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(arguments['products']['name']),
      ),
      body: ListView(
        children: [
          arguments['products']['image'] != null ? Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(baseURLImage+arguments['products']['image']),
                fit: BoxFit.cover,
              ),
            ),
          ) : const Padding(
            padding: EdgeInsets.only(top:30.0),
            child: ImageNotFound(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              arguments['products']['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Text(
              'Barcode: ${arguments['products']['barcode']}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              arguments['products']['description'],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    shape: BoxShape.circle
                  ),
                  child: IconButton(
                    onPressed: (){
                     Navigator.pushNamed(
                        context, 
                        AppRouter.productUpdate,
                        arguments: {
                          'products': arguments['products']
                        }
                      );
                    }, 
                    icon: const Icon(Icons.edit)
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    shape: BoxShape.circle
                  ),
                  child: IconButton(
                    onPressed: () async {
                      // logger.i('Delete product id: ${arguments['products']['id']}');
                      // Confirm dialog
                      return showDialog(
                        barrierDismissible: false,
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ยืนยันการลบสินค้า'),
                            content: Text('คุณต้องการลบสินค้า ${arguments['products']['name']} ใช่หรือไม่?'),
                            actions: [
                              TextButton(
                                child: const Text('ยกเลิก'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                              ),
                              TextButton(
                                child: const Text('ยืนยัน'),
                                  onPressed: () async {
                                    
                                    // ลบสินค้า
                                    var response = await CallAPI().deleteProductAPI(
                                      arguments['products']['id']
                                    );
                                    
                                    var body = jsonDecode(response);
                  
                                    if(body['status'] == 'ok'){
                  
                                      if(!mounted) return;
                                      // ปิด dialog
                                      Navigator.of(context).pop();
                                      // กลับไปหน้าก่อนหน้า
                                      Navigator.of(context).pop();
                  
                                      // Refresh หน้าก่อนหน้า
                                      refreshKey.currentState?.show();
                  
                                    }
                  
                                  },
                              ),
                            ],
                          );
                        }
                      );
                    }, 
                    icon: const Icon(Icons.delete, color: Colors.white,)
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
   
  }
}