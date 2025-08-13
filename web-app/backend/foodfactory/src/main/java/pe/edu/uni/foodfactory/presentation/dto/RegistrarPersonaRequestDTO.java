package pe.edu.uni.foodfactory.presentation.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
public class RegistrarPersonaRequestDTO {

    @NotBlank
    private String dni;

    @NotBlank
    private String nombre;

    @NotBlank
    private String apellidoPaterno;

    @NotBlank
    private String apellidoMaterno;

    private String direccion;
    private LocalDate fechaNacimiento;
    private String codigoUbigeo;


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
