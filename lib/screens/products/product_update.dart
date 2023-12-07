import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_node_store/components/image_not_found.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/screens/products/components/product_form.dart';
import 'package:flutter_node_store/services/rest_api.dart';
import 'package:flutter_node_store/utils/constants.dart';

class ProductUpdate extends StatefulWidget {
  const ProductUpdate({super.key});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {

  // สร้าง GlobalKey สำหรับฟอร์ม
  final _formKeyUpdateProduct = GlobalKey<FormState>();

  // สร้างตัวแปรสำหรับเก็บข้อมูล Product
  final _product = ProductModel(
    id: 0,
    name: null,
    description: null,
    barcode: null,
    stock: 0,
    price: 0,
    categoryId: 1,
    userId: 1,
    statusId: 1
  );

  // ไฟล์รูปภาพ
  File? _imageFile;

  @override
  Widget build(BuildContext context) {

    // รับค่า arguments ที่ส่งมาจากหน้าก่อนหน้า
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

     // set ค่าเริ่มต้นให้กับ Model
    _product.id = arguments['products']['id'];
    _product.name = arguments['products']['name'];
    _product.description = arguments['products']['description'];
    _product.barcode = arguments['products']['barcode'];
    _product.stock = arguments['products']['stock'];
    _product.price = arguments['products']['price'];
    _product.categoryId = arguments['products']['category_id'];
    _product.userId = arguments['products']['user_id'];
    _product.statusId = arguments['products']['status_id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขสินค้า'),
        actions: [
          // Save Button
          IconButton(
            onPressed: () async {
              
              if(_formKeyUpdateProduct.currentState!.validate()){
                _formKeyUpdateProduct.currentState!.save();
                // Utility().logger.d(_product.toJson());
                // Utility().logger.d(_imageFile);

                // Call API Add Product
                var response = await CallAPI().updateProductAPI (
                  _product,
                  imageFile: _imageFile
                );

                var body = jsonDecode(response);

                if(body['status'] == 'ok'){

                  if(!mounted) return; // กรณีที่ออกจากหน้าจอแล้ว ไม่ต้องทำอะไรต่อ
                  // ปิดหน้าจอและส่งค่ากลับไปยังหน้าก่อนหน้า
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);

                  // อัพเดทข้อมูลใหม่ล่าสุด
                  refreshKey.currentState!.show();
                }

              }

            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: arguments['products']['image'] != null && arguments['products']['image'].isNotEmpty ? _image(arguments['products']['image']) : const ImageNotFound(),
            ),
            ProductForm(
              _product, 
              callBackSetImage: _callBackSetImage, 
              formKey: _formKeyUpdateProduct
            ),
          ],
        ),
      ),
    );
  }

  // _image Widget
  Container _image(String image){
    String imageUrl;
    if(image.contains('://')){
      imageUrl = image;
    }else{
      imageUrl = '$baseURLImage$image';
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับเลือกรูปภาพ
  void _callBackSetImage(File? imageFile) {
    setState(() {
      _imageFile = imageFile;
    });
  }
}