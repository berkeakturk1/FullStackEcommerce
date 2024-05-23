package com.example.ecommercebackend.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;


    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginRequest, HttpServletRequest request) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        boolean isValid = userService.validateUser(username, password);

        if (isValid) {
            User user = userRepository.findByUsername(username);
            if (user != null) {
                userService.logUserLogin(username); // Ensure this calls the procedure
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                return ResponseEntity.ok().body("Login successful");
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not found");
            }
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest) {
        boolean isExisting = userService.existingUser(registerRequest);

        if (isExisting)
            return new ResponseEntity<>("Username or email already exists", HttpStatus.BAD_REQUEST);
        else {
            userService.save(registerRequest);
            return new ResponseEntity<>("User registered successfully", HttpStatus.OK);
        }
    }


    @PostMapping("/userid")
    public ResponseEntity<?> getUserId(@RequestBody Map<String, String> request) {
        try {
            String username = request.get("username");
            User user = userRepository.findByUsername(username);
            return ResponseEntity.ok(user.getUserid());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error retrieving user ID");
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return ResponseEntity.ok().body("Logout successful");
    }

    @GetMapping("/status")
    public ResponseEntity<?> status(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            return ResponseEntity.ok().body("User is logged in");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User is not logged in");
        }
    }
}
