import 'package:flutter/material.dart';

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
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
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
                      onPressed: () {},
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
                ),
              ],
            ),
          ),

          // --- Divider ---
          Divider(color: Colors.grey[300], thickness: 1, height: 1),

          // --- Navigation ---
          Padding(
            padding: EdgeInsets.only(left: 220, top: 20, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Pages',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Rooms',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Reservation',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Blog',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 79, 78, 78),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Button BOOK NOW bên phải
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('BOOK NOW'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
