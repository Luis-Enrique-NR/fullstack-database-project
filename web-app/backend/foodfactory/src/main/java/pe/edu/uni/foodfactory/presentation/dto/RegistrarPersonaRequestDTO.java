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
}
