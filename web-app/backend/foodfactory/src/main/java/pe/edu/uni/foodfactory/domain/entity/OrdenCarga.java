package pe.edu.uni.foodfactory.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ordenescarga")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCarga {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    @Column(name = "id_orden_carga")
    private Long id;

}
