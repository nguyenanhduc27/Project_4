package com.example.HotelBoking.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.example.HotelBoking.Entity.HotelImage;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Repository.HotelImageRepository;
import com.example.HotelBoking.Repository.HotelRepository;

import java.io.File;

@RestController
@RequestMapping("/api/hotel-images")
public class HotelImageController {

    @Autowired
    private HotelImageRepository hotelImageRepository;

    @Autowired
    private HotelRepository hotelRepository;

    // Thư mục lưu file ảnh trên server
    private static final String UPLOAD_DIR = "uploads/hotel_images/";

    @PostMapping("/upload")
    public ResponseEntity<?> uploadHotelImage(
            @RequestParam("hotelId") Long hotelId,
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "isThumbnail", defaultValue = "false") boolean isThumbnail
    ) {
        try {
            // Tạo thư mục nếu chưa có
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Tạo tên file duy nhất
            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String filePath = UPLOAD_DIR + fileName;

            // Lưu file vào server
            file.transferTo(new File(filePath));

            // Lưu thông tin vào DB
            Hotel hotel = hotelRepository.findById(hotelId).orElse(null);
            if (hotel == null) return ResponseEntity.badRequest().body("Hotel not found");

            HotelImage hotelImage = new HotelImage();
            hotelImage.setHotel(hotel);
            hotelImage.setImageUrl("/" + filePath); // Đường dẫn trả về cho frontend
            hotelImage.setIsThumbnail(isThumbnail);

            hotelImageRepository.save(hotelImage);

            return ResponseEntity.ok(hotelImage.getImageUrl());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Upload failed: " + e.getMessage());
        }
    }
}
