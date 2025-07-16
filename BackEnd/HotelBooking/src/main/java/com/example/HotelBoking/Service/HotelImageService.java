package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.HotelImageDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.HotelImage;
import com.example.HotelBoking.Repository.HotelImageRepository;
import com.example.HotelBoking.Repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class HotelImageService {

    @Autowired
    private HotelImageRepository repo;

    @Autowired
    private HotelRepository hotelRepo;

    public HotelImageDTO toDTO(HotelImage entity) {
        HotelImageDTO dto = new HotelImageDTO();
        dto.setId(entity.getId());
        dto.setHotelId(entity.getHotel().getId());
        dto.setImageUrl(entity.getImageUrl());
        dto.setIsThumbnail(entity.getIsThumbnail());
        return dto;
    }

    public HotelImage toEntity(HotelImageDTO dto) {
        Hotel hotel = hotelRepo.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));

        HotelImage entity = new HotelImage();
        entity.setId(dto.getId());
        entity.setHotel(hotel);
        entity.setImageUrl(dto.getImageUrl());
        entity.setIsThumbnail(dto.getIsThumbnail());
        return entity;
    }

    public List<HotelImageDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public HotelImageDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public HotelImage add(HotelImageDTO dto) {
        HotelImage entity = toEntity(dto);
        return repo.save(entity);
    }

    public HotelImage update(Long id, HotelImageDTO dto) {
        Optional<HotelImage> opt = repo.findById(id);
        if (opt.isPresent()) {
            HotelImage entity = opt.get();

            if (dto.getHotelId() != null) {
                Hotel hotel = hotelRepo.findById(dto.getHotelId())
                        .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
                entity.setHotel(hotel);
            }

            if (dto.getImageUrl() != null) {
                entity.setImageUrl(dto.getImageUrl());
            }

            if (dto.getIsThumbnail() != null) {
                entity.setIsThumbnail(dto.getIsThumbnail());
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

