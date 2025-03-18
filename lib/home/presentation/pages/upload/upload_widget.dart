import 'package:finance_project_sophia_flutter/home/presentation/utils/dynamic_card.dart';
import 'package:finance_project_sophia_flutter/home/presentation/utils/texts.dart';
import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

const textStyleDefault = TextStyle(
  color: Colors.white,
  fontSize: AppSizes.fontSizeMedium,
);

class ReceiptUploadCard extends StatefulWidget {
  @override
  _ReceiptUploadCardState createState() => _ReceiptUploadCardState();
}

class _ReceiptUploadCardState extends State<ReceiptUploadCard> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _saveImageLocally() async {
    if (_image == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_image!.path);
      final localImage = await _image!.copy('${directory.path}/$fileName');

      setState(() {
        _image = localImage;
      });

      print('Image saved to ${localImage.path}');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicCard(
      child: Column(
        children: [
          _image == null ? Text(AppTexts.noImageSelected) : Image.file(_image!),
          SizedBox(height: AppSizes.heightMedium),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FinanceProjectColors.orange,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingMedium,
              ),
            ),
            onPressed: _pickImage,
            child: Text(
              AppTexts.uploadReceiptSubtitle,
              style: textStyleDefault,
            ),
          ),
          SizedBox(height: AppSizes.heightMedium),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FinanceProjectColors.orange,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingMedium,
              ),
            ),
            onPressed: _saveImageLocally,
            child: Text(
              AppTexts.uploadReceipt,
              style: textStyleDefault,
            ),
          ),
        ],
      ),
    );
  }
}
