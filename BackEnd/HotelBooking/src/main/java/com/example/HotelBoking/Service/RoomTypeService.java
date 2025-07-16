package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.Entity.RoomType;
import com.example.HotelBoking.Repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomTypeService {

    @Autowired
    private RoomTypeRepository roomTypeRepo;

    public RoomTypeDTO toDTO(RoomType rt) {
        RoomTypeDTO dto = new RoomTypeDTO();
        dto.setId(rt.getId());
        dto.setName(rt.getName());
        dto.setDescription(rt.getDescription());
        dto.setPrice(rt.getPrice());
        dto.setMaxGuests(rt.getMaxGuests());
        return dto;
    }

    public RoomType toEntity(RoomTypeDTO dto) {
        RoomType rt = new RoomType();
        rt.setId(dto.getId());
        rt.setName(dto.getName());
        rt.setDescription(dto.getDescription());
        rt.setPrice(dto.getPrice());
        rt.setMaxGuests(dto.getMaxGuests());
        return rt;
    }

    public List<RoomTypeDTO> getAll() {
        return roomTypeRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public RoomTypeDTO findById(Long id) {
        return roomTypeRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public RoomType add(RoomTypeDTO dto) {
        RoomType rt = toEntity(dto);
        return roomTypeRepo.save(rt);
    }

    public RoomType update(Long id, RoomTypeDTO dto) {
        Optional<RoomType> opt = roomTypeRepo.findById(id);
        if (opt.isPresent()) {
            RoomType rt = opt.get();
            rt.setName(dto.getName());
            rt.setDescription(dto.getDescription());
            rt.setPrice(dto.getPrice());
            rt.setMaxGuests(dto.getMaxGuests());
            return roomTypeRepo.save(rt);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (roomTypeRepo.existsById(id)) {
            roomTypeRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
