package com.example.HotelBoking.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "hotel_amenities")
public class HotelAmenity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "amenity_id")
    private Amenity amenity;

    public HotelAmenity(){}

    public HotelAmenity(Long id, Hotel hotel, Amenity amenity) {
        this.id = id;
        this.hotel = hotel;
        this.amenity = amenity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }

    public Amenity getAmenity() {
        return amenity;
    }

    public void setAmenity(Amenity amenity) {
        this.amenity = amenity;
    }
}

