package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.RoomType;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomService {

    @Autowired
    private RoomRepository repo;

    @Autowired
    private HotelRepository hotelRepo;

    @Autowired
    private RoomTypeRepository roomTypeRepo;

    public RoomDTO toDTO(Room r) {
        RoomDTO dto = new RoomDTO();
        dto.setId(r.getId());
        dto.setHotelId(r.getHotel().getId());
        dto.setRoomTypeId(r.getRoomType().getId());
        dto.setRoomNumber(r.getRoomNumber());
        dto.setAvailable(r.getIsAvailable());
        return dto;
    }

    public Room toEntity(RoomDTO dto) {
        Room r = new Room();
        r.setId(dto.getId());

        Hotel hotel = hotelRepo.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));

        RoomType roomType = roomTypeRepo.findById(dto.getRoomTypeId())
                .orElseThrow(() -> new RuntimeException("RoomType không tồn tại"));

        r.setHotel(hotel);
        r.setRoomType(roomType);
        r.setRoomNumber(dto.getRoomNumber());
        r.setIsAvailable(dto.getAvailable());

        return r;
    }

    public List<RoomDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public RoomDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public Room add(RoomDTO dto) {
        Room r = toEntity(dto);
        return repo.save(r);
    }

    public Room update(Long id, RoomDTO dto) {
        Optional<Room> opt = repo.findById(id);
        if (opt.isPresent()) {
            Room r = opt.get();

            if (dto.getHotelId() != null) {
                Hotel hotel = hotelRepo.findById(dto.getHotelId())
                        .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
                r.setHotel(hotel);
            }

            if (dto.getRoomTypeId() != null) {
                RoomType rt = roomTypeRepo.findById(dto.getRoomTypeId())
                        .orElseThrow(() -> new RuntimeException("Room Type không tồn tại"));
                r.setRoomType(rt);
            }

            if (dto.getRoomNumber() != null)
                r.setRoomNumber(dto.getRoomNumber());

            if (dto.getAvailable() != null)
                r.setIsAvailable(dto.getAvailable());

            return repo.save(r);

        }
        return null;
    }

    public boolean delete(Long id) {
        if (repo.existsById(id)) {
            repo.deleteById(id);
            return true;
        }
        return false;
    }
    public List<Room> getRoomsByHotelId(Long hotelId) {
        return repo.findByHotelId(hotelId);
    }
}

