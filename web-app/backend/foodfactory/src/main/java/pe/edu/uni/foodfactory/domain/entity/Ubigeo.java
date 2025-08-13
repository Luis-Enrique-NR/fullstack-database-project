package pe.edu.uni.foodfactory.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "ubigeos")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ubigeo {
    @Id
    @Column(name = "id_ubigeo", length = 6, nullable = false)
    private String id;

    @Column(length = 50, nullable = false)
    private String departamento;

    @Column(length = 50, nullable = false)
    private String provincia;

    @Column(length = 50, nullable = false)
    private String distrito;

    @OneToMany(mappedBy = "ubigeo")
    private List<Persona> personas;

    public String getZonaUbigeo() {
        return departamento + " - " + provincia + " - " + distrito;
    }
}
