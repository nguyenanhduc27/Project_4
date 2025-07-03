import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '© 2025 Hotel Booking. All rights reserved.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
