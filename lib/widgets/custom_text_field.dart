import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Custom TextField widget that adapts based on the platform and field type
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isDate; // If true, it opens a date picker

  CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isDate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check the platform
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return isDate
          ? _buildCupertinoDatePicker(context)
          : _buildCupertinoTextField();
    } else {
      return isDate
          ? _buildMaterialDatePicker(context)
          : _buildMaterialTextField();
    }
  }

  Widget _buildMaterialTextField() {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCupertinoTextField() {
    return CupertinoTextField(
      controller: controller,
      placeholder: label,
      keyboardType: keyboardType,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMaterialDatePicker(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
    );
  }

  Widget _buildCupertinoDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 200,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                controller.text = "${newDate.toLocal()}".split(' ')[0];
              },
            ),
          ),
        );
      },
      child: _buildCupertinoTextField(),
    );
  }
}
