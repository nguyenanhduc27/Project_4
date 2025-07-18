import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/services.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // State and controllers for each field
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

  // For date picker overlay
  final LayerLink _dobLink = LayerLink();
  OverlayEntry? _dobOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        setState(() {
          email = authProvider.user!.email;
          emailController.text = email;
          name = authProvider.user!.fullName ?? '';
          nameController.text = name;
          phone = authProvider.user!.phone ?? '';
          phoneController.text = phone;
          dob = authProvider.user!.dateOfBirth != null
              ? _formatDateToDisplay(authProvider.user!.dateOfBirth!)
              : '';
          dobController.text = dob;
          address = authProvider.user!.address ?? '';
          addressController.text = address;
        });
      }
    });
  }

  // Hàm chuyển đổi DateTime sang định dạng dd/MM/yyyy
  String _formatDateToDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Hàm phân tích ngày từ chuỗi dd/MM/yyyy
  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length != 3) {
        return null;
      }
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) {
        return null;
      }
      final parsedDate = DateTime(year, month, day);
      if (parsedDate.year != year ||
          parsedDate.month != month ||
          parsedDate.day != day) {
        return null;
      }
      return parsedDate;
    } catch (e) {
      return null;
    }
  }

  // Hàm toggle overlay cho lịch
  void _toggleDobOverlay(ThemeData theme) {
    if (_dobOverlay != null) {
      _dobOverlay!.remove();
      setState(() => _dobOverlay = null);
    } else {
      final overlay = Overlay.of(context);
      final entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _dobOverlay?.remove();
                  setState(() => _dobOverlay = null);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(),
              ),
            ),
            Positioned(
              child: CompositedTransformFollower(
                link: _dobLink,
                offset: const Offset(0, 60),
                showWhenUnlinked: false,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  child: _buildDobDatePickerOverlay(theme),
                ),
              ),
            ),
          ],
        ),
      );
      overlay.insert(entry);
      setState(() => _dobOverlay = entry);
    }
  }

  // Widget cho overlay lịch ngày sinh
  Widget _buildDobDatePickerOverlay(ThemeData theme) {
    return Container(
      width: 320,
      height: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SfDateRangePicker(
        selectionMode: DateRangePickerSelectionMode.single,
        initialSelectedDate: dobController.text.isNotEmpty
            ? _parseDate(dobController.text) ?? DateTime(2000, 1, 1)
            : DateTime(2000, 1, 1),
        minDate: DateTime(1900),
        maxDate: DateTime.now(),
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: Colors.transparent,
          textStyle: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        monthViewSettings: DateRangePickerMonthViewSettings(
          firstDayOfWeek: 1,
          viewHeaderHeight: 40,
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          todayTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          todayCellDecoration: BoxDecoration(
            color: theme.primaryColor,
            shape: BoxShape.circle,
          ),
          disabledDatesTextStyle: TextStyle(color: Colors.grey.shade400),
        ),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is DateTime) {
            final selectedDate = args.value as DateTime;
            final formatted = _formatDateToDisplay(selectedDate);
            setState(() {
              dobController.text = formatted;
              dob = formatted;
            });
            if (_dobOverlay != null) {
              _dobOverlay!.remove();
              setState(() => _dobOverlay = null);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define a custom theme for consistent typography and colors
    final theme = Theme.of(context).copyWith(
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          color: Colors.blueAccent,
        ),
      ),
      primaryColor: Colors.blueAccent,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          textStyle: const TextStyle(fontSize: 14),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(color: Colors.black54),
      ),
    );

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Update email and name from AuthProvider
        if (authProvider.user != null) {
          email = authProvider.user!.email;
          emailController.text = email;
          name = authProvider.user!.fullName ?? '';
          nameController.text = name;
          phone = authProvider.user!.phone ?? '';
          phoneController.text = phone;
          dob = authProvider.user!.dateOfBirth != null
              ? _formatDateToDisplay(authProvider.user!.dateOfBirth!)
              : '';
          dobController.text = dob;
          address = authProvider.user!.address ?? '';
          addressController.text = address;
        }

        List<Widget> infoRows = [];
        final entries = userInfo.entries.toList();
        for (int i = 0; i < entries.length; i++) {
          switch (entries[i].key) {
            case 'Tên':
              infoRows.add(_buildNameRow(theme));
              break;
            case 'Địa chỉ email':
              infoRows.add(_buildEmailRow(theme));
              break;
            case 'Số điện thoại':
              infoRows.add(_buildPhoneRow(theme));
              break;
            case 'Ngày sinh':
              infoRows.add(_buildDobRow(theme));
              break;
            case 'Địa chỉ':
              infoRows.add(_buildAddressRow(theme));
              break;
            default:
              infoRows.add(
                  _buildInfoRow(context, entries[i].key, entries[i].value));
          }
          if (i < entries.length - 1) {
            infoRows.add(const Divider(height: 1, color: Color(0xFFE0E0E0)));
            infoRows.add(const SizedBox(height: 16));
          }
        }

        return Theme(
          data: theme,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CustomHeader(),
                  // Banner
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/resort-title-bg.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'Thông tin cá nhân',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              shadows: [
                                const Shadow(
                                  blurRadius: 8,
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    margin: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Cập nhật thông tin của bạn và tìm hiểu các thông tin này được sử dụng ra sao.',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ...infoRows,
                      ],
                    ),
                  ),
                  CustomFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameRow(ThemeData theme) {
    if (isEditingName) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Tên',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên *',
                  hintText: 'Nhập tên của bạn',
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  isEditingName = false;
                  nameController.text = name;
                });
              },
              child: const Text('Hủy'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final success = await Provider.of<AuthProvider>(context, listen: false)
                    .updateProfile(fullName: nameController.text);
                if (!mounted) return;
                if (success) {
                  setState(() {
                    name = nameController.text;
                    isEditingName = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật tên thành công!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thất bại!')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Tên',
                style: theme.inputDecorationTheme.labelStyle?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                name.isEmpty ? 'Hãy cho chúng tôi biết tên gọi của bạn' : name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: name.isEmpty ? Colors.grey[400] : Colors.black87,
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
              child: const Text('Chỉnh sửa'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmailRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Địa chỉ email',
                  style: theme.inputDecorationTheme.labelStyle?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  email.isEmpty ? 'Nhập địa chỉ email của bạn' : email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: email.isEmpty ? Colors.grey[400] : Colors.black87,
                  ),
                ),
              ),
              if (email.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Xác thực',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 124),
            child: Text(
              'Đây là địa chỉ email bạn dùng để đăng nhập. Chúng tôi cũng sẽ gửi các xác nhận đặt chỗ tới địa chỉ này.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(ThemeData theme) {
    if (isEditingPhone) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'Số điện thoại',
                    style: theme.inputDecorationTheme.labelStyle?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại *',
                      hintText: 'Nhập số điện thoại',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditingPhone = false;
                      phoneController.text = phone;
                    });
                  },
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final success = await Provider.of<AuthProvider>(context, listen: false)
                        .updateProfile(phone: phoneController.text);
                    if (!mounted) return;
                    if (success) {
                      setState(() {
                        phone = phoneController.text;
                        isEditingPhone = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật số điện thoại thành công!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật thất bại!')),
                      );
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 124),
              child: Text(
                'Chỗ nghỉ hoặc địa điểm tham quan bạn đặt sẽ liên lạc với bạn qua số này nếu cần.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'Số điện thoại',
                    style: theme.inputDecorationTheme.labelStyle?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    phone.isEmpty ? 'Thêm số điện thoại của bạn' : phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: phone.isEmpty ? Colors.grey[400] : Colors.black87,
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
                  child: const Text('Chỉnh sửa'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 124),
              child: Text(
                'Chỗ nghỉ hoặc địa điểm tham quan bạn đặt sẽ liên lạc với bạn qua số này nếu cần.',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDobRow(ThemeData theme) {
    if (isEditingDob) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Ngày sinh',
                style: theme.inputDecorationTheme.labelStyle?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextField(
                controller: dobController,
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh *',
                  hintText: 'DD/MM/YYYY',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                  _DateInputFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  isEditingDob = false;
                  dobController.text = dob;
                });
              },
              child: const Text('Hủy'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final dobText = dobController.text.trim();
                if (dobText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập ngày sinh!')),
                  );
                  return;
                }
                // Validate định dạng dd/MM/yyyy
                final reg = RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');
                if (!reg.hasMatch(dobText)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ngày sinh phải đúng định dạng dd/MM/yyyy!')),
                  );
                  return;
                }
                final parsedDate = _parseDate(dobText);
                if (parsedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ngày sinh không hợp lệ!')),
                  );
                  return;
                }
                final formatted =
                    '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
                final success = await Provider.of<AuthProvider>(context, listen: false)
                    .updateProfile(dateOfBirth: formatted);
                if (!mounted) return;
                if (success) {
                  setState(() {
                    dob = dobController.text;
                    isEditingDob = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật ngày sinh thành công!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thất bại!')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Ngày sinh',
                style: theme.inputDecorationTheme.labelStyle?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                dob.isEmpty ? 'Nhập ngày sinh của bạn' : dob,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: dob.isEmpty ? Colors.grey[400] : Colors.black87,
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
              child: const Text('Chỉnh sửa'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAddressRow(ThemeData theme) {
    if (isEditingAddress) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Địa chỉ',
                style: theme.inputDecorationTheme.labelStyle?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ *',
                  hintText: 'Nhập địa chỉ của bạn',
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  isEditingAddress = false;
                  addressController.text = address;
                });
              },
              child: const Text('Hủy'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final success = await Provider.of<AuthProvider>(context, listen: false)
                    .updateProfile(address: addressController.text);
                if (!mounted) return;
                if (success) {
                  setState(() {
                    address = addressController.text;
                    isEditingAddress = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật địa chỉ thành công!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thất bại!')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                'Địa chỉ',
                style: theme.inputDecorationTheme.labelStyle?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ) ?? TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                address.isEmpty ? 'Nhập địa chỉ của bạn' : address,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: address.isEmpty ? Colors.grey[400] : Colors.black87,
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
              child: const Text('Chỉnh sửa'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    bool isEmail = label == 'Địa chỉ email';
    bool isPhone = label == 'Số điện thoại';

    String? description;
    if (isEmail) {
      description =
          'Đây là địa chỉ email bạn dùng để đăng nhập. Chúng tôi cũng sẽ gửi các xác nhận đặt chỗ tới địa chỉ này.';
    }
    if (isPhone) {
      description =
          'Chỗ nghỉ hoặc địa điểm tham quan bạn đặt sẽ liên lạc với bạn qua số này nếu cần.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Text(
                  value.isEmpty ? _getPlaceholder(label) : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            value.isEmpty ? Colors.grey[400] : Colors.black87,
                      ),
                ),
              ),
              if (isEmail && value.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Xác thực',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ),
              TextButton(
                onPressed: () {
                  // Handle edit action
                },
                child: const Text('Chỉnh sửa'),
              ),
            ],
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
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

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Thêm dấu '/' sau ngày và tháng
      if ((i == 1 || i == 3) && i != text.length - 1) {
        buffer.write('/');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
