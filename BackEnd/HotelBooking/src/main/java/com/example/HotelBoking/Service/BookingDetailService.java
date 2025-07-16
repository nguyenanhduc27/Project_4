package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.BookingDetailDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Entity.BookingDetail;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Repository.BookingDetailRepository;
import com.example.HotelBoking.Repository.BookingRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BookingDetailService {

    @Autowired
    private BookingDetailRepository repo;

    @Autowired
    private BookingRepository bookingRepo;

    @Autowired
    private RoomRepository roomRepo;

    public BookingDetailDTO toDTO(BookingDetail b) {
        BookingDetailDTO dto = new BookingDetailDTO();
        dto.setId(b.getId());
        dto.setBookingId(b.getBooking().getId());
        dto.setRoomId(b.getRoom().getId());
        dto.setPrice(b.getPrice());
        dto.setNights(b.getNights());
        dto.setTotal(b.getTotal());
        return dto;
    }

    public BookingDetail toEntity(BookingDetailDTO dto) {
        BookingDetail b = new BookingDetail();
        b.setId(dto.getId());

        Booking booking = bookingRepo.findById(dto.getBookingId())
                .orElseThrow(() -> new RuntimeException("Booking không tồn tại"));
        Room room = roomRepo.findById(dto.getRoomId())
                .orElseThrow(() -> new RuntimeException("Room không tồn tại"));

        b.setBooking(booking);
        b.setRoom(room);
        b.setPrice(dto.getPrice());
        b.setNights(dto.getNights());
        b.setTotal(dto.getPrice().multiply(BigDecimal.valueOf(dto.getNights())));
        return b;
    }

    public List<BookingDetailDTO> getAll() {
        return repo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public BookingDetailDTO findById(Long id) {
        return repo.findById(id).map(this::toDTO).orElse(null);
    }

    public BookingDetail add(BookingDetailDTO dto) {
        if (dto.getPrice().compareTo(BigDecimal.ZERO) <= 0)
            throw new RuntimeException("Giá phải > 0");
        if (dto.getNights() < 1)
            throw new RuntimeException("Số đêm phải >= 1");

        BookingDetail entity = toEntity(dto);
        return repo.save(entity);
    }

    public BookingDetail update(Long id, BookingDetailDTO dto) {
        Optional<BookingDetail> opt = repo.findById(id);
        if (opt.isPresent()) {
            BookingDetail entity = toEntity(dto);
            entity.setId(id);
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


