package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.AdminDTO;
import com.example.HotelBoking.Entity.Admin;
import com.example.HotelBoking.Service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admins")
@CrossOrigin(origins = "*") // Cho phép frontend truy cập (Angular/React/Thymeleaf)
public class AdminController {

    @Autowired
    private AdminService adminService;

    // Lấy danh sách tất cả admin (entity)
    @GetMapping
    public List<Admin> getAllAdmins() {
        return adminService.getAll();
    }

    // Lấy admin theo ID
    @GetMapping("/{id}")
    public Admin getAdminById(@PathVariable Long id) {
        return adminService.findById(id);
    }

    // Thêm admin mới
    @PostMapping
    public Admin addAdmin(@RequestBody AdminDTO dto) {
        return adminService.add(dto);
    }

    // Cập nhật admin theo ID
    @PutMapping("/{id}")
    public Admin updateAdmin(@PathVariable Long id, @RequestBody AdminDTO dto) {
        return adminService.update(id, dto);
    }

    // Xóa admin theo ID
    @DeleteMapping("/{id}")
    public String deleteAdmin(@PathVariable Long id) {
        boolean deleted = adminService.delete(id);
        return deleted ? "Xoá admin thành công!" : "Không tìm thấy admin để xoá!";
    }
}
