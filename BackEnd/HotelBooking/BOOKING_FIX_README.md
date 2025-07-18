# Sửa lỗi Booking - Hỗ trợ Guest Booking

## Các thay đổi đã thực hiện:

### 1. Entity Booking
- Thay đổi `user_id` từ `nullable = false` thành `nullable = true`
- Cho phép booking mà không cần đăng nhập

### 2. BookingService
- Thêm validation cho dữ liệu đầu vào
- Xử lý trường hợp `userId` là null
- Thêm try-catch cho việc lưu contact
- Thêm validation cho contact information

### 3. BookingController
- Thêm `@CrossOrigin` để hỗ trợ CORS
- Cải thiện exception handling
- Trả về `ResponseEntity` với thông báo lỗi rõ ràng

### 4. WebConfig
- Thêm CORS configuration cho frontend

### 5. DTO
- Thêm constructor mặc định cho `BookingContactDTO`

### 6. Frontend
- Cải thiện error handling trong `BookingService`
- Đảm bảo `userId` được gửi (có thể null)
- Thêm logging để debug

## Cách test:

### 1. Khởi động Backend
```bash
cd Project_4/BackEnd/HotelBooking
./mvnw spring-boot:run
```

### 2. Test API bằng file test_booking.http
- Sử dụng VS Code với extension "REST Client"
- Hoặc sử dụng Postman
- Test cả trường hợp có user và không có user

### 3. Test từ Frontend
- Chạy Flutter app
- Thử đặt phòng mà không đăng nhập
- Kiểm tra console log để debug

## Lưu ý:
- Booking không đăng nhập sẽ có `userId = null`
- Contact information vẫn bắt buộc
- Có thể mở rộng để lưu thêm thông tin khách hàng không đăng nhập 