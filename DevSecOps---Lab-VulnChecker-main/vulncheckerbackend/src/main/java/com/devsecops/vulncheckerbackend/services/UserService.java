package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.UserEntity;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, BCryptPasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<UserEntity> login(String email, String password) {
        return userRepository.findByEmail(email)
                .filter(user -> user.isActive()) // <--- ESTO ES VITAL
                .filter(user -> passwordEncoder.matches(password, user.getPassword()));
    }

    public void saveDirectly(UserEntity user) {
        userRepository.save(user); // Guarda sin re-encriptar la contraseña
    }
    public List<UserEntity> findByActiveFalse() {
        return userRepository.findByActiveFalse();
    }
    public Optional<UserEntity> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    
    public UserEntity save(UserEntity user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public List<UserEntity> findAll() { 
        return userRepository.findAll(); 
    }
    
    public Optional<UserEntity> findById(Long id) { 
        return userRepository.findById(id); 
    }
    
    public void deleteById(Long id) { 
        userRepository.deleteById(id); 
    }
}