package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.PaymentDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Entity.Payment;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Enum.PaymentStatus;
import com.example.HotelBoking.Repository.BookingRepository;
import com.example.HotelBoking.Repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepo;
    @Autowired
    private BookingRepository bookingRepo;

    public PaymentDTO toDTO(Payment p) {
        PaymentDTO dto = new PaymentDTO();
        dto.setId(p.getId());
        dto.setBookingId(p.getBooking().getId());
        dto.setPaymentMethod(p.getPaymentMethod());
        dto.setAmount(p.getAmount());
        dto.setPaymentDate(p.getPaymentDate());
        dto.setStatus(p.getStatus());
        return dto;
    }

    public Payment toEntity(PaymentDTO dto) {
        Payment p = new Payment();
        p.setId(dto.getId());
        p.setPaymentMethod(dto.getPaymentMethod());
        p.setAmount(dto.getAmount());
        p.setPaymentDate(dto.getPaymentDate());
        p.setBooking(bookingRepo.findById(dto.getBookingId())
                .orElseThrow(() -> new RuntimeException("Booking không tồn tại")));
        return p;
    }

    public List<PaymentDTO> getAll() {
        return paymentRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public PaymentDTO findById(Long id) {
        return paymentRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public Payment add(PaymentDTO dto) {
        Payment p = toEntity(dto);
        return paymentRepo.save(p);
    }

    public Payment update(Long id, PaymentDTO dto) {
        Optional<Payment> opt = paymentRepo.findById(id);
        if (opt.isPresent()) {
            Payment p = opt.get();
            p.setPaymentMethod(dto.getPaymentMethod());
            p.setAmount(dto.getAmount());
            p.setPaymentDate(dto.getPaymentDate());
            p.setStatus(PaymentStatus.Pending);
            if (dto.getBookingId() != null) {
                Booking booking = bookingRepo.findById(dto.getBookingId())
                        .orElseThrow(() -> new RuntimeException("Booking không tồn tại"));
                p.setBooking(booking);
            }
            return paymentRepo.save(p);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (paymentRepo.existsById(id)) {
            paymentRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
