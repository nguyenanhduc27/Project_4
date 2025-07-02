import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  TextEditingController guestsController = TextEditingController();

  void searchHotels() {
    // Lấy dữ liệu từ các trường nhập liệu
    String location = locationController.text;
    String checkIn = checkInController.text;
    String checkOut = checkOutController.text;
    String guests = guestsController.text;

    // Gửi request API
    // Ví dụ URL API: /search?location=...&checkIn=...&checkOut=...&guests=...
    String url =
        '/search?location=$location&checkIn=$checkIn&checkOut=$checkOut&guests=$guests';

    // Tiến hành gọi API ở đây (sử dụng package http hoặc Dio để gửi request)
    print("Request URL: $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: checkInController,
              decoration: InputDecoration(labelText: 'Check-in Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: checkOutController,
              decoration: InputDecoration(labelText: 'Check-out Date'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: guestsController,
              decoration: InputDecoration(labelText: 'Number of Guests'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: searchHotels, child: Text('Search')),
          ],
        ),
      ),
    );
  }
}
