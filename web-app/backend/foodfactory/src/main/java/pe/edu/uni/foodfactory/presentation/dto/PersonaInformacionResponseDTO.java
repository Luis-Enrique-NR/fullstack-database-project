package pe.edu.uni.foodfactory.presentation.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
public class PersonaInformacionResponseDTO {

    private String dni;
    private String nombreCompleto;
    private String direccion;
    private String zonaResidencia;
    private LocalDate fechaNacimiento;

}
