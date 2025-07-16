package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.RoomAmenityDTO;
import com.example.HotelBoking.Entity.Amenity;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.RoomAmenity;
import com.example.HotelBoking.Repository.AmenityRepository;
import com.example.HotelBoking.Repository.RoomAmenityRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomAmenityService {

    @Autowired
    private RoomAmenityRepository roomAmenityRepo;
    @Autowired
    private RoomRepository roomRepo;
    @Autowired
    private AmenityRepository amenityRepo;

    public RoomAmenityDTO toDTO(RoomAmenity ra) {
        RoomAmenityDTO dto = new RoomAmenityDTO();
        dto.setId(ra.getId());
        dto.setRoomId(ra.getRoom().getId());
        dto.setAmenityId(ra.getAmenity().getId());
        return dto;
    }

    public RoomAmenity toEntity(RoomAmenityDTO dto) {
        RoomAmenity ra = new RoomAmenity();
        ra.setId(dto.getId());
        ra.setRoom(roomRepo.findById(dto.getRoomId())
                .orElseThrow(() -> new RuntimeException("Room không tồn tại")));
        ra.setAmenity(amenityRepo.findById(dto.getAmenityId())
                .orElseThrow(() -> new RuntimeException("Amenity không tồn tại")));
        return ra;
    }

    public List<RoomAmenityDTO> getAll() {
        return roomAmenityRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public RoomAmenityDTO findById(Long id) {
        return roomAmenityRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public RoomAmenity add(RoomAmenityDTO dto) {
        RoomAmenity ra = toEntity(dto);
        return roomAmenityRepo.save(ra);
    }

    public RoomAmenity update(Long id, RoomAmenityDTO dto) {
        Optional<RoomAmenity> opt = roomAmenityRepo.findById(id);
        if (opt.isPresent()) {
            RoomAmenity ra = opt.get();
            ra.setRoom(roomRepo.findById(dto.getRoomId())
                    .orElseThrow(() -> new RuntimeException("Room không tồn tại")));
            ra.setAmenity(amenityRepo.findById(dto.getAmenityId())
                    .orElseThrow(() -> new RuntimeException("Amenity không tồn tại")));
            return roomAmenityRepo.save(ra);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (roomAmenityRepo.existsById(id)) {
            roomAmenityRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
