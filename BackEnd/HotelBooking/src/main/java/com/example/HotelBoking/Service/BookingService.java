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

@Service
public class BookingService {
    @Autowired
    private BookingRepository repo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private RoomRepository roomRepo;


    private Booking toEntity(BookingDTO dto){
        Booking b = new Booking();
        b.setId(dto.getId());
        b.setCheckIn(dto.getCheckIn());
        b.setCheckOut(dto.getCheckOut());
        b.setTotalPrice(dto.getTotalPrice());
        b.setStatus(dto.getStatus());
        b.setCreatedAt(dto.getCreatedAt());

        if (dto.getUserId() != null) {
            b.setUser(userRepo.findById(dto.getUserId()).orElse(null));
        }

        if (dto.getRoomId() != null) {
            b.setRoom(roomRepo.findById(dto.getRoomId()).orElse(null));
        }

        return b;
    }

    private BookingDTO toDTO(Booking b){
        BookingDTO dto = new BookingDTO();
        dto.setId(b.getId());
        dto.setCheckIn(b.getCheckIn());
        dto.setCheckOut(b.getCheckOut());
        dto.setTotalPrice(b.getTotalPrice());
        dto.setStatus(b.getStatus());
        dto.setCreatedAt(b.getCreatedAt());

        if (b.getUser() != null) {
            dto.setUserId(b.getUser().getId());
        }

        if (b.getRoom() != null) {
            dto.setRoomId(b.getRoom().getId());
        }

        return dto;
    }

    public List<Booking> getAll(){
        return repo.findAll();
    }

    public Booking getById(Long id){
        return repo.findById(id).orElse(null);
    }

    public Booking add(BookingDTO dto) {
        // Check room trùng lịch
        if (!isRoomAvailable(dto.getRoomId(), dto.getCheckIn(), dto.getCheckOut())) {
            throw new RuntimeException("Phòng đã được đặt trong khoảng thời gian này!");
        }

        Booking b = toEntity(dto);
        b.setCreatedAt(LocalDateTime.now());
        b.setStatus(BookingStatus.PENDING); // Gán trạng thái mặc định

        return repo.save(b);
    }

    public Booking update(Long id , BookingDTO dto){
        if(repo.existsById(id)){
            Booking b = toEntity(dto);
            b.setId(id);
            return repo.save(b);
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

    // Kiểm tra phòng có bị trùng lịch không
    public boolean isRoomAvailable(Long roomId, LocalDate checkIn, LocalDate checkOut) {
        List<Booking> bookings = repo.findByRoomIdAndStatus(roomId, BookingStatus.Paid);
        for (Booking b : bookings) {
            // Nếu có overlap → return false
            if (!(checkOut.isBefore(b.getCheckIn()) || checkIn.isAfter(b.getCheckOut()))) {
                return false;
            }
        }
        return true;
    }

    public List<Booking> getBookingUser(Long userId) {
        return repo.findByUserId(userId);
    }

    public List<Booking> getBookingsByStatus(BookingStatus status) {
        return repo.findByStatus(status);
    }

    public List<Booking> getBookingsByUserAndStatus(Long userId, BookingStatus status) {
        return repo.findByUserIdAndStatus(userId, status);
    }

}
