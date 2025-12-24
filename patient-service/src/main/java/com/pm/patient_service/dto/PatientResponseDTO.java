package com.pm.patient_service.dto;

import org.springframework.cglib.core.Local;

import java.time.LocalDate;

public class PatientResponseDTO {

    // This handles requests and responsse from the controller
    //and for what TO show and give back to the frontEnd
    private String id;
    private String name;
    private String email;
    private String address;
    // use ObjectMapper to convert it into string for easy json management
    private LocalDate dateOfBirth;
    //registration date not added to not show it on frontend

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
}
