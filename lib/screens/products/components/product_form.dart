import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_node_store/components/custom_textfield.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/screens/products/components/product_image.dart';

class ProductForm extends StatefulWidget {
  final ProductModel product;
  final Function(File? file) callBackSetImage;
  final GlobalKey<FormState> formKey;

  const ProductForm(
    this.product, {
    required this.callBackSetImage,
    required this.formKey,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              customTextFieldProduct(
                initialValue: widget.product.name.toString(),
                obscureText: false,
                hintText: 'ชื่อสินค้า',
                prefixIcon: const Icon(Icons.shopping_bag_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อสินค้า';
                  }
                  return null;
                },
                onSaved: (value) => widget.product.name = value!,
              ),
              const SizedBox(height: 10),
              customTextFieldProduct(
                initialValue: widget.product.barcode.toString(),
                obscureText: false,
                hintText: 'บาร์โค้ดสินค้า',
                textInputType: TextInputType.number,
                prefixIcon: const Icon(Icons.qr_code_scanner_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกบาร์โค้ดสินค้า';
                  }
                  return null;
                },
                onSaved: (value) => widget.product.barcode = value!,
              ),
              const SizedBox(
                height: 10,
              ),
              customTextFieldProduct(
                initialValue: widget.product.description.toString(),
                obscureText: false,
                hintText: 'รายละเอียดสินค้า',
                textInputType: TextInputType.multiline,
                maxLines: 5,
                prefixIcon: const Icon(Icons.description_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรายละเอียดสินค้า';
                  }
                  return null;
                },
                onSaved: (value) => widget.product.description = value!,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: customTextFieldProduct(
                      initialValue: widget.product.price.toString(),
                      obscureText: false,
                      hintText: 'ราคาสินค้า',
                      textInputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.attach_money_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกราคาสินค้า';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          widget.product.price = int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: customTextFieldProduct(
                      initialValue: widget.product.stock.toString(),
                      obscureText: false,
                      hintText: 'จำนวนสินค้า',
                      textInputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.shopping_cart_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกจำนวนสินค้า';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          widget.product.stock = int.parse(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: customTextFieldProduct(
                      initialValue: widget.product.categoryId.toString(),
                      obscureText: false,
                      hintText: 'หมวดหมู่',
                      textInputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.category_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกหมวดหมู่สินค้า';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          widget.product.categoryId = int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: customTextFieldProduct(
                      initialValue: widget.product.userId.toString(),
                      obscureText: false,
                      hintText: 'ผู้ใช้',
                      textInputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกผู้ใช้งาน';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          widget.product.userId = int.parse(value!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: customTextFieldProduct(
                      initialValue: widget.product.statusId.toString(),
                      obscureText: false,
                      hintText: 'สถานะ',
                      textInputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.check_circle_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกสถานะสินค้า';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          widget.product.statusId = int.parse(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ProductImage(
                widget.callBackSetImage,
                image: widget.product.image,
              ),
            ],
          ),
        ));
  }
}
