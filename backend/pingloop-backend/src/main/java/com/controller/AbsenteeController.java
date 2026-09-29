package com.pingloop.backend.controller;

import com.pingloop.backend.model.Attendance;
import com.pingloop.backend.repository.AbsenteeRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/absentees")
public class AbsenteeController {

    private final AbsenteeRepository absenteeRepository;

    public AbsenteeController(AbsenteeRepository absenteeRepository) {
        this.absenteeRepository = absenteeRepository;
    }

    @GetMapping
    public List<Attendance> getAbsentees(
            @RequestParam String date) {

        LocalDate attendanceDate = LocalDate.parse(date);

        return absenteeRepository.findByDateAndStatus(
                attendanceDate,
                "ABSENT"
        );
    }
}