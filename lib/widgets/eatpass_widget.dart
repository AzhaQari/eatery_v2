import 'package:flutter/material.dart';

class EatPassWidget extends StatelessWidget {
  const EatPassWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          // Handle Eat Pass widget tap if necessary
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          height: 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage('images/EatLogo.png'), // Corrected image path
              fit: BoxFit.contain, // Keeps the image's aspect ratio
            ),
          ),
          alignment: Alignment
              .center, // Align the image to the center of the container
        ),
      ),
    );
  }
}
