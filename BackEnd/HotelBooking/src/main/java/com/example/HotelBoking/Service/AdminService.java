package com.example.HotelBoking.Service;

import com.example.HotelBoking.DTO.AdminDTO;
import com.example.HotelBoking.Entity.Admin;
import com.example.HotelBoking.Repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {

    @Autowired
    private AdminRepository repo;

    public Admin toEntity(AdminDTO dto) {
        Admin a = new Admin();
        a.setId(dto.getId());
        a.setUsername(dto.getUsername());
        a.setPassword(dto.getPassword());
        a.setRole(dto.getRole());
        return a;
    }

    public AdminDTO toDTO(Admin a) {
        AdminDTO dto = new AdminDTO();
        dto.setId(a.getId());
        dto.setUsername(a.getUsername());
        dto.setPassword(a.getPassword());
        dto.setRole(a.getRole());
        return dto;
    }

    public List<Admin> getAll() {
        return repo.findAll();
    }

    public Admin findById(Long id) {
        return repo.findById(id).orElse(null);
    }

    public Admin add(AdminDTO dto) {
        Admin a = toEntity(dto);
        return repo.save(a);
    }

    public Admin update(Long id, AdminDTO dto) {
        if (repo.existsById(id)) {
            Admin a = toEntity(dto);
            a.setId(id);
            return repo.save(a);
        }
        return null;
    }

    public boolean delete(Long id) {
        if (repo.existsById(id)) {
            repo.deleteById(id);
            return true;
        }
        return false;
    }
}
