
package com.pingloop.backend.controller;

import com.pingloop.backend.model.Attendance;
import com.pingloop.backend.repository.AttendanceRepository;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/attendance")
public class AttendanceController {

    private final AttendanceRepository attendanceRepository;

    public AttendanceController(
            AttendanceRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    // Save or update attendance
    @PostMapping
    public Attendance saveAttendance(
            @RequestBody Attendance attendance) {

        List<Attendance> existingList =
                attendanceRepository.findByStudentIdAndDate(
                        attendance.getStudent_id(),
                        attendance.getDate());

        if (existingList != null && !existingList.isEmpty()) {
            Attendance existing = existingList.get(0);

            existing.setStatus(attendance.getStatus());
            existing.setStaff_id(attendance.getStaff_id());

            for (int i = 1; i < existingList.size(); i++) {
                attendanceRepository.delete(existingList.get(i));
            }

            return attendanceRepository.save(existing);
        }

        return attendanceRepository.save(attendance);
    }

    // Retrieve attendance records for a selected date
    @GetMapping
    public List<Attendance> getAttendance(
            @RequestParam String date) {

        LocalDate selectedDate = LocalDate.parse(date);

        return attendanceRepository.findByDate(selectedDate);
    }
}
