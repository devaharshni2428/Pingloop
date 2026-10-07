package com.pingloop.backend.repository;

import com.pingloop.backend.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface AttendanceRepository extends JpaRepository<Attendance, Integer> {

    @Query("SELECT a FROM Attendance a WHERE a.student_id = :studentId AND a.date = :date")
    List<Attendance> findByStudentIdAndDate(
            @Param("studentId") Integer studentId,
            @Param("date") LocalDate date
    );
}