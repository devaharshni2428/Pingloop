package com.pingloop.backend.controller;

import com.pingloop.backend.model.Student;
import com.pingloop.backend.repository.StudentRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {

    private final StudentRepository studentRepository;

    public StudentController(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @GetMapping
    public List<Student> getStudents(
            @RequestParam String department,
            @RequestParam Integer year,
            @RequestParam String section) {

        return studentRepository.findByDepartmentAndYearAndSection(
                department, year, section);
    }
}