class HoloeateryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200, // Set your desired width
        height: 200, // Set your desired height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/HoloeateryWhite.png'),
            fit: BoxFit.contain, // or BoxFit.cover depending on your need
          ),
        ),
      ),
    );
  }
}
