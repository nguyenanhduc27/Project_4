package com.example.HotelBoking.DTO;

import java.util.List;
import com.example.HotelBoking.DTO.RoomTypeDTO;
import com.example.HotelBoking.DTO.AmenityDTO;

public class RoomDTO {
    private Integer id;
    private Integer hotelId;
    private RoomTypeDTO roomType;
    private Boolean isAvailable;
    private String roomImage;
    private List<AmenityDTO> amenities;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getHotelId() { return hotelId; }
    public void setHotelId(Integer hotelId) { this.hotelId = hotelId; }
    public RoomTypeDTO getRoomType() { return roomType; }
    public void setRoomType(RoomTypeDTO roomType) { this.roomType = roomType; }
    public Boolean getIsAvailable() { return isAvailable; }
    public void setIsAvailable(Boolean isAvailable) { this.isAvailable = isAvailable; }
    public String getRoomImage() { return roomImage; }
    public void setRoomImage(String roomImage) { this.roomImage = roomImage; }
    public List<AmenityDTO> getAmenities() { return amenities; }
    public void setAmenities(List<AmenityDTO> amenities) { this.amenities = amenities; }
}
