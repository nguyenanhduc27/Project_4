package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping(value = "/api/rooms", produces = "application/json; charset=UTF-8")
public class RoomController {
    @Autowired
    private RoomService roomService;

    // Lấy tất cả phòng
    @GetMapping
    public List<RoomDTO> getAllRooms() {
        return roomService.getAll();
    }

    // Lấy phòng theo ID
    @GetMapping("/{id}")
    public ResponseEntity<RoomDTO> getRoomById(@PathVariable Integer id) {
        RoomDTO dto = roomService.findById(id);
        if (dto == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(dto);
    }

    // Lấy danh sách phòng theo khách sạn
    @GetMapping("/hotel/{hotelId}")
    public List<RoomDTO> getRoomsByHotel(
            @PathVariable Integer hotelId,
            @RequestParam(required = false) String checkIn,
            @RequestParam(required = false) String checkOut) {
        LocalDate checkInDate = null;
        LocalDate checkOutDate = null;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        try {
            if (checkIn != null) checkInDate = LocalDate.parse(checkIn, formatter);
            if (checkOut != null) checkOutDate = LocalDate.parse(checkOut, formatter);
        } catch (Exception e) {
            // Xử lý lỗi parse date nếu cần
        }
        if (checkInDate == null) checkInDate = LocalDate.now();
        if (checkOutDate == null) checkOutDate = checkInDate.plusDays(1);
        return roomService.getRoomsByHotelId(hotelId, checkInDate, checkOutDate);
    }

    // Lấy danh sách loại phòng theo khách sạn (group by room type, trả về số lượng còn trống)
    @GetMapping("/hotel/{hotelId}/room-types")
    public List<RoomTypeDTO> getRoomTypesByHotel(
            @PathVariable Integer hotelId,
            @RequestParam(required = false) String checkIn,
            @RequestParam(required = false) String checkOut) {
        LocalDate checkInDate = null;
        LocalDate checkOutDate = null;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        try {
            if (checkIn != null) checkInDate = LocalDate.parse(checkIn, formatter);
            if (checkOut != null) checkOutDate = LocalDate.parse(checkOut, formatter);
        } catch (Exception e) {
            // Xử lý lỗi parse date nếu cần
        }
        if (checkInDate == null) checkInDate = LocalDate.now();
        if (checkOutDate == null) checkOutDate = checkInDate.plusDays(1);
        return roomService.getRoomTypesByHotelId(hotelId, checkInDate, checkOutDate);
    }

    // Thêm phòng mới
    @PostMapping
    public ResponseEntity<RoomDTO> addNewRoom(@RequestBody RoomDTO dto) {
        RoomDTO created = roomService.add(dto);
        return ResponseEntity.ok(created);
    }

    // Cập nhật phòng
    @PutMapping("/{id}")
    public ResponseEntity<RoomDTO> updateRoom(@PathVariable Integer id, @RequestBody RoomDTO dto) {
        RoomDTO updated = roomService.update(id, dto);
        if (updated == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(updated);
    }

    // Xóa phòng
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteRoom(@PathVariable Integer id) {
        boolean deleted = roomService.delete(id);
        if (deleted) return ResponseEntity.ok().build();
        return ResponseEntity.notFound().build();
    }
}
