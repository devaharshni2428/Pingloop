package com.pingloop.backend.controller;

import com.pingloop.backend.model.User;
import com.pingloop.backend.repository.UserRepository;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserRepository userRepository;

    public AuthController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody Map<String, String> loginData) {

        String email = loginData.get("email");
        String password = loginData.get("password");

        Optional<User> userOptional = userRepository.findByEmail(email);

        Map<String, Object> response = new HashMap<>();

        if (userOptional.isPresent()) {

            User user = userOptional.get();

            if (user.getPassword().equals(password)) {

                response.put("success", true);
                response.put("message", "Login successful");
                response.put("role", user.getRole());
                response.put("name", user.getName());
                response.put("email", user.getEmail());

                return response;
            }
        }

        response.put("success", false);
        response.put("message", "Invalid email or password");

        return response;
    }
}
