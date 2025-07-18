package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.BookingDetailDTO;
import com.example.HotelBoking.DTO.HotelDTO;
import com.example.HotelBoking.Entity.Hotel;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Repository.BookingDetailRepository;
import com.example.HotelBoking.Repository.HotelRepository;
import com.example.HotelBoking.Repository.HotelImageRepository;
import com.example.HotelBoking.Repository.HotelAmenityRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class HotelService {
    @Autowired
    private HotelRepository repo;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private HotelRepository hotelRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private BookingDetailRepository bookingDetailRepository;

    @Autowired
    private HotelImageRepository hotelImageRepository;

    @Autowired
    private HotelAmenityRepository hotelAmenityRepository;


    public HotelDTO toDTO(Hotel h) {
        HotelDTO dto = new HotelDTO();
        dto.setId(h.getId());
        dto.setName(h.getName());
        dto.setAddress(h.getAddress());
        dto.setCity(h.getCity());
        dto.setDescription(h.getDescription());
        dto.setStarRating(h.getStarRating());
        dto.setCreatedAt(h.getCreatedAt());
        dto.setLatitude(h.getLatitude());
        dto.setLongitude(h.getLongitude());

        String thumbnailUrl = hotelImageRepository.findThumbnailUrlByHotelId(h.getId());
        dto.setThumbnailUrl(thumbnailUrl);
        // Lấy danh sách tất cả ảnh
        List<String> imageUrls = hotelImageRepository.findAllByHotelId(h.getId())
            .stream()
            .map(img -> img.getImageUrl())
            .collect(java.util.stream.Collectors.toList());
        dto.setImageUrls(imageUrls);
        // Lấy amenities từ bảng hotel_amenities
        dto.setAmenities(hotelAmenityRepository.findAmenityNamesByHotelId(h.getId()));
        return dto;
    }

    private Hotel toEntity(HotelDTO dto) {
        Hotel h = new Hotel();
        h.setId(dto.getId());
        h.setName(dto.getName());
        h.setAddress(dto.getAddress());
        h.setCity(dto.getCity());
        h.setDescription(dto.getDescription());
        h.setStarRating(dto.getStarRating());
        h.setCreatedAt(dto.getCreatedAt());
        return h;
    }

    public List<Hotel> getAll() {
        return repo.findAll();
    }

    public Hotel findById(Integer id) {
        return repo.findById(id).orElse(null);
    }

    public Hotel add(HotelDTO dto) {
        Hotel h = toEntity(dto);
        h.setCreatedAt(LocalDateTime.now());
        return repo.save(h);
    }

    public Hotel update(Integer id, HotelDTO dto) {
        if (repo.existsById(id)) {
            Hotel h = toEntity(dto);
            h.setId(id);
            return repo.save(h);
        }
        return null;
    }

    public boolean delete(Integer id) {
        if (repo.existsById(id)) {
            repo.deleteById(id);
            return true;
        }
        return false;
    }


    public List<Hotel> searchHotels(LocalDate checkIn, LocalDate checkOut, String city, int requiredRoomCount) {

        System.out.println("CheckIn: " + checkIn);
        System.out.println("CheckOut: " + checkOut);
        System.out.println("City: " + city);
        System.out.println("Số lượng phòng cần: " + requiredRoomCount);

        List<Hotel> hotels = hotelRepository.findByCity(city);
        List<Hotel> availableHotels = new ArrayList<>();

        List<BookingStatus> statuses = List.of(BookingStatus.PENDING, BookingStatus.Paid);

        for (Hotel hotel : hotels) {
            List<Room> rooms = roomRepository.findByHotel_Id(hotel.getId());
            int availableCount = 0;

            for (Room room : rooms) {
                if (room.getRoomType() == null || !Boolean.TRUE.equals(room.getRoomType().getIsAvailable())) continue;

                boolean isBooked = bookingDetailRepository.existsActiveBooking(
                        room.getId(), statuses, checkIn, checkOut
                );

                if (!isBooked) {
                    availableCount++;
                }
            }

            System.out.println("Hotel: " + hotel.getName() + " => Available rooms: " + availableCount);

            if (availableCount >= requiredRoomCount) {
                availableHotels.add(hotel);
            }
        }

        return availableHotels;
    }

    public List<HotelDTO> getAllDTOs() {
        List<Hotel> hotels = repo.findAll();
        List<HotelDTO> dtos = new ArrayList<>();
        for (Hotel h : hotels) {
            dtos.add(toDTO(h));
        }
        return dtos;
    }
}


