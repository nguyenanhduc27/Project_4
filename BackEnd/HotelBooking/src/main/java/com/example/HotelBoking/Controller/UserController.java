package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Cho phép frontend truy cập (như Flutter)
public class UserController {

    @Autowired
    private UserService userService;

    // Lấy danh sách tất cả user (entity)
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAll();
    }

    // Lấy user theo ID
    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) {
        return userService.findById(id);
    }

    // Thêm user mới từ DTO
    @PostMapping
    public User addUser(@RequestBody UserDTO dto) {
        return userService.add(dto);
    }

    // Cập nhật user theo ID
    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody UserDTO dto) {
        return userService.update(id, dto);
    }

    // Xoá user theo ID
    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable Long id) {
        boolean deleted = userService.delete(id);
        return deleted ? "Xoá thành công!" : "Không tìm thấy user để xoá!";
    }

    // Cập nhật thông tin cá nhân của user hiện tại
    @PutMapping("/me")
    public User updateOwnInfo(@RequestBody UserDTO dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String email = authentication.getName();
        User user = userService.findByEmail(email);
        if (user == null) throw new RuntimeException("User not found");
        return userService.update(user.getId(), dto);
    }
}
