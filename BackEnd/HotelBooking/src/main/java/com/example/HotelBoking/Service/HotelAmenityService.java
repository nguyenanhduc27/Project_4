package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.HotelAmenityDTO;
import com.example.HotelBoking.Entity.Amenity;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.HotelAmenity;
import com.example.HotelBoking.Repository.AmenityRepository;
import com.example.HotelBoking.Repository.HotelAmenityRepository;
import com.example.HotelBoking.Repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class HotelAmenityService {

    @Autowired
    private HotelAmenityRepository repo;

    @Autowired
    private HotelRepository hotelRepo;

    @Autowired
    private AmenityRepository amenityRepo;

    public HotelAmenityDTO toDTO(HotelAmenity entity) {
        HotelAmenityDTO dto = new HotelAmenityDTO();
        dto.setId(entity.getId());
        dto.setHotelId(entity.getHotel().getId());
        dto.setAmenityId(entity.getAmenity().getId());
        return dto;
    }

    public HotelAmenity toEntity(HotelAmenityDTO dto) {
        HotelAmenity entity = new HotelAmenity();
        entity.setId(dto.getId());

        Hotel hotel = hotelRepo.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
        Amenity amenity = amenityRepo.findById(dto.getAmenityId())
                .orElseThrow(() -> new RuntimeException("Amenity không tồn tại"));

        entity.setHotel(hotel);
        entity.setAmenity(amenity);
        return entity;
    }

    public List<HotelAmenityDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public HotelAmenityDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public HotelAmenity add(HotelAmenityDTO dto) {
        HotelAmenity entity = toEntity(dto);
        return repo.save(entity);
    }

    public HotelAmenity update(Long id, HotelAmenityDTO dto) {
        Optional<HotelAmenity> opt = repo.findById(id);
        if (opt.isPresent()) {
            HotelAmenity entity = opt.get();

            if (dto.getHotelId() != null) {
                Hotel hotel = hotelRepo.findById(dto.getHotelId())
                        .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
                entity.setHotel(hotel);
            }

            if (dto.getAmenityId() != null) {
                Amenity amenity = amenityRepo.findById(dto.getAmenityId())
                        .orElseThrow(() -> new RuntimeException("Amenity không tồn tại"));
                entity.setAmenity(amenity);
            }

            return repo.save(entity);
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
}

