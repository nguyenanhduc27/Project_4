package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.BookingDTO;
import com.example.HotelBoking.DTO.BookingDetailDTO;
import com.example.HotelBoking.Entity.Booking;
import com.example.HotelBoking.Entity.BookingDetail;
import com.example.HotelBoking.Entity.Room;
import com.example.HotelBoking.Enum.BookingStatus;
import com.example.HotelBoking.Repository.BookingRepository;
import com.example.HotelBoking.Repository.BookingDetailRepository;
import com.example.HotelBoking.Repository.RoomRepository;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import com.example.HotelBoking.DTO.BookingContactDTO;
import com.example.HotelBoking.Entity.BookingContact;
import com.example.HotelBoking.Repository.BookingContactRepository;

@Service
public class BookingService {
    @Autowired
    private BookingRepository repo;

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private RoomRepository roomRepo;

    @Autowired
    private BookingContactRepository contactRepo;

    @Autowired
    private BookingDetailRepository bookingDetailRepo;

    private Booking toEntity(BookingDTO dto){
        Booking b = new Booking();
        b.setId(dto.getId());
        b.setCheckIn(dto.getCheckIn());
        b.setCheckOut(dto.getCheckOut());
        b.setTotalPrice(dto.getTotalPrice());
        b.setStatus(dto.getStatus());
        b.setCreatedAt(dto.getCreatedAt());

        // Chỉ set user nếu userId không null và user tồn tại
        if (dto.getUserId() != null) {
            b.setUser(userRepo.findById(dto.getUserId()).orElse(null));
        } else {
            b.setUser(null); // Đảm bảo user là null khi không có userId
        }

        return b;
    }

    private BookingDTO toDTO(Booking b){
        BookingDTO dto = new BookingDTO();
        dto.setId(b.getId());
        dto.setCheckIn(b.getCheckIn());
        dto.setCheckOut(b.getCheckOut());
        dto.setTotalPrice(b.getTotalPrice());
        dto.setStatus(b.getStatus());
        dto.setCreatedAt(b.getCreatedAt());

        if (b.getUser() != null) {
            dto.setUserId(b.getUser().getId());
        }

        return dto;
    }

    public List<Booking> getAll(){
        return repo.findAll();
    }

    public Booking getById(Long id){
        return repo.findById(id).orElse(null);
    }

    public Booking add(BookingDTO dto) {
        try {
            System.out.println("=== DEBUG DỮ LIỆU ĐẦU VÀO ===");
            System.out.println("BookingDTO: " + dto);
            System.out.println("hotelId: " + dto.getHotelId());
            System.out.println("userId: " + dto.getUserId());
            System.out.println("checkIn: " + dto.getCheckIn());
            System.out.println("checkOut: " + dto.getCheckOut());
            System.out.println("totalPrice: " + dto.getTotalPrice());
            System.out.println("contact: " + dto.getContact());
            System.out.println("rooms: " + dto.getRooms());
            System.out.println("=== KẾT THÚC DEBUG ===");
            
            // Kiểm tra dữ liệu đầu vào
            if (dto.getCheckIn() == null || dto.getCheckOut() == null || dto.getTotalPrice() == null) {
                throw new IllegalArgumentException("Thiếu thông tin bắt buộc: checkIn, checkOut, totalPrice");
            }
            
            // Kiểm tra ngày check-in và check-out
            if (dto.getCheckIn().isAfter(dto.getCheckOut()) || dto.getCheckIn().isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày check-in phải trước ngày check-out và không được trong quá khứ");
            }
            
            // Kiểm tra contact nếu có
            if (dto.getContact() != null) {
                if (dto.getContact().getFullName() == null || dto.getContact().getFullName().trim().isEmpty()) {
                    throw new IllegalArgumentException("Tên liên hệ không được để trống");
                }
                if (dto.getContact().getEmail() == null || dto.getContact().getEmail().trim().isEmpty()) {
                    throw new IllegalArgumentException("Email liên hệ không được để trống");
                }
                if (dto.getContact().getPhone() == null || dto.getContact().getPhone().trim().isEmpty()) {
                    throw new IllegalArgumentException("Số điện thoại liên hệ không được để trống");
                }
            }
            
            // Kiểm tra rooms
            if (dto.getRooms() == null || dto.getRooms().isEmpty()) {
                throw new IllegalArgumentException("Phải chọn ít nhất một phòng");
            }
            // Validate cơ bản từng room (chỉ check dữ liệu, không truy cập DB)
            for (BookingDetailDTO roomDetail : dto.getRooms()) {
                if (roomDetail.getQuantity() == null || roomDetail.getQuantity() <= 0) {
                    throw new IllegalArgumentException("Số lượng phòng phải lớn hơn 0");
                }
                if (roomDetail.getRoomId() == null && roomDetail.getRoomTypeId() == null) {
                    throw new IllegalArgumentException("Cần truyền roomId hoặc roomTypeId");
                }
            }
            
            Booking b = toEntity(dto);
            b.setCreatedAt(LocalDateTime.now());
            b.setStatus(BookingStatus.PENDING); // Gán trạng thái mặc định

            System.out.println("Đã tạo entity booking, bắt đầu lưu...");
            Booking savedBooking = repo.save(b);
            System.out.println("Đã lưu booking với ID: " + savedBooking.getId());

            // Lưu booking details
            System.out.println("Bắt đầu lưu booking details...");
            try {
                for (BookingDetailDTO roomDetail : dto.getRooms()) {
                    if (roomDetail.getRoomId() != null) {
                        Room room = roomRepo.findById(roomDetail.getRoomId().intValue()).orElse(null);
                        if (room != null) {
                            boolean isBooked = bookingDetailRepo.existsActiveBooking(
                                room.getId(),
                                java.util.List.of(BookingStatus.PENDING, BookingStatus.Paid),
                                dto.getCheckIn(),
                                dto.getCheckOut()
                            );
                            if (isBooked) {
                                throw new IllegalArgumentException("Phòng với ID " + room.getId() + " đã được đặt trong khoảng ngày này");
                            }
                            long nights = ChronoUnit.DAYS.between(dto.getCheckIn(), dto.getCheckOut());
                            for (int i = 0; i < roomDetail.getQuantity(); i++) {
                                BookingDetail detail = new BookingDetail();
                                detail.setBooking(savedBooking);
                                detail.setRoom(room);
                                detail.setNights((int) nights);
                                detail.setPrice(roomDetail.getPrice());
                                bookingDetailRepo.save(detail);
                            }
                        }
                    } else {
                        Integer hotelId = dto.getHotelId() != null ? dto.getHotelId().intValue() : null;
                        Integer roomTypeId = roomDetail.getRoomTypeId() != null ? roomDetail.getRoomTypeId().intValue() : null;
                        if (hotelId == null || roomTypeId == null) {
                            throw new IllegalArgumentException("Thiếu hotelId hoặc roomTypeId để tự động chọn phòng");
                        }
                        List<Room> availableRooms = roomRepo.findAvailableRooms(
                            roomTypeId, hotelId, dto.getCheckIn(), dto.getCheckOut()
                        );
                        if (availableRooms.size() < roomDetail.getQuantity()) {
                            throw new IllegalArgumentException("Không đủ phòng loại này còn trống");
                        }
                        long nights = ChronoUnit.DAYS.between(dto.getCheckIn(), dto.getCheckOut());
                        for (int i = 0; i < roomDetail.getQuantity(); i++) {
                            Room room = availableRooms.get(i);
                            BookingDetail detail = new BookingDetail();
                            detail.setBooking(savedBooking);
                            detail.setRoom(room);
                            detail.setNights((int) nights);
                            detail.setPrice(roomDetail.getPrice());
                            bookingDetailRepo.save(detail);
                        }
                    }
                }
                System.out.println("Đã lưu booking details thành công");
            } catch (Exception e) {
                System.err.println("Lỗi khi lưu booking details: " + e.getMessage());
                e.printStackTrace();
                // Không throw exception vì booking đã được lưu thành công
            }

            // Lưu contact nếu có hoặc tự động lấy từ user nếu contact null và userId có
            if (dto.getContact() != null) {
                System.out.println("Bắt đầu lưu contact từ DTO...");
                try {
                    BookingContact contact = new BookingContact();
                    contact.setBooking(savedBooking);
                    contact.setFullName(dto.getContact().getFullName());
                    contact.setEmail(dto.getContact().getEmail());
                    contact.setPhone(dto.getContact().getPhone());
                    contact.setNote(dto.getContact().getNote() != null ? dto.getContact().getNote() : "");
                    contact.setCreatedAt(LocalDateTime.now());
                    contact.setUpdatedAt(LocalDateTime.now());
                    contactRepo.save(contact);
                    System.out.println("Đã lưu contact thành công");
                } catch (Exception e) {
                    System.err.println("Lỗi khi lưu contact: " + e.getMessage());
                    // Không throw exception vì booking đã được lưu thành công
                }
            } else if (dto.getUserId() != null) {
                // Nếu contact null nhưng userId có, tự động lấy thông tin user
                System.out.println("Tự động lấy thông tin liên hệ từ user để lưu contact...");
                try {
                    var userOpt = userRepo.findById(dto.getUserId());
                    if (userOpt.isPresent()) {
                        var user = userOpt.get();
                        BookingContact contact = new BookingContact();
                        contact.setBooking(savedBooking);
                        contact.setFullName(user.getFullName());
                        contact.setEmail(user.getEmail());
                        contact.setPhone(user.getPhone());
                        contact.setNote("");
                        contact.setCreatedAt(LocalDateTime.now());
                        contact.setUpdatedAt(LocalDateTime.now());
                        contactRepo.save(contact);
                        System.out.println("Đã lưu contact từ user thành công");
                    } else {
                        System.err.println("Không tìm thấy user để lưu contact!");
                    }
                } catch (Exception e) {
                    System.err.println("Lỗi khi lưu contact từ user: " + e.getMessage());
                }
            }

            System.out.println("Hoàn thành tạo booking");
            return savedBooking;
        } catch (Exception e) {
            System.err.println("Lỗi khi tạo booking: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Booking update(Long id , BookingDTO dto){
        if(repo.existsById(id)){
            Booking b = toEntity(dto);
            b.setId(id);
            return repo.save(b);
        }
        return null;
    }
    
    public boolean delete(Long id){
        if(repo.existsById(id)){
            repo.deleteById(id);
            return true;
        }
        return false;
    }

    public List<Booking> getBookingUser(Long userId) {
        return repo.findByUserId(userId);
    }

    public List<Booking> getBookingsByStatus(BookingStatus status) {
        return repo.findByStatus(status);
    }
}
