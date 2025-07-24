// lib/Screen/invoices/invoice_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/invoice_service.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Map<String, dynamic>> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final data = await InvoiceService.fetchInvoices();
    setState(() {
      _invoices = data;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Issued':
        return Colors.green;
      case 'Draft':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    return Card(
      child: ListTile(
        title: Text('Mã hóa đơn: ${invoice['invoice_code'] ?? 'N/A'}'),
        subtitle: Text(
          'Booking ID: ${invoice['booking_id']}\nTổng tiền: ${invoice['total_amount']} VND\nThuế: ${invoice['tax_rate']}',
        ),
        trailing: Chip(
          label: Text(invoice['status']),
          backgroundColor: _getStatusColor(invoice['status']),
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý hóa đơn')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInvoices,
              child: ListView.builder(
                itemCount: _invoices.length,
                itemBuilder: (context, index) {
                  return _buildInvoiceCard(_invoices[index]);
                },
              ),
            ),
    );
  }
}
