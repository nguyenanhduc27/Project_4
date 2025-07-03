package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class HotelService {
    @Autowired
    private HotelRepository repo;
    @Autowired
    private UserRepository userRepository;


    private HotelDTO toDTO(Hotel h) {
        HotelDTO dto = new HotelDTO();
        dto.setId(h.getId());
        dto.setName(h.getName());
        dto.setAddress(h.getAddress());
        dto.setCity(h.getCity());
        dto.setDescription(h.getDescription());
        dto.setStarRating(h.getStarRating());
        dto.setOwnerId(h.getOwnerId());
        dto.setCreatedAt(h.getCreatedAt());
        return dto;
    }

    private Hotel toEntity(HotelDTO dto) {
        Hotel h = new Hotel();
        h.setId(dto.getId());
        h.setName(dto.getName());
        h.setAddress(dto.getAddress());
        h.setCity(dto.getCity());
        h.setDescription(dto.getDescription());
        h.setStarRating(dto.getStarRating());
        h.setOwnerId(dto.getOwnerId());
        h.setCreatedAt(dto.getCreatedAt());
        return h;
    }

    public List<Hotel> getAll(){
        return repo.findAll();
    }

    public Hotel findById(Long id){
        return repo.findById(id).orElse(null);
    }

    public Hotel add(HotelDTO dto) {
        if (!userRepository.existsById(dto.getOwnerId())) {
            throw new RuntimeException("Owner ID không tồn tại!");
        }
        Hotel h = toEntity(dto);
        h.setCreatedAt(LocalDateTime.now());
        return repo.save(h);
    }

    public Hotel update(Long id , HotelDTO dto){
        if(repo.existsById(id)){
            Hotel h = toEntity(dto);
            h.setId(id);
            return repo.save(h);
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
}
