package com.example.HotelBoking.Controller;

import com.example.HotelBoking.Service.VnPayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @Autowired
    private VnPayService vnPayService;

    @PostMapping("/vnpay")
    public Map<String, String> createVnPayPayment(@RequestBody Map<String, Object> request) {
        Long bookingId = Long.valueOf(request.get("bookingId").toString());
        double amountDouble = Double.parseDouble(request.get("amount").toString());
        long amount = Math.round(amountDouble);
        String orderInfo = request.get("orderInfo").toString();

        String paymentUrl = vnPayService.createPaymentUrl(bookingId, amount, orderInfo);
        return Map.of("paymentUrl", paymentUrl);
    }

    @GetMapping("/vnpay-return")
    public String handleVnPayReturn(@RequestParam Map<String, String> params) {
        // Log tất cả tham số nhận được
        System.out.println("VNPay Return Params: " + params.toString());

        // Lấy secure hash từ params
        String vnp_SecureHash = params.get("vnp_SecureHash");
        if (vnp_SecureHash == null) {
            return "Lỗi: Thiếu chữ ký VNPay";
        }

        // Tạo map mới để loại bỏ các tham số không cần thiết
        Map<String, String> vnp_Params = new TreeMap<>(); // Sử dụng TreeMap để tự động sắp xếp
        for (Map.Entry<String, String> entry : params.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType") && value != null && !value.isEmpty()) {
                // Giải mã giá trị nếu cần (đặc biệt với vnp_OrderInfo)
                try {
                    String decodedValue = URLDecoder.decode(value, StandardCharsets.UTF_8.toString());
                    vnp_Params.put(key, decodedValue);
                } catch (Exception e) {
                    System.out.println("Lỗi giải mã tham số " + key + ": " + e.getMessage());
                    vnp_Params.put(key, value); // Sử dụng giá trị gốc nếu giải mã thất bại
                }
            }
        }

        // Tạo hashData
        StringBuilder hashData = new StringBuilder();
        Iterator<Map.Entry<String, String>> itr = vnp_Params.entrySet().iterator();
        while (itr.hasNext()) {
            Map.Entry<String, String> entry = itr.next();
            String fieldName = entry.getKey();
            String fieldValue = entry.getValue();
            hashData.append(fieldName).append('=').append(fieldValue);
            if (itr.hasNext()) {
                hashData.append('&');
            }
        }

        // Tạo lại chữ ký
        String mySecureHash;
        try {
            mySecureHash = vnPayService.hmacSHA512(vnPayService.getVnp_HashSecret(), hashData.toString());
        } catch (Exception e) {
            return "Lỗi xác thực chữ ký: " + e.getMessage();
        }

        // Log để debug
        System.out.println("Return HashData: " + hashData.toString());
        System.out.println("MyHash: " + mySecureHash);
        System.out.println("VNP Hash: " + vnp_SecureHash);

        // So sánh chữ ký
        if (mySecureHash.equalsIgnoreCase(vnp_SecureHash)) {
            // Kiểm tra trạng thái giao dịch
            String vnp_ResponseCode = params.get("vnp_ResponseCode");
            if ("00".equals(vnp_ResponseCode)) {
                // TODO: Cập nhật trạng thái booking thành công
                return "Thanh toán thành công!";
            } else {
                // TODO: Cập nhật trạng thái booking thất bại nếu cần
                return "Giao dịch thất bại: Mã lỗi " + vnp_ResponseCode;
            }
        } else {
            return "Sai chữ ký! HashData: " + hashData.toString();
        }
    }
}