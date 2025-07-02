package com.example.HotelBoking.Entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "rooms")

public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "hotel_id")
    private Long hotelId;

    @Column(name = "room_type_id")
    private Long roomTypeId;

    @Column(name = "room_number")
    private String roomNumber;

    @Column(name = "is_available")
    private Boolean isAvailable;

    @ManyToOne
    @JoinColumn(name = "hotel_id", insertable = false, updatable = false)
    private Hotel hotel;

    public Room(){}

    public Room(Long id, Long hotelId, Long roomTypeId, String roomNumber, Boolean isAvailable, Hotel hotel) {
        this.id = id;
        this.hotelId = hotelId;
        this.roomTypeId = roomTypeId;
        this.roomNumber = roomNumber;
        this.isAvailable = isAvailable;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getHotelId() {
        return hotelId;
    }

    public void setHotelId(Long hotelId) {
        this.hotelId = hotelId;
    }

    public Long getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Long roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Boolean getAvailable() {
        return isAvailable;
    }

    public void setAvailable(Boolean available) {
        isAvailable = available;
    }

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }
}
