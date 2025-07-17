package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.RoomType;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.RoomTypeRepository;
import com.example.HotelBoking.Repository.RoomTypeAmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class RoomService {
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private HotelRepository hotelRepository;
    @Autowired
    private RoomTypeRepository roomTypeRepository;
    @Autowired
    private RoomTypeAmenityRepository roomTypeAmenityRepository;
    // Removed AmenityRepository

    // Mapping entity -> DTO
    private RoomDTO toDTO(Room room, LocalDate checkIn, LocalDate checkOut) {
        RoomDTO dto = new RoomDTO();
        dto.setId(room.getId());
        dto.setHotelId(room.getHotel() != null ? (room.getHotel().getId() != null ? room.getHotel().getId().intValue() : null) : null);
        // RoomType
        if (room.getRoomType() != null) {
            RoomType type = room.getRoomType();
            RoomTypeDTO typeDTO = new RoomTypeDTO();
            typeDTO.setId(type.getId());
            typeDTO.setName(type.getName());
            typeDTO.setDescription(type.getDescription());
            typeDTO.setPrice(type.getPrice());
            typeDTO.setMaxGuests(type.getMaxGuests());
            typeDTO.setDoubleBed(type.getDoubleBed());
            typeDTO.setArea(type.getArea());
            typeDTO.setIsAvailable(type.getIsAvailable());
            typeDTO.setRoomImage(type.getRoomImage());
            // Lấy amenities từ bảng room_types_amenities
            typeDTO.setAmenities(roomTypeAmenityRepository.findAmenityNamesByRoomTypeId(type.getId()));
            // Tính số phòng còn trống
            int available = roomRepository.countAvailableRooms(type.getId(), room.getHotel().getId(), checkIn, checkOut);
            typeDTO.setAvailableRooms(available);
            dto.setRoomType(typeDTO);
        }
        // Removed amenities mapping
        return dto;
    }

    // Mapping DTO -> entity
    private Room toEntity(RoomDTO dto) {
        Room room = new Room();
        room.setId(dto.getId());
        // Hotel
        if (dto.getHotelId() != null) {
            Hotel hotel = hotelRepository.findById((int) dto.getHotelId().longValue()).orElse(null);
            room.setHotel(hotel);
        }
        // RoomType
        if (dto.getRoomType() != null && dto.getRoomType().getId() != null) {
            RoomType type = roomTypeRepository.findById(dto.getRoomType().getId()).orElse(null);
            room.setRoomType(type);
        }
        // Removed amenities mapping
        return room;
    }

    public List<RoomDTO> getAll() {
        LocalDate now = LocalDate.now();
        LocalDate tomorrow = now.plusDays(1);
        return roomRepository.findAll().stream().map(room -> toDTO(room, now, tomorrow)).collect(Collectors.toList());
    }

    public RoomDTO findById(Integer id) {
        LocalDate now = LocalDate.now();
        LocalDate tomorrow = now.plusDays(1);
        return roomRepository.findById(id).map(room -> toDTO(room, now, tomorrow)).orElse(null);
    }

    public RoomDTO add(RoomDTO dto) {
        Room room = toEntity(dto);
        Room saved = roomRepository.save(room);
        LocalDate now = LocalDate.now();
        LocalDate tomorrow = now.plusDays(1);
        return toDTO(saved, now, tomorrow);
    }

    public RoomDTO update(Integer id, RoomDTO dto) {
        if (roomRepository.existsById(id)) {
            Room room = toEntity(dto);
            room.setId(id);
            Room saved = roomRepository.save(room);
            LocalDate now = LocalDate.now();
            LocalDate tomorrow = now.plusDays(1);
            return toDTO(saved, now, tomorrow);
        }
        return null;
    }

    public boolean delete(Integer id) {
        if (roomRepository.existsById(id)) {
            roomRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public List<RoomDTO> getRoomsByHotelId(Integer hotelId, LocalDate checkIn, LocalDate checkOut) {
        return roomRepository.findByHotel_Id(hotelId).stream().map(room -> toDTO(room, checkIn, checkOut)).collect(Collectors.toList());
    }
}
