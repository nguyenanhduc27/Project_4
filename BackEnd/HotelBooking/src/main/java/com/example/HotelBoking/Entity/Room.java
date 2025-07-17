package com.example.HotelBoking.Entity;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "rooms")
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_type_id")
    private RoomType roomType;

    // Removed isAvailable and roomImage fields
    // Removed amenities field and annotation

    // Getters and setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Hotel getHotel() { return hotel; }
    public void setHotel(Hotel hotel) { this.hotel = hotel; }
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
    public Boolean getIsAvailable() { return null; } // Removed
    public void setIsAvailable(Boolean isAvailable) { /* Removed */ }
    public String getRoomImage() { return null; } // Removed
    public void setRoomImage(String roomImage) { /* Removed */ }
    // Removed getAmenities and setAmenities
}
