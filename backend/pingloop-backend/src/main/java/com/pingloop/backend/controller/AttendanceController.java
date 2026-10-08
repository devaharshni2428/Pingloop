package com.pingloop.backend.controller;

import com.pingloop.backend.model.Attendance;
import com.pingloop.backend.repository.AttendanceRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    private final AttendanceRepository attendanceRepository;

    public AttendanceController(AttendanceRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    @PostMapping
    public Attendance saveAttendance(@RequestBody Attendance attendance) {
        List<Attendance> existingList = attendanceRepository
                .findByStudentIdAndDate(attendance.getStudent_id(), attendance.getDate());

        if (existingList != null && !existingList.isEmpty()) {
            Attendance existing = existingList.get(0);
            existing.setStatus(attendance.getStatus());
            existing.setStaff_id(attendance.getStaff_id());

            // Remove any redundant duplicates from earlier runs
            for (int i = 1; i < existingList.size(); i++) {
                attendanceRepository.delete(existingList.get(i));
            }

            return attendanceRepository.save(existing);
        }

        return attendanceRepository.save(attendance);
    }
}