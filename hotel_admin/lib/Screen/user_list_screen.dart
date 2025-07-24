// lib/Screen/users/user_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await UserService.fetchUsers();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      child: ListTile(
        title: Text(user['full_name'] ?? 'Không có tên'),
        subtitle: Text(
          'Email: ${user['email']}\nPhone: ${user['phone'] ?? 'N/A'}\nVai trò: ${user['role']}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // TODO: Xác nhận & xoá người dùng
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý người dùng')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return _buildUserCard(_users[index]);
                },
              ),
            ),
    );
  }
}
