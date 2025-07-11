package com.example.HotelBoking.DTO;

import lombok.*;

import java.math.BigDecimal;

public class RoomTypeDTO {
    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer maxGuests;

    public RoomTypeDTO(){}

    public RoomTypeDTO(Long id, String name, String description, BigDecimal price, Integer maxGuests) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.maxGuests = maxGuests;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getMaxGuests() {
        return maxGuests;
    }

    public void setMaxGuests(Integer maxGuests) {
        this.maxGuests = maxGuests;
    }
}
