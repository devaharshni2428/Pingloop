package com.pingloop.backend.repository;

import com.pingloop.backend.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StudentRepository extends JpaRepository<Student, Integer> {

    List<Student> findByDepartmentAndYearAndSection(
            String department,
            Integer year,
            String section
    );
}