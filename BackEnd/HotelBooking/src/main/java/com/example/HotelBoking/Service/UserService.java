package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Entity.User;
import com.example.HotelBoking.Enum.Role;
import com.example.HotelBoking.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepo;

    public UserDTO toDTO(User u) {
        UserDTO dto = new UserDTO();
        dto.setId(u.getId());
        dto.setFullName(u.getFullName());
        dto.setEmail(u.getEmail());
        dto.setPhone(u.getPhone());
        dto.setRole(u.getRole());
        dto.setDateOfBirth(u.getDateOfBirth());
        dto.setAddress(u.getAddress());
        dto.setCreatedAt(u.getCreatedAt());
        return dto;
    }

    public User toEntity(UserDTO dto) {
        User u = new User();
        u.setId(dto.getId());
        u.setFullName(dto.getFullName());
        u.setEmail(dto.getEmail());
        u.setPhone(dto.getPhone());
        u.setRole(dto.getRole());
        u.setDateOfBirth(dto.getDateOfBirth());
        u.setAddress(dto.getAddress());
        u.setCreatedAt(dto.getCreatedAt());
        return u;
    }

    public List<UserDTO> getAll() {
        return userRepo.findAll().stream().map(this::toDTO).collect(Collectors.toList());
    }

    public UserDTO findById(Long id) {
        return userRepo.findById(id).map(this::toDTO).orElse(null);
    }

    public User add(UserDTO dto) {
        User u = toEntity(dto);
        return userRepo.save(u);
    }

    public User update(Long id, UserDTO dto) {
        Optional<User> opt = userRepo.findById(id);
        if (opt.isPresent()) {
            User u = opt.get();
            u.setFullName(dto.getFullName());
            u.setEmail(dto.getEmail());
            u.setPhone(dto.getPhone());
            u.setRole(dto.getRole());
            u.setDateOfBirth(dto.getDateOfBirth());
            u.setAddress(dto.getAddress());
            u.setCreatedAt(dto.getCreatedAt());
            return userRepo.save(u);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (userRepo.existsById(id)) {
            userRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
