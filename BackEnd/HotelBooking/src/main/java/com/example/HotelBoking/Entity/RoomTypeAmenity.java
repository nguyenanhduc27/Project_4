package com.example.HotelBoking.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "room_types_amenities")
public class RoomTypeAmenity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // hoặc dùng composite key nếu cần

    @Column(name = "room_type_id")
    private Integer roomTypeId;

    @Column(name = "amenity_name")
    private String amenityName;

    // getters/setters
}
