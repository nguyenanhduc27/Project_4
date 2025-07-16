package com.example.HotelBoking.DTO;

import java.math.BigDecimal;

public class RoomTypeDTO {
    private Integer id;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer maxGuests;
    private Integer doubleBed;
    private BigDecimal area;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getMaxGuests() { return maxGuests; }
    public void setMaxGuests(Integer maxGuests) { this.maxGuests = maxGuests; }
    public Integer getDoubleBed() { return doubleBed; }
    public void setDoubleBed(Integer doubleBed) { this.doubleBed = doubleBed; }
    public BigDecimal getArea() { return area; }
    public void setArea(BigDecimal area) { this.area = area; }
}
