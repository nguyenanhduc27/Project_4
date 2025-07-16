package com.example.HotelBoking.DTO;

public class HotelAmenityDTO {
    private Long id;
    private Long hotelId;
    private Long amenityId;

    public HotelAmenityDTO(){}

    public HotelAmenityDTO(Long id, Long hotelId, Long amenityId) {
        this.id = id;
        this.hotelId = hotelId;
        this.amenityId = amenityId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getHotelId() {
        return hotelId;
    }

    public void setHotelId(Long hotelId) {
        this.hotelId = hotelId;
    }

    public Long getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Long amenityId) {
        this.amenityId = amenityId;
    }
}

