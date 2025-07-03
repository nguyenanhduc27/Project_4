package com.example.HotelBoking.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;


public class HotelDTO {
    private Long id;
    private String name;
    private String address;
    private String city;
    private String description;
    private Integer starRating;
    private Long ownerId;
    private LocalDateTime createdAt;

    public HotelDTO(){}

    public HotelDTO(Long id, String name, String address, String city, String description, Integer starRating, Long ownerId, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.city = city;
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

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
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
