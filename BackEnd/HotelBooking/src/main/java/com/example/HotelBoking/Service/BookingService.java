package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.BookingDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Repository.BookingRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BookingService {
    @Autowired private BookingRepository repo;
    @Autowired private UserRepository userRepo;
    @Autowired private RoomRepository roomRepo;

    public BookingDTO toDTO(Booking b) {
        BookingDTO dto = new BookingDTO();
        dto.setId(b.getId());
        dto.setCheckIn(b.getCheckIn());
        dto.setCheckOut(b.getCheckOut());
        dto.setTotalPrice(b.getTotalPrice());
        dto.setStatus(b.getStatus());
        dto.setCreatedAt(b.getCreatedAt());
        dto.setUserId(b.getUser().getId());
        return dto;
    }

    public Booking toEntity(BookingDTO dto) {
        Booking b = new Booking();
        b.setId(dto.getId());
        b.setCheckIn(dto.getCheckIn());
        b.setCheckOut(dto.getCheckOut());
        b.setTotalPrice(dto.getTotalPrice());
        b.setCreatedAt(dto.getCreatedAt());
        b.setUser(userRepo.findById(dto.getUserId()).orElseThrow());
        return b;
    }

    public List<BookingDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public BookingDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public Booking add(BookingDTO dto) {
        Booking b = toEntity(dto);
        return repo.save(b);
    }

    public Booking update(Long id, BookingDTO dto) {
        if (repo.existsById(id)) {
            Booking b = toEntity(dto);
            b.setId(id);
            return repo.save(b);
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

    public List<Booking> getBookingUser(Long userId) {
        return repo.findByUserId(userId);
    }

    public List<Booking> getBookingsByStatus(BookingStatus status) {
        return repo.findByStatus(status);
    }
}




