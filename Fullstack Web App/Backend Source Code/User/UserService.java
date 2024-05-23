package com.example.ecommercebackend.User;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @PersistenceContext
    private EntityManager entityManager;
    public boolean validateUser(String username, String password) {
        User user = userRepository.findByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            return true;
        } else {
            return false;
        }
    }

    public boolean existingUser(RegisterRequest registerRequest) {
        Optional<User> existingUser = userRepository.findByUsernameOrEmail(registerRequest .getUsername(), registerRequest.getEmail());

        if(existingUser.isPresent())
        {
            return true;
        }

        return false;
    }

    @Transactional
    public void logUserLogin(String username) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("log_user_login");
        query.registerStoredProcedureParameter("p_username", String.class, ParameterMode.IN);
        query.setParameter("p_username", username);
        query.execute();
    }



    public void save(RegisterRequest request){
        User newUser = new User();
        newUser.setUsername(request.getUsername());
        newUser.setEmail(request.getEmail());
        newUser.setUsername(request.getUsername());
        newUser.setPassword(request.getPassword()); 
        newUser.setFname(request.getFname());
        newUser.setLname(request.getLname());
        newUser.setUserType(request.getIsSeller());
        newUser.setBdate(request.getBdate());

        userRepository.save(newUser);
    }



}
