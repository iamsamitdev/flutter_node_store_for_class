// ignore_for_file: unused_field, must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_node_store/app_router.dart';
import 'package:flutter_node_store/components/custom_textfield.dart';
import 'package:flutter_node_store/components/rounded_button.dart';
import 'package:flutter_node_store/components/social_media_options.dart';
import 'package:flutter_node_store/services/rest_api.dart';
import 'package:flutter_node_store/utils/utility.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  // สร้าง GlobalKey สำหรับ Form นี้
  final _formKeyLogin = GlobalKey<FormState>();

  // สร้าง TextEditingController
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            "เข้าสู่ระบบ",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKeyLogin,
            child: Column(
              children: [
                customTextField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกอีเมล";
                    } else if (!value.contains("@")) {
                      return "กรุณากรอกอีเมลให้ถูกต้อง";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                customTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณากรอกรหัสผ่าน";
                    } else if (value.length < 6) {
                      return "กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัวอักษร";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        //Open Forgot password screen here
                        Navigator.pushNamed(context, AppRouter.forgotPassword);
                      },
                      child: const Text("ลืมรหัสผ่าน ?"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  label: "LOGIN",
                  onPressed: () async {
                    // ตรวจสอบข้อมูลฟอร์ม
                    if (_formKeyLogin.currentState!.validate()) {
                      // ถ้าข้อมูลผ่านการตรวจสอบ ให้ทำการบันทึกข้อมูล
                      _formKeyLogin.currentState!.save();

                      // แสดงข้อมูลที่บันทึกใน Console
                      // print("Email: ${_emailController.text}");
                      // print("Password: ${_passwordController.text}");

                      // ส่งข้อมูลไปยัง API เพื่อทำการตรวจสอบ
                      var response = await CallAPI().loginAPI({
                        "email": _emailController.text,
                        "password": _passwordController.text
                      });

                      // ตรวจสอบค่าที่ได้จาก API
                      var body = jsonDecode(response);

                      // Utility().logger.i(body);

                      if (body["message"] == "No Network Connection") {
                        // แจ้งเตือนว่าไม่มีการเชื่อมต่อ Internet
                        Utility.showAlertDialog(
                            context, '', '${body["message"]}');
                      } else {
                        if (body["status"] == "ok") {
                          // แจ้งเตือนว่าเข้าสู่ระบบสำเร็จ
                          Utility.showAlertDialog(
                              context, body["status"], '${body["message"]}');

                          // บันทึกข้อมูลลงในตัวแปร SharedPreferences
                          await Utility.setSharedPreference(
                              'loginStatus', true);
                          await Utility.setSharedPreference(
                              'token', body["token"]);
                          await Utility.setSharedPreference(
                              'firstName', body["user"]["firstname"]);
                          await Utility.setSharedPreference(
                              'lastName', body["user"]["lastname"]);
                          await Utility.setSharedPreference(
                              'email', body["user"]["email"]);

                          // ส่งไปหน้า Dashboard
                          Navigator.pushReplacementNamed(
                              context, AppRouter.dashboard);
                        } else {
                          // แจ้งเตือนว่าเข้าสู่ระบบไม่สำเร็จ
                          Utility.showAlertDialog(
                              context, body["status"], '${body["message"]}');
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SocialMediaOptions(),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ยังไม่มีบัญชีกับเรา ? "),
              InkWell(
                onTap: () {
                  //Open Sign up screen here
                  Navigator.pushReplacementNamed(context, AppRouter.register);
                },
                child: const Text(
                  "สมัครสมาชิก",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
