package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.FavoriteDTO;
import com.example.HotelBoking.Entity.Favorite;
import com.example.HotelBoking.Service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
    @RequestMapping("/api/favorites")
    public class FavoriteController {

        @Autowired
        private FavoriteService service;

        // Lấy tất cả favorite
        @GetMapping
        public List<FavoriteDTO> getAllFavorites() {
            return service.getAll();
        }

        // Lấy favorite theo ID
        @GetMapping("/{id}")
        public ResponseEntity<FavoriteDTO> getFavoriteById(@PathVariable Long id) {
            FavoriteDTO dto = service.findById(id);
            if (dto != null) {
                return ResponseEntity.ok(dto);
            }
            return ResponseEntity.notFound().build();
        }

        // Thêm mới favorite
        @PostMapping
        public ResponseEntity<?> addFavorite(@RequestBody FavoriteDTO dto) {
            try {
                Favorite created = service.add(dto);
                return ResponseEntity.ok(created);
            } catch (RuntimeException ex) {
                return ResponseEntity.badRequest().body(ex.getMessage());
            }
        }

        // Cập nhật favorite
        @PutMapping("/{id}")
        public ResponseEntity<?> updateFavorite(@PathVariable Long id, @RequestBody FavoriteDTO dto) {
            try {
                Favorite updated = service.update(id, dto);
                if (updated != null) {
                    return ResponseEntity.ok(updated);
                } else {
                    return ResponseEntity.notFound().build();
                }
            } catch (RuntimeException ex) {
                return ResponseEntity.badRequest().body(ex.getMessage());
            }
        }

        // Xoá favorite
        @DeleteMapping("/{id}")
        public ResponseEntity<String> deleteFavorite(@PathVariable Long id) {
            boolean deleted = service.delete(id);
            if (deleted) {
                return ResponseEntity.ok("Xoá thành công");
            }
            return ResponseEntity.status(404).body("Không tìm thấy ID để xoá");
        }

        // Lấy danh sách favorite theo User ID
        @GetMapping("/user/{userId}")
        public List<FavoriteDTO> getFavoritesByUser(@PathVariable Long userId) {
            return service.getAll().stream()
                    .filter(fav -> fav.getUserId().equals(userId))
                    .collect(Collectors.toList());
        }
    }

