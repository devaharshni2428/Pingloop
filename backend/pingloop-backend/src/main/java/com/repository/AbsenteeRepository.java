package com.pingloop.backend.repository;

import com.pingloop.backend.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface AbsenteeRepository extends JpaRepository<Attendance, Integer> {

    List<Attendance> findByDateAndStatus(
            LocalDate date,
            String status
    );
}