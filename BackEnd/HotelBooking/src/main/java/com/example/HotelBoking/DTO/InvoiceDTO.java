package com.example.HotelBoking.DTO;

import com.example.HotelBoking.Enum.InvoiceStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class InvoiceDTO {
    private Long id;
    private String invoiceCode;
    private Long bookingId;
    private Long paymentId;
    private LocalDateTime issueDate;
    private BigDecimal totalAmount;
    private BigDecimal taxRate;
    private InvoiceStatus status; // Enum: Draft, Issued, Cancelled

    public InvoiceDTO(){}

    public InvoiceDTO(Long id, String invoiceCode, Long bookingId, Long paymentId, LocalDateTime issueDate, BigDecimal totalAmount, BigDecimal taxRate, InvoiceStatus status) {
        this.id = id;
        this.invoiceCode = invoiceCode;
        this.bookingId = bookingId;
        this.paymentId = paymentId;
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

    public Long getBookingId() {
        return bookingId;
    }

    public void setBookingId(Long bookingId) {
        this.bookingId = bookingId;
    }

    public Long getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
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



