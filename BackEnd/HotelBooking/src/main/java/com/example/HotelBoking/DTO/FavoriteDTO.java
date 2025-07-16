package com.example.HotelBoking.DTO;

public class FavoriteDTO {
    private Long id;
    private Long userId;
    private Long hotelId;

    public FavoriteDTO(){}

    public FavoriteDTO(Long id, Long userId, Long hotelId) {
        this.id = id;
        this.userId = userId;
        this.hotelId = hotelId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getHotelId() {
        return hotelId;
    }

    public void setHotelId(Long hotelId) {
        this.hotelId = hotelId;
    }
}

