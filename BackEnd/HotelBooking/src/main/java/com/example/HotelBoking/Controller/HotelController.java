package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Service.HotelService;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value = "/api/hotels", produces = "application/json; charset=UTF-8")
public class HotelController {

    @Autowired
    private HotelService service;

    @Autowired
    private RoomService roomService;

    @GetMapping
    public List<HotelDTO> getAllHotels(){
        return service.getAllDTOs();
    }

    @GetMapping("/{id}")
    public Hotel getHotelById(@PathVariable Integer id){
        return service.findById(id);
    }

    @PostMapping
    public Hotel addNewHotel(@RequestBody HotelDTO dto){
        return service.add(dto);
    }

    @PutMapping("/{id}")
    public Hotel updateHotel(@PathVariable Integer id , @RequestBody HotelDTO dto){
        return service.update(id , dto);
    }

    @DeleteMapping("/{id}")
    public String deleteHotel(@PathVariable Integer id){
        return service.delete(id) ? "Success Delete" : "Can not find id";
    }


    //  Lấy danh sách phòng theo khách sạn
    @GetMapping("/{hotelId}/rooms")
    public List<RoomDTO> getRoomsByHotel(@PathVariable Integer hotelId) {
        LocalDate now = LocalDate.now();
        LocalDate tomorrow = now.plusDays(1);
        return roomService.getRoomsByHotelId(hotelId, now, tomorrow);
    }

    // Lấy danh sách loại phòng theo khách sạn (group by room type, trả về số lượng còn trống)
    @GetMapping("/{hotelId}/room-types")
    public List<RoomTypeDTO> getRoomTypesByHotel(@PathVariable Integer hotelId,
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

    @GetMapping(value = "/search", produces = "application/json; charset=UTF-8")
    public ResponseEntity<List<HotelDTO>> searchHotels(
            @RequestParam LocalDate checkIn,
            @RequestParam LocalDate checkOut,
            @RequestParam String city,
            @RequestParam int rooms
    ) {
        List<Hotel> hotels = service.searchHotels(checkIn, checkOut, city, rooms);
        List<HotelDTO> dtos = hotels.stream().map(h -> service.toDTO(h)).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }
}
