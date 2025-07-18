package com.example.HotelBoking.DTO;

public class BookingContactDTO {
    private String fullName;
    private String email;
    private String phone;
    private String note;

    public BookingContactDTO() {}

    public BookingContactDTO(String email, String fullName, String phone, String note) {
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.note = note;
    }

    // Getter, Setter
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
