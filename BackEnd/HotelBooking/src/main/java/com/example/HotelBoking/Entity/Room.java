package com.example.HotelBoking.Entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "rooms")

public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "room_type_id")
    private RoomType roomType;

    @Column(name = "room_number")
    private String roomNumber;

    @Column(name = "is_available")
    private Boolean isAvailable;

    public Room(){}

    public Room(Long id, Hotel hotel, RoomType roomType, String roomNumber, Boolean isAvailable) {
        this.id = id;
        this.hotel = hotel;
        this.roomType = roomType;
        this.roomNumber = roomNumber;
        this.isAvailable = isAvailable;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Boolean getIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(Boolean available) {
        isAvailable = available;
    }

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }
}
