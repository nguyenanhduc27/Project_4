package com.example.HotelBoking.DTO;

import java.math.BigDecimal;

public class BookingDetailDTO {
    private Long id;

    private Long bookingId;
    private Long roomId;
    private BigDecimal price;
    private Integer nights;
    private BigDecimal total;

    public BookingDetailDTO(){}

    public BookingDetailDTO(Long id, Long bookingId, Long roomId, BigDecimal price, Integer nights, BigDecimal total) {
        this.id = id;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.price = price;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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
}
