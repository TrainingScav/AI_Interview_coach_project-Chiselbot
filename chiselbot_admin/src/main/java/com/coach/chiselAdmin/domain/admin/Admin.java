package com.coach.chiselAdmin.admin;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.sql.Timestamp;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Admin {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String adminName;
    private String email;
    private String password;
    // private String imagePath;
    @CreationTimestamp
    @Column(nullable = false,updatable = false)
    private Timestamp createdAt;

}
