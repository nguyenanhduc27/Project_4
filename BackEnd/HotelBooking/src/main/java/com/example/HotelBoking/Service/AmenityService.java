package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.AmenityDTO;
import com.example.HotelBoking.Entity.Amenity;
import com.example.HotelBoking.Repository.AmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AmenityService {

    @Autowired
    private AmenityRepository repo;

    public AmenityDTO toDTO(Amenity entity) {
        AmenityDTO dto = new AmenityDTO();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        return dto;
    }

    public Amenity toEntity(AmenityDTO dto) {
        Amenity entity = new Amenity();
        entity.setId(dto.getId());
        entity.setName(dto.getName());
        return entity;
    }

    public List<AmenityDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public AmenityDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public Amenity add(AmenityDTO dto) {
        Amenity entity = toEntity(dto);
        return repo.save(entity);
    }

    public Amenity update(Long id, AmenityDTO dto) {
        Optional<Amenity> opt = repo.findById(id);
        if (opt.isPresent()) {
            Amenity entity = opt.get();
            entity.setName(dto.getName());
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

