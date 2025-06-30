package com.example.HotelBoking.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HotelDTO {
    private Long id;
    private String name;
    private String address;
    private String city;
    private String description;
    private Integer starRating;
    private Long ownerId;
    private LocalDateTime createdAt;
}
