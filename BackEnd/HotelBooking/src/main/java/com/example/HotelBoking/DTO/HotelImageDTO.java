package com.example.HotelBoking.DTO;

public class HotelImageDTO {
    private Long id;
    private Long hotelId;
    private String imageUrl;
    private Boolean isThumbnail;

    public HotelImageDTO(){}

    public HotelImageDTO(Long id, Long hotelId, String imageUrl, Boolean isThumbnail) {
        this.id = id;
        this.hotelId = hotelId;
        this.imageUrl = imageUrl;
        this.isThumbnail = isThumbnail;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getIsThumbnail() {
        return isThumbnail;
    }

    public void setIsThumbnail(Boolean isThumbnail) {
        this.isThumbnail = isThumbnail;
    }
}

