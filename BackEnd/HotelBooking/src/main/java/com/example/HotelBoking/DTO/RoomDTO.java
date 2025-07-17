package com.example.HotelBoking.DTO;

import java.util.List;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.DTO.AmenityDTO;

public class RoomDTO {
    private Integer id;
    private Integer hotelId;
    private RoomTypeDTO roomType;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getHotelId() { return hotelId; }
    public void setHotelId(Integer hotelId) { this.hotelId = hotelId; }
    public RoomTypeDTO getRoomType() { return roomType; }
    public void setRoomType(RoomTypeDTO roomType) { this.roomType = roomType; }
}
