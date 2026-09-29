package com.pingloop.backend.controller;

import com.pingloop.backend.model.Attendance;
import com.pingloop.backend.repository.AttendanceRepository;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    private final AttendanceRepository attendanceRepository;

    public AttendanceController(AttendanceRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    @PostMapping
    public Attendance saveAttendance(@RequestBody Attendance attendance) {
        return attendanceRepository.save(attendance);
    }
}