import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // nền trắng cho toàn bộ header
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          // --- Top Bar ---
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contact Info
                Row(
                  children: [
                    Icon(Icons.phone, size: 18, color: Colors.black),
                    SizedBox(width: 5),
                    Text('+1-634-567-34', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 20),
                    Icon(Icons.email, size: 18, color: Colors.black),
                    SizedBox(width: 5),
                    Text('Book@Hotale.co', style: TextStyle(fontSize: 14)),
                  ],
                ),
                // Logo
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: 80,
                    height: 95,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo-hotel-1.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Login & Sign Up
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.isLoggedIn) {
                      // ĐÃ ĐĂNG NHẬP
                      return Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.person, color: Color(0xFF424242)),
                            onPressed: () {
                              // Điều hướng đến trang profile nếu có
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Color(0xFF424242),
                            margin: EdgeInsets.only(left: 28),
                          ),
                          SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              authProvider.logout(); // Gọi logout
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // CHƯA ĐĂNG NHẬP
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Color(0xFF424242),
                            margin: EdgeInsets.only(left: 28),
                          ),
                          SizedBox(width: 32),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // --- Divider ---
          Divider(color: Colors.grey[300], thickness: 1, height: 1),

          // --- Navigation ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // children: [
              //   Expanded(
              //     // Co giãn phần menu
              //     child: SingleChildScrollView(
              //       // Phòng trường hợp menu dài
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children: [
              //           TextButton(onPressed: () {}, child: Text('Home')),
              //           SizedBox(width: 20),
              //           TextButton(onPressed: () {}, child: Text('Pages')),
              //           SizedBox(width: 20),
              //           TextButton(onPressed: () {}, child: Text('Rooms')),
              //           SizedBox(width: 20),
              //           TextButton(
              //               onPressed: () {}, child: Text('Reservation')),
              //           SizedBox(width: 20),
              //           TextButton(onPressed: () {}, child: Text('Blog')),
              //           SizedBox(width: 20),
              //           TextButton(onPressed: () {}, child: Text('Contact')),
              //         ],
              //       ),
              //     ),
              //   ),
              //   ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       foregroundColor: Colors.white,
              //     ),
              //     child: Text('BOOK NOW'),
              //   ),
              // ],
            ),
          )
        ],
      ),
    );
  }
}
