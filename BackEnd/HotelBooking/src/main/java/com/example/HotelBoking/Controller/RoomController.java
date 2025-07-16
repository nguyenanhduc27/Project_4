package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
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
    public List<RoomDTO> getRoomsByHotel(@PathVariable Integer hotelId) {
        return roomService.getRoomsByHotelId(hotelId);
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
