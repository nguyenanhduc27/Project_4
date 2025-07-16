package com.example.HotelBoking.Entity;

import com.example.HotelBoking.Enum.InvoiceStatus;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "invoices")
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String invoiceCode;

    @OneToOne
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @OneToOne
    @JoinColumn(name = "payment_id")
    private Payment payment;

    private LocalDateTime issueDate;

    private BigDecimal totalAmount;

    private BigDecimal taxRate;

    @Enumerated(EnumType.STRING)
    private InvoiceStatus status;

    public Invoice(){}

    public Invoice(Long id, String invoiceCode, Booking booking, Payment payment, LocalDateTime issueDate, BigDecimal totalAmount, BigDecimal taxRate, InvoiceStatus status) {
        this.id = id;
        this.invoiceCode = invoiceCode;
        this.booking = booking;
        this.payment = payment;
        this.issueDate = issueDate;
        this.totalAmount = totalAmount;
        this.taxRate = taxRate;
        this.status = status;

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public LocalDateTime getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(LocalDateTime issueDate) {
        this.issueDate = issueDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTaxRate() {
        return taxRate;
    }

    public void setTaxRate(BigDecimal taxRate) {
        this.taxRate = taxRate;
    }

    public InvoiceStatus getStatus() {
        return status;
    }

    public void setStatus(InvoiceStatus status) {
        this.status = status;
    }
}

