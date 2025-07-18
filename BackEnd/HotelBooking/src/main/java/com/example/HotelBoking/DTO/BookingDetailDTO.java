package com.example.HotelBoking.DTO;

import java.math.BigDecimal;

public class BookingDetailDTO {
    private Long id;

    private Long bookingId;
    private Long roomId;
    private Long roomTypeId;
    private BigDecimal price;

    public BookingDetailDTO(Long id, Long bookingId, Long roomId, Long roomTypeId, BigDecimal price, Integer nights, BigDecimal total, Integer quantity) {
        this.id = id;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.roomTypeId = roomTypeId;
        this.price = price;
        this.nights = nights;
        this.total = total;
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    private Integer nights;
    private BigDecimal total;
    private Integer quantity; // Thêm trường quantity

    public BookingDetailDTO(){}



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

    public Long getRoomTypeId() {
        return roomTypeId;
    }
    public void setRoomTypeId(Long roomTypeId) {
        this.roomTypeId = roomTypeId;
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
