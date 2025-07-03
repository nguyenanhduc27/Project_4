package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class RoomService {
    @Autowired
    private RoomRepository repo;

    @Autowired
    HotelRepository hotelRepo;

    @Autowired
    RoomTypeRepository roomTypeRepo;

    private RoomDTO toDTO(Room r){
        RoomDTO dto = new RoomDTO();
        dto.setId(r.getId());
        dto.setHotelId(r.getHotelId());
        dto.setRoomTypeId(r.getRoomTypeId());
        dto.setRoomNumber(r.getRoomNumber());
        dto.setAvailable(r.getAvailable());
        return dto;
    }

    private Room toEntity(RoomDTO dto){
        Room r = new Room();
        r.setId(dto.getId());
        r.setHotelId(dto.getHotelId());
        r.setRoomTypeId(dto.getRoomTypeId());
        r.setRoomNumber(dto.getRoomNumber());
        r.setAvailable(dto.getAvailable());
        return r;
    }

    public List<Room> getAll(){
        return repo.findAll();
    }

    public Room findById(Long id){
        return repo.findById(id).orElse(null);
    }

    public Room add(RoomDTO dto) {
        if (!hotelRepo.existsById(dto.getHotelId())) {
            throw new RuntimeException("Hotel ID không tồn tại!");
        }

        // Kiểm tra room_type_id có tồn tại không
        if (!roomTypeRepo.existsById(dto.getRoomTypeId())) {
            throw new RuntimeException("Room Type ID không tồn tại!");
        }
        Room r = toEntity(dto);
        return repo.save(r);
    }

    public Room update(Long id , RoomDTO dto){
        if(repo.existsById(id)){
            Room r = toEntity(dto);
            r.setId(id);
            return repo.save(r);
        }
        return null;
    }

    public boolean delete(Long id){
        if(repo.existsById(id)){
            repo.deleteById(id);
            return true;
        }
        return false;
    }

    public List<Room> getRoomsByHotelId(Long hotelId) {
        return repo.findByHotelId(hotelId);
    }

}
