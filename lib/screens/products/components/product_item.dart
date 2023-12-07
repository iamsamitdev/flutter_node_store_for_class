import 'package:flutter/material.dart';
import 'package:flutter_node_store/components/image_not_found.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/utils/constants.dart';

class ProductItem extends StatelessWidget {

  const ProductItem({
    required this.product,
    this.onTap,
    this.isGrid,
    Key? key,
  }): super(key: key);

  final ProductModel product;
  final VoidCallback? onTap;
  final bool? isGrid;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: onTap, 
      child: LayoutBuilder(
        builder: (context, constraint) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildImage(constraint.maxHeight),
              _buildInfo()
            ],
          ),
        ),
      )
    );
  }

  // _buildImage Widget
  _buildImage(double maxHeight){
    
    // Check list or grid view
    // Case of list view
    var height = maxHeight * 0.7;

    // Case of grid view
    if(isGrid != null && isGrid == true){
      height = maxHeight * 0.6;
    }

    final image = product.image;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: image != null && image.isNotEmpty ? _image(image) : const ImageNotFound(),
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

  // _buildInfo Widget
  Expanded _buildInfo() => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name ?? '',
            style: (isGrid ?? false) 
            ? const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal
            ) : const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '฿${product.price}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '${product.stock} ชิ้น',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo
                ),
              )
            ],
          )
        ],
      ),
    )
  );
}