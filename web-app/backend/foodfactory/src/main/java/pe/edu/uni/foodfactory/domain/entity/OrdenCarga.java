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



    /*
    id_orden_carga SERIAL PRIMARY KEY,
    id_prog_desp INT NOT NULL,
    codigo CHAR(8) NOT NULL UNIQUE,
    fecha_salida TIMESTAMP,
    estado VARCHAR(15)
     */
}
