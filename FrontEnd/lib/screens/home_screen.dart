import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class HotelBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ Header riêng, không bị ảnh nền trùm lên
          CustomHeader(),

          // ✅ Phần chính có ảnh nền
          Expanded(
            child: SingleChildScrollView(
              // Để cuộn nếu nội dung dài
              child: Column(
                children: [
                  Container(
                    height: 500,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/resort-title-bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to Hotel Booking!',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Book Now'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ✅ Div mới bên dưới ảnh
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Our Luxury Rooms',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.We offer the most comfortable rooms with premium services.',

                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Footer
          CustomFooter(),
        ],
      ),
    );
  }
}
