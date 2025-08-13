package pe.edu.uni.foodfactory.infrastructure.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.edu.uni.foodfactory.domain.entity.Persona;

import java.util.Optional;

@Repository
public interface PersonaRepository extends JpaRepository<Persona, Long> {
    Boolean existsByDni(String dni);
    Optional<Persona> findByDni(String dni);
}
