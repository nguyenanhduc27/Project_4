package com.example.HotelBoking.DTO;

import java.math.BigDecimal;

public class BookingDetailDTO {
    private Long id;

    private Long bookingId;
    private Long roomId;
    private Integer nights;
    private BigDecimal total;
    private Integer quantity; // Thêm trường quantity

    public BookingDetailDTO(){}

    public BookingDetailDTO(Long id, Long bookingId, Long roomId, Integer nights, BigDecimal total) {
        this.id = id;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.nights = nights;
        this.total = total;
    }

    // Getters & Setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBookingId() {
        return bookingId;
    }

    public void setBookingId(Long bookingId) {
        this.bookingId = bookingId;
    }

    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }



    public Integer getNights() {
        return nights;
    }

    public void setNights(Integer nights) {
        this.nights = nights;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
