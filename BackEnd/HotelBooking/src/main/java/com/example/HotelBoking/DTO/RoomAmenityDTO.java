package com.example.HotelBoking.DTO;

public class RoomAmenityDTO {
    private Long id;
    private Long roomId;
    private Long amenityId;

    public RoomAmenityDTO(){}

    public RoomAmenityDTO(Long id, Long roomId, Long amenityId) {
        this.id = id;
        this.roomId = roomId;
        this.amenityId = amenityId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRoomId() {
        return roomId;
    }

    public void setRoomId(Long roomId) {
        this.roomId = roomId;
    }

    public Long getAmenityId() {
        return amenityId;
    }

    public void setAmenityId(Long amenityId) {
        this.amenityId = amenityId;
    }
}

