import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // Trạng thái và controller cho từng trường
  bool isEditingName = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingDob = false;
  bool isEditingAddress = false;

  String name = '';
  String email = '';
  String phone = '';
  String dob = '';
  String address = '';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  final Map<String, String> userInfo = {
    'Tên': '',
    'Địa chỉ email': '',
    'Số điện thoại': '',
    'Ngày sinh': '',
    'Địa chỉ': '',
  };

  @override
  void initState() {
    super.initState();
    // Ví dụ: Lấy email từ provider (nếu có)
    // final user = Provider.of<AuthProvider>(context, listen: false).user;
    // email = user?.email ?? '';
    // emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> infoRows = [];
    final entries = userInfo.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      switch (entries[i].key) {
        case 'Tên':
          infoRows.add(_buildNameRow());
          break;
        case 'Địa chỉ email':
          infoRows.add(_buildEmailRow());
          break;
        case 'Số điện thoại':
          infoRows.add(_buildPhoneRow());
          break;
        case 'Ngày sinh':
          infoRows.add(_buildDobRow());
          break;
        case 'Địa chỉ':
          infoRows.add(_buildAddressRow());
          break;
        default:
          infoRows
              .add(_buildInfoRow(context, entries[i].key, entries[i].value));
      }
      if (i < entries.length - 1) {
        infoRows.add(const Divider(height: 1, color: Color(0xFFE0E0E0)));
        infoRows.add(
            const SizedBox(height: 12)); // Thêm khoảng cách giữa các trường
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Thông tin cá nhân',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Cập nhật thông tin của bạn và tìm hiểu các thông tin này được sử dụng ra sao.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 32),
                          ...infoRows,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomFooter(),
        ],
      ),
    );
  }

  Widget _buildNameRow() {
    if (isEditingName) {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child:
                  Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên *',
                border: OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingName = false;
                nameController.text = name;
              });
            },
            child: Text('Hủy', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = nameController.text;
                isEditingName = false;
              });
            },
            child: Text('Lưu'),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child:
                  Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              name.isEmpty ? 'Hãy cho chúng tôi biết tên gọi của bạn' : name,
              style: TextStyle(
                fontSize: 16,
                color: name.isEmpty ? Colors.grey[400] : Colors.black,
                fontStyle: name.isEmpty ? FontStyle.normal : FontStyle.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingName = true;
                nameController.text = name;
              });
            },
            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    }
  }

  Widget _buildEmailRow() {
    Widget description = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        'Đây là địa chỉ email bạn dùng để đăng nhập. Chúng tôi cũng sẽ gửi các xác nhận đặt chỗ tới địa chỉ này.',
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
    );

    if (isEditingEmail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: Text('Địa chỉ email',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ email *',
                    border: OutlineInputBorder(),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingEmail = false;
                    emailController.text = email;
                  });
                },
                child: Text('Hủy', style: TextStyle(color: Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    email = emailController.text;
                    isEditingEmail = false;
                  });
                },
                child: Text('Lưu'),
              ),
            ],
          ),
          description,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: Text('Địa chỉ email',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: Text(
                  email.isEmpty ? 'Nhập địa chỉ email của bạn' : email,
                  style: TextStyle(
                    fontSize: 16,
                    color: email.isEmpty ? Colors.grey[400] : Colors.black,
                    fontStyle:
                        email.isEmpty ? FontStyle.normal : FontStyle.normal,
                  ),
                ),
              ),
              if (email.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Xác thực',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingEmail = true;
                    emailController.text = email;
                  });
                },
                child: Text('Chỉnh sửa', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          description,
        ],
      );
    }
  }

  Widget _buildPhoneRow() {
    Widget description = Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        'Chỗ nghỉ hoặc địa điểm tham quan bạn đặt sẽ liên lạc với bạn qua số này nếu cần.',
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
    );

    if (isEditingPhone) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: Text('Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại *',
                    border: OutlineInputBorder(),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingPhone = false;
                    phoneController.text = phone;
                  });
                },
                child: Text('Hủy', style: TextStyle(color: Colors.blue)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    phone = phoneController.text;
                    isEditingPhone = false;
                  });
                },
                child: Text('Lưu'),
              ),
            ],
          ),
          description,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: Text('Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: Text(
                  phone.isEmpty ? 'Thêm số điện thoại của bạn' : phone,
                  style: TextStyle(
                    fontSize: 16,
                    color: phone.isEmpty ? Colors.grey[400] : Colors.black,
                    fontStyle:
                        phone.isEmpty ? FontStyle.normal : FontStyle.normal,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isEditingPhone = true;
                    phoneController.text = phone;
                  });
                },
                child: Text('Chỉnh sửa', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          description,
        ],
      );
    }
  }

  Widget _buildDobRow() {
    if (isEditingDob) {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child: Text('Ngày sinh',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: TextField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: 'Ngày sinh *',
                border: OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingDob = false;
                dobController.text = dob;
              });
            },
            child: Text('Hủy', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                dob = dobController.text;
                isEditingDob = false;
              });
            },
            child: Text('Lưu'),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child: Text('Ngày sinh',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              dob.isEmpty ? 'Nhập ngày sinh của bạn' : dob,
              style: TextStyle(
                fontSize: 16,
                color: dob.isEmpty ? Colors.grey[400] : Colors.black,
                fontStyle: dob.isEmpty ? FontStyle.normal : FontStyle.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingDob = true;
                dobController.text = dob;
              });
            },
            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    }
  }

  Widget _buildAddressRow() {
    if (isEditingAddress) {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child: Text('Địa chỉ',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ *',
                border: OutlineInputBorder(),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingAddress = false;
                addressController.text = address;
              });
            },
            child: Text('Hủy', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                address = addressController.text;
                isEditingAddress = false;
              });
            },
            child: Text('Lưu'),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(
              width: 120,
              child: Text('Địa chỉ',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              address.isEmpty ? 'Nhập địa chỉ của bạn' : address,
              style: TextStyle(
                fontSize: 16,
                color: address.isEmpty ? Colors.grey[400] : Colors.black,
                fontStyle:
                    address.isEmpty ? FontStyle.normal : FontStyle.normal,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isEditingAddress = true;
                addressController.text = address;
              });
            },
            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    bool isEmail = label == 'Địa chỉ email';
    bool isPhone = label == 'Số điện thoại';

    // Mô tả cho từng trường
    String? description1;
    String? description2;
    if (isEmail) {
      description1 =
          'Đây là địa chỉ email bạn dùng để đăng nhập. Chúng tôi cũng sẽ gửi các xác nhận đặt chỗ tới địa chỉ này.';
    }
    if (isPhone) {
      description1 = 'Thêm số điện thoại của bạn';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value.isEmpty ? _getPlaceholder(label) : value,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              value.isEmpty ? Colors.grey[400] : Colors.black,
                          fontStyle: value.isEmpty
                              ? FontStyle.normal
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                    if (isEmail && value.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Xác thực',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        // chuyển sang chế độ chỉnh sửa
                      },
                      child: const Text('Chỉnh sửa',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                if (description1 != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      description1,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),

                // ấdasdasd
                if (description2 != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      description2,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPlaceholder(String label) {
    switch (label) {
      case 'Tên':
        return 'Hãy cho chúng tôi biết tên gọi của bạn';
      case 'Số điện thoại':
        return 'Thêm số điện thoại của bạn';
      case 'Ngày sinh':
        return 'Nhập ngày sinh của bạn';
      case 'Địa chỉ':
        return 'Nhập địa chỉ của bạn';
      default:
        return '';
    }
  }
}
