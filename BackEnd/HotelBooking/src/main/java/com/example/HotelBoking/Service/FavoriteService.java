package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.FavoriteDTO;
import com.example.HotelBoking.Entity.Favorite;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Repository.FavoriteRepository;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FavoriteService {

    @Autowired
    private FavoriteRepository repo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private HotelRepository hotelRepo;

    public FavoriteDTO toDTO(Favorite f) {
        FavoriteDTO dto = new FavoriteDTO();
        dto.setId(f.getId());
        dto.setUserId(f.getUser().getId());
        dto.setHotelId(f.getHotel().getId());
        return dto;
    }

    public Favorite toEntity(FavoriteDTO dto) {
        Favorite f = new Favorite();
        f.setId(dto.getId());

        f.setUser(userRepo.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("User không tồn tại")));

        f.setHotel(hotelRepo.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel không tồn tại")));
        return f;
    }

    public List<FavoriteDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public FavoriteDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public Favorite add(FavoriteDTO dto) {
        Favorite f = toEntity(dto);
        return repo.save(f);
    }

    public Favorite update(Long id, FavoriteDTO dto) {
        Optional<Favorite> opt = repo.findById(id);
        if (opt.isPresent()) {
            Favorite f = opt.get();

            if (dto.getUserId() != null) {
                User user = userRepo.findById(dto.getUserId())
                        .orElseThrow(() -> new RuntimeException("User không tồn tại"));
                f.setUser(user);
            }

            if (dto.getHotelId() != null) {
                Hotel hotel = hotelRepo.findById(dto.getHotelId())
                        .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
                f.setHotel(hotel);
            }

            return repo.save(f);
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

