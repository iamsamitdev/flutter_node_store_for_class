// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_node_store/providers/theme_provider.dart';
import 'package:flutter_node_store/themes/colors.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatelessWidget {

  final Widget webChild;
  final Widget mobileChild;

  const ResponsiveLayout({Key? key, required this.webChild, required this.mobileChild}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          // ปิดคีย์บอร์ดเมื่อกดที่พื้นที่อื่น
          FocusScope.of(context).unfocus();
        },
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: provider.isDark ? [primaryText, primaryText]: [primaryLight, primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
          
                      // Using for responsive layout
                      child: LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ){
                          // เราจะใช้ constraints มาเช็คว่าหน้าจอของเรามีขนาดเท่าไหร่
                          Widget childWidget = mobileChild;
                          if(constraints.maxWidth > 800){
                            childWidget = webChild;
                          }
                          return childWidget;
                        }
                      ),
          
                    ),
                  ),
                ),
              ),
            )
          );
          }
        ),
      ),
    );
  }
}