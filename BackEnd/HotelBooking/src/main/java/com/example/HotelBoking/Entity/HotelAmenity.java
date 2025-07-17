package com.example.HotelBoking.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "hotel_amenities")
public class HotelAmenity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // hoặc dùng composite key nếu cần

    @Column(name = "hotel_id")
    private Integer hotelId;

    @Column(name = "amenity_name")
    private String amenityName;

    // getters/setters
}
