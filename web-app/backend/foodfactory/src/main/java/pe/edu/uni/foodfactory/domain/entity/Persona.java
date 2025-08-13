package pe.edu.uni.foodfactory.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "personas")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Persona {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    //@SequenceGenerator(name = "persona_id_seq", sequenceName = "personas_id_persona_seq", allocationSize = 10)
    // Necesita mayor configuración para GenerationType.SEQUENCE
    @Column(name = "id_persona")
    private Long id;

    @Column(length = 8, nullable = false, unique = true)
    private String dni;

    @Column(length = 50, nullable = false)
    private String nombre;

    @Column(name = "ap_paterno", length = 50, nullable = false)
    private String apellidoPaterno;

    @Column(name = "ap_materno", length = 50, nullable = false)
    private String apellidoMaterno;

    @Column(length = 100)
    private String direccion;

    @ManyToOne
    @JoinColumn(name = "ubigeo_direccion", referencedColumnName = "id_ubigeo")
    private Ubigeo ubigeo;

    @Column(name = "fecha_nac")
    private LocalDate fechaNacimiento;

    public String getNombreCompleto() {
        return nombre + " " + apellidoPaterno + " " + apellidoMaterno;
    }

    /*
    id_persona SERIAL PRIMARY KEY,
    dni CHAR(8) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    ubigeo_direccion CHAR(6),
    fecha_nac DATE,
    FOREIGN KEY (ubigeo_direccion) REFERENCES Ubigeos(id_ubigeo)
     */
}
