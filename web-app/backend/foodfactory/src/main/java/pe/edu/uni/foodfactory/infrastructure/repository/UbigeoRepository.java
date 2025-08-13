package pe.edu.uni.foodfactory.infrastructure.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;

@Repository
public interface UbigeoRepository extends JpaRepository<Ubigeo, String> {

}
