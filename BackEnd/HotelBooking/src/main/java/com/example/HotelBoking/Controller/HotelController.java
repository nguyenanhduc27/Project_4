package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Service.HotelService;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
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
    public Hotel getHotelById(@PathVariable Long id){
        return service.findById(id);
    }

    @PostMapping
    public Hotel addNewHotel(@RequestBody HotelDTO dto){
        return service.add(dto);
    }

    @PutMapping("/{id}")
    public Hotel updateHotel(@PathVariable Long id , @RequestBody HotelDTO dto){
        return service.update(id , dto);
    }

    @DeleteMapping("/{id}")
    public String deleteHotel(@PathVariable Long id){
        return service.delete(id) ? "Success Delete" : "Can not find id";
    }


    //  Lấy danh sách phòng theo khách sạn
    @GetMapping("/{hotelId}/rooms")
    public List<Room> getRoomsByHotel(@PathVariable Long hotelId) {
        return roomService.getRoomsByHotelId(hotelId);
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
