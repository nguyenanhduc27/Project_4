package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.ReviewDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Review;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.ReviewRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepo;
    @Autowired
    private UserRepository userRepo;
    @Autowired
    private HotelRepository hotelRepo;

    public ReviewDTO toDTO(Review r) {
        ReviewDTO dto = new ReviewDTO();
        dto.setId(r.getId());
        dto.setUserId(r.getUser().getId());
        dto.setHotelId(r.getHotel().getId());
        dto.setRating(r.getRating());
        dto.setComment(r.getComment());
        dto.setCreatedAt(r.getCreatedAt());
        return dto;
    }

    public Review toEntity(ReviewDTO dto) {
        Review r = new Review();
        r.setId(dto.getId());
        r.setRating(dto.getRating());
        r.setComment(dto.getComment());
        r.setCreatedAt(dto.getCreatedAt());

        r.setUser(userRepo.findById(dto.getUserId())
                .orElseThrow(() -> new RuntimeException("User không tồn tại")));
        r.setHotel(hotelRepo.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel không tồn tại")));
        return r;
    }

    public List<ReviewDTO> getAll() {
        return reviewRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public ReviewDTO findById(Long id) {
        return reviewRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public Review add(ReviewDTO dto) {
        Review r = toEntity(dto);
        return reviewRepo.save(r);
    }

    public Review update(Long id, ReviewDTO dto) {
        Optional<Review> opt = reviewRepo.findById(id);
        if (opt.isPresent()) {
            Review r = opt.get();
            r.setRating(dto.getRating());
            r.setComment(dto.getComment());
            r.setCreatedAt(dto.getCreatedAt());

            if (dto.getUserId() != null) {
                User user = userRepo.findById(dto.getUserId())
                        .orElseThrow(() -> new RuntimeException("User không tồn tại"));
                r.setUser(user);
            }

            if (dto.getHotelId() != null) {
                Hotel hotel = hotelRepo.findById(dto.getHotelId())
                        .orElseThrow(() -> new RuntimeException("Hotel không tồn tại"));
                r.setHotel(hotel);
            }
            return reviewRepo.save(r);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (reviewRepo.existsById(id)) {
            reviewRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
