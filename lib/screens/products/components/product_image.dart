import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_node_store/utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProductImage extends StatefulWidget {
  final Function(File? file) callBackSetImage;
  final String? image;

  const ProductImage(
    this.callBackSetImage, {
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductImage>  createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _imageFile?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerImage(),
          _buildPreviewImage(),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    final image = widget.image;
    if ((image == null || image.isEmpty) && _imageFile == null) {
      return const SizedBox();
    }

    if (_imageFile != null) {
      return Stack(
        children: [
          _reuseContainer(
            Image.file(
              _imageFile!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          _buildDeleteImageButton(),
        ],
      );
    }

    return _reuseContainer(
      Image.network(
        baseURLImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _reuseContainer(Widget child) => Container(
        color: Colors.grey[100],
        margin: const EdgeInsets.only(top: 4),
        alignment: Alignment.center,
        height: 250,
        child: child,
      );

  Center _buildPickerImage() => Center(
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                      icon: const Icon(
                        Icons.image,
                        size: 30,
                      ),
                      onPressed: _modalPickerImage),
                  const Text('เลือกรูปภาพ'),
                ],
              )
            : const SizedBox(
                height: 20,
              ),
      );

  void _modalPickerImage() {
    buildListTile(
      IconData icon,
      String title,
      ImageSource source,
    ) =>
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pop();
            _pickImage(source);
          },
        );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildListTile(
                Icons.photo_camera,
                'ถ่ายภาพ',
                ImageSource.camera,
              ),
              buildListTile(
                Icons.photo_library,
                'เลือกจากคลังภาพ',
                ImageSource.gallery,
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) {
    _picker
        .pickImage(
      source: source,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        _cropImage(file.path);
      }
    }).catchError((error) {
      //todo
    });
  }

  void _cropImage(String filePath) {
    ImageCropper()
        .cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      maxWidth: 500,
      maxHeight: 500,
      //circleShape: true
    )
        .then((file) {
      if (file != null) {
        setState(
          () {
            _imageFile = File(file.path);
            widget.callBackSetImage(_imageFile);
          },
        );
      }
    });
  }

  Positioned _buildDeleteImageButton() => Positioned(
        right: -10,
        top: 10,
        child: RawMaterialButton(
          onPressed: () => _deleteImage(),
          fillColor: Colors.white,
          shape: const CircleBorder(
            side: BorderSide(
                width: 1, color: Colors.grey, style: BorderStyle.solid),
          ),
          child: const Icon(Icons.clear),
        ),
      );

  void _deleteImage() {
    setState(
      () {
        _imageFile = null;
        widget.callBackSetImage(null);
      },
    );
  }
}
