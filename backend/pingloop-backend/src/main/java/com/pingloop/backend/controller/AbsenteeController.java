package com.pingloop.backend.controller;

import com.pingloop.backend.model.Attendance;
import com.pingloop.backend.model.Student;
import com.pingloop.backend.repository.AbsenteeRepository;
import com.pingloop.backend.repository.StudentRepository;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/absentees")
public class AbsenteeController {

    private final AbsenteeRepository absenteeRepository;
    private final StudentRepository studentRepository;

    public AbsenteeController(
            AbsenteeRepository absenteeRepository,
            StudentRepository studentRepository) {

        this.absenteeRepository = absenteeRepository;
        this.studentRepository = studentRepository;
    }

    @GetMapping
    public List<Map<String, Object>> getAbsentees(
            @RequestParam LocalDate date) {

        List<Attendance> attendanceList =
                absenteeRepository.findByDateAndStatus(date, "ABSENT");

        List<Map<String, Object>> result = new ArrayList<>();
        Set<Integer> seenStudentIds = new HashSet<>();

        for (Attendance attendance : attendanceList) {

            if (!seenStudentIds.add(attendance.getStudent_id())) {
                continue;
            }

            Optional<Student> studentOptional =
                    studentRepository.findById(attendance.getStudent_id());

            if (studentOptional.isPresent()) {

                Student student = studentOptional.get();

                Map<String, Object> absentee = new HashMap<>();

                absentee.put("student_id", student.getStudent_id());
                absentee.put("register_number",
                        student.getRegister_number());
                absentee.put("student_name",
                        student.getStudent_name());
                absentee.put("department",
                        student.getDepartment());
                absentee.put("year",
                        student.getYear());
                absentee.put("section",
                        student.getSection());
                absentee.put("date",
                        attendance.getDate());

                result.add(absentee);
            }
        }

        return result;
    }
}