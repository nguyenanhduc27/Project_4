package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.InvoiceDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Entity.Invoice;
import com.example.HotelBoking.Entity.Payment;
import com.example.HotelBoking.Enum.InvoiceStatus;
import com.example.HotelBoking.Enum.PaymentStatus;
import com.example.HotelBoking.Repository.BookingRepository;
import com.example.HotelBoking.Repository.InvoiceRepository;
import com.example.HotelBoking.Repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class InvoiceService {

    @Autowired
    private InvoiceRepository invoiceRepo;
    @Autowired
    private BookingRepository bookingRepo;
    @Autowired
    private PaymentRepository paymentRepo;

    public InvoiceDTO toDTO(Invoice invoice) {
        InvoiceDTO dto = new InvoiceDTO();
        dto.setId(invoice.getId());
        dto.setInvoiceCode(invoice.getInvoiceCode());
        dto.setBookingId(invoice.getBooking().getId());
        dto.setPaymentId(invoice.getPayment() != null ? invoice.getPayment().getId() : null);
        dto.setIssueDate(invoice.getIssueDate());
        dto.setTotalAmount(invoice.getTotalAmount());
        dto.setTaxRate(invoice.getTaxRate());
        dto.setStatus(invoice.getStatus());
        return dto;
    }

    public Invoice toEntity(InvoiceDTO dto) {
        Invoice invoice = new Invoice();
        invoice.setId(dto.getId());
        invoice.setInvoiceCode(dto.getInvoiceCode());
        invoice.setBooking(bookingRepo.findById(dto.getBookingId())
                .orElseThrow(() -> new RuntimeException("Booking không tồn tại")));
        if (dto.getPaymentId() != null) {
            Payment payment = paymentRepo.findById(dto.getPaymentId())
                    .orElseThrow(() -> new RuntimeException("Payment không tồn tại"));
            invoice.setPayment(payment);
        }
        invoice.setIssueDate(dto.getIssueDate());
        invoice.setTotalAmount(dto.getTotalAmount());
        invoice.setTaxRate(dto.getTaxRate());
        return invoice;
    }

    public List<InvoiceDTO> getAll() {
        return invoiceRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public InvoiceDTO findById(Long id) {
        return invoiceRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public Invoice add(InvoiceDTO dto) {
        Invoice invoice = toEntity(dto);
        return invoiceRepo.save(invoice);
    }

    public Invoice update(Long id, InvoiceDTO dto) {
        Optional<Invoice> opt = invoiceRepo.findById(id);
        if (opt.isPresent()) {
            Invoice invoice = opt.get();
            invoice.setInvoiceCode(dto.getInvoiceCode());
            invoice.setIssueDate(dto.getIssueDate());
            invoice.setTotalAmount(dto.getTotalAmount());
            invoice.setTaxRate(dto.getTaxRate());

            if (dto.getBookingId() != null) {
                Booking booking = bookingRepo.findById(dto.getBookingId())
                        .orElseThrow(() -> new RuntimeException("Booking không tồn tại"));
                invoice.setBooking(booking);
            }
            if (dto.getPaymentId() != null) {
                Payment payment = paymentRepo.findById(dto.getPaymentId())
                        .orElseThrow(() -> new RuntimeException("Payment không tồn tại"));
                invoice.setPayment(payment);
            }
            return invoiceRepo.save(invoice);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (invoiceRepo.existsById(id)) {
            invoiceRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
