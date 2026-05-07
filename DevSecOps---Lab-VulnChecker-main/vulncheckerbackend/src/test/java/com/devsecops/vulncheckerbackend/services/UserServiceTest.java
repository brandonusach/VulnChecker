package com.devsecops.vulncheckerbackend.services;

import com.devsecops.vulncheckerbackend.entities.UserEntity;
import com.devsecops.vulncheckerbackend.repositories.UserRepository;
import com.devsecops.vulncheckerbackend.support.TestDataFactory;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private BCryptPasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    @Test
    void login_returnsUser_whenEmailExistsAndPasswordMatches() {
        UserEntity user = TestDataFactory.user(1L);
        user.setPassword("encoded");

        when(userRepository.findByEmail("admin.seguridad@usach.cl")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("admin123", "encoded")).thenReturn(true);

        Optional<UserEntity> result = userService.login("admin.seguridad@usach.cl", "admin123");

        assertTrue(result.isPresent());
        assertEquals("admin.seguridad@usach.cl", result.get().getEmail());
    }

    @Test
    void login_returnsEmpty_whenPasswordDoesNotMatch() {
        UserEntity user = TestDataFactory.user(1L);
        user.setPassword("encoded");

        when(userRepository.findByEmail("admin.seguridad@usach.cl")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("bad-password", "encoded")).thenReturn(false);

        Optional<UserEntity> result = userService.login("admin.seguridad@usach.cl", "bad-password");

        assertTrue(result.isEmpty());
    }

    @Test
    void login_returnsEmpty_whenUserDoesNotExist() {
        when(userRepository.findByEmail("missing@usach.cl")).thenReturn(Optional.empty());

        Optional<UserEntity> result = userService.login("missing@usach.cl", "admin123");

        assertTrue(result.isEmpty());
        verify(passwordEncoder, never()).matches(any(), any());
    }

    @Test
    void save_encodesPasswordBeforePersisting() {
        UserEntity user = TestDataFactory.user(1L);

        when(passwordEncoder.encode("admin123")).thenReturn("encoded-pass");
        when(userRepository.save(any(UserEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));

        UserEntity saved = userService.save(user);

        assertEquals("encoded-pass", saved.getPassword());
        verify(userRepository).save(user);
    }
}
