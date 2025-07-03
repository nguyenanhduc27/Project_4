package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Service.HotelService;
import com.example.HotelBoking.Service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hotels")
public class HotelController {

    @Autowired
    private HotelService service;

    @Autowired
    private RoomService roomService;

    @GetMapping
    public List<Hotel> getAllHotels(){
        return service.getAll();
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
}
