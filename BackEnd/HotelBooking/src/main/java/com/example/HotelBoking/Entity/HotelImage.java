package com.example.HotelBoking.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "hotel_images")
public class HotelImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "is_thumbnail")
    private Boolean isThumbnail;

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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getThumbnail() {
        return isThumbnail;
    }

    public void setThumbnail(Boolean thumbnail) {
        isThumbnail = thumbnail;
    }
}
