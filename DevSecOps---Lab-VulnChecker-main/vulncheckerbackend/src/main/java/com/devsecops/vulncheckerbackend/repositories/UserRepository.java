package com.devsecops.vulncheckerbackend.repositories;

import com.devsecops.vulncheckerbackend.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findByEmail(String email);

    List<UserEntity> findByActiveFalse(); // Método para obtener usuarios inactivos
    List<UserEntity> findByRole(String role); // Método para obtener usuarios por rol
    List<UserEntity> findByActive(boolean active); // Método para obtener usuarios por estado de actividad
    List<UserEntity> findByRoleAndActive(String role, boolean active); // Método para obtener usuarios por rol y estado de actividad
}