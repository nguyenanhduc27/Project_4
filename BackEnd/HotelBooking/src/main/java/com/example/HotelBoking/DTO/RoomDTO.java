package com.example.HotelBoking.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public class RoomDTO {
    private Long id;
    private Long hotelId;
    private Long roomTypeId;
    private String roomNumber;
    private Boolean isAvailable;

    public RoomDTO(){}

    public RoomDTO(Long id, Long hotelId, Long roomTypeId, String roomNumber, Boolean isAvailable) {
        this.id = id;
        this.hotelId = hotelId;
        this.roomTypeId = roomTypeId;
        this.roomNumber = roomNumber;
        this.isAvailable = isAvailable;
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

    public Long getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Long roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Boolean getAvailable() {
        return isAvailable;
    }

    public void setAvailable(Boolean available) {
        isAvailable = available;
    }
}
