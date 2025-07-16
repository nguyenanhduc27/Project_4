package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.RoomDTO;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.DTO.AmenityDTO;
import com.example.HotelBoking.Entity.Amenity;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Entity.RoomType;
import com.example.HotelBoking.Repository.AmenityRepository;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    private AmenityRepository amenityRepository;

    // Mapping entity -> DTO
    private RoomDTO toDTO(Room room) {
        RoomDTO dto = new RoomDTO();
        dto.setId(room.getId());
        dto.setHotelId(room.getHotel() != null ? (room.getHotel().getId() != null ? room.getHotel().getId().intValue() : null) : null);
        dto.setIsAvailable(room.getIsAvailable());
        dto.setRoomImage(room.getRoomImage());
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
            dto.setRoomType(typeDTO);
        }
        // Amenities
        if (room.getAmenities() != null) {
            List<AmenityDTO> amenityDTOs = room.getAmenities().stream().map(a -> {
                AmenityDTO adto = new AmenityDTO();
                adto.setId(a.getId());
                adto.setName(a.getName());
                return adto;
            }).collect(Collectors.toList());
            dto.setAmenities(amenityDTOs);
        }
        return dto;
    }

    // Mapping DTO -> entity
    private Room toEntity(RoomDTO dto) {
        Room room = new Room();
        room.setId(dto.getId());
        room.setIsAvailable(dto.getIsAvailable());
        room.setRoomImage(dto.getRoomImage());
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
        // Amenities
        if (dto.getAmenities() != null) {
            Set<Amenity> amenities = dto.getAmenities().stream()
                    .map(a -> amenityRepository.findById(a.getId()).orElse(null))
                    .filter(a -> a != null)
                    .collect(Collectors.toSet());
            room.setAmenities(amenities);
        }
        return room;
    }

    public List<RoomDTO> getAll() {
        return roomRepository.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public RoomDTO findById(Integer id) {
        return roomRepository.findById(id).map(this::toDTO).orElse(null);
    }

    public RoomDTO add(RoomDTO dto) {
        Room room = toEntity(dto);
        Room saved = roomRepository.save(room);
        return toDTO(saved);
    }

    public RoomDTO update(Integer id, RoomDTO dto) {
        if (roomRepository.existsById(id)) {
            Room room = toEntity(dto);
            room.setId(id);
            Room saved = roomRepository.save(room);
            return toDTO(saved);
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

    public List<RoomDTO> getRoomsByHotelId(Integer hotelId) {
        return roomRepository.findByHotel_Id(hotelId).stream().map(this::toDTO).collect(Collectors.toList());
    }
}
