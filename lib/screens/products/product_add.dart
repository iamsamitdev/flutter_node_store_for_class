import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/screens/products/components/product_form.dart';
import 'package:flutter_node_store/services/rest_api.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {

  // สร้าง GlobalKey สำหรับฟอร์ม
  final _formKeyAddProduct = GlobalKey<FormState>();

  // สร้างตัวแปรสำหรับเก็บข้อมูล Product
  final _product = ProductModel(
    name: '',
    description: '',
    barcode: '',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มสินค้าใหม่'),
        actions: [
          // Save Button
          IconButton(
            onPressed: () async {
              
              if(_formKeyAddProduct.currentState!.validate()){
                _formKeyAddProduct.currentState!.save();
                // Utility().logger.d(_product.toJson());
                // Utility().logger.d(_imageFile);

                // Call API Add Product
                var response = await CallAPI().addProductAPI(
                  _product,
                  imageFile: _imageFile
                );

                var body = jsonDecode(response);

                if(body['status'] == 'ok'){
                  
                  if(!mounted) return; // กรณีที่ออกจากหน้าจอแล้ว ไม่ต้องทำอะไรต่อ
                  Navigator.pop(context, true); // ปิดหน้าต่างและส่งค่ากลับไปยังหน้าก่อนหน้า

                  // อัพเดตหน้าจอ HomeScreen
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
            ProductForm(
              _product, 
              callBackSetImage: _callBackSetImage, 
              formKey: _formKeyAddProduct
            )
          ],
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