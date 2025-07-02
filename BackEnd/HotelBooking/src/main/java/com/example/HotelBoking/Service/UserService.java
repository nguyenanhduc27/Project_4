package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository repo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Chuyển từ DTO sang Entity
    public User toEntity(UserDTO dto) {
        User u = new User();
        u.setId(dto.getId());
        u.setFullName(dto.getFullName());
        u.setEmail(dto.getEmail());
        u.setPassword(dto.getPassword());
        u.setPhone(dto.getPhone());
        return u;
    }

    // Chuyển từ Entity sang DTO
    public UserDTO toDTO(User u) {
        UserDTO dto = new UserDTO();
        dto.setId(u.getId());
        dto.setFullName(u.getFullName());
        dto.setEmail(u.getEmail());
        dto.setPassword(u.getPassword());
        dto.setPhone(u.getPhone());
        return dto;
    }

    public List<User> getAll() {
        return repo.findAll();
    }

    // Lấy 1 user theo id
    public User findById(Long id) {
        return repo.findById(id).orElse(null);
    }

    // Thêm mới user
    public User add(UserDTO dto) {
        User u = toEntity(dto);
        u.setId(null);
        u.setCreatedAt(LocalDateTime.now());
        return repo.save(u);
    }


    // Cập nhật user
    public User update(Long id, UserDTO dto) {
        Optional<User> opt = repo.findById(id);
        if (opt.isPresent()) {
            User u = opt.get();
            u.setFullName(dto.getFullName());
            u.setEmail(dto.getEmail());
            u.setPhone(dto.getPhone());
            return repo.save(u);
        }
        return null;
    }

    // Xóa user
    public boolean delete(Long id) {
        if (repo.existsById(id)) {
            repo.deleteById(id);
            return true;
        }
        return false;
    }

}
