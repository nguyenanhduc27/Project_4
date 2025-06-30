package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
}
