import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CustomHeader extends StatefulWidget {
  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    // Đóng dropdown khi click ra ngoài
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return GestureDetector(
          onTap: () {
            if (_isDropdownOpen) {
              setState(() {
                _isDropdownOpen = false;
              });
            }
          },
          child: Container(
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
                          Text('Book@Hotale.co',
                              style: TextStyle(fontSize: 14)),
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
                                  icon: Icon(Icons.person,
                                      color: Color(0xFF424242)),
                                  onPressed: () {
                                    // Điều hướng đến trang profile nếu có
                                    Navigator.pushNamed(
                                        context, '/personal_infor');
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
          ),
        );
      },
    );
  }

  Widget _buildLoginSignUp() {
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
    );
  }

  Widget _buildMyAccountDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF424242),
                ),
              ),
              SizedBox(width: 4),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xFF424242),
              ),
            ],
          ),
        ),
        if (_isDropdownOpen)
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownItem(
                  icon: Icons.person,
                  text: 'Personal Infor',
                  onTap: () {
                    setState(() {
                      _isDropdownOpen = false;
                    });
                    Navigator.pushNamed(context, '/personal_infor');
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
                _buildDropdownItem(
                  icon: Icons.logout,
                  text: 'Log out',
                  onTap: () {
                    setState(() {
                      _isDropdownOpen = false;
                    });
                    _showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Color(0xFF424242)),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}
