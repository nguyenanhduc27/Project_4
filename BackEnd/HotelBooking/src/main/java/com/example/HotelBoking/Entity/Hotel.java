package com.example.HotelBoking.Entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "hotels")

public class Hotel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String address;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "star_rating")
    private Integer starRating;

    @Column(name = "owner_id")
    private Long ownerId;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public Hotel(){}

    public Hotel(Long id, String name, String address, String description, Integer starRating, Long ownerId, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.description = description;
        this.starRating = starRating;
        this.ownerId = ownerId;
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getStarRating() {
        return starRating;
    }

    public void setStarRating(Integer starRating) {
        this.starRating = starRating;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}