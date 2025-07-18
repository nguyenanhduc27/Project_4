package com.example.HotelBoking.Entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.text.DecimalFormat;

@Entity
@Table(name = "booking_details")
public class BookingDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    private Integer nights;

    @Column(nullable = false)
    private BigDecimal price;

    @Column(insertable = false, updatable = false)
    private BigDecimal total;

    // Getters and Setters
    public BookingDetail(){}

    public BookingDetail(Long id, Booking booking, Room room, Integer nights, BigDecimal total) {
        this.id = id;
        this.booking = booking;
        this.room = room;
        this.nights = nights;
        this.total = total;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}

