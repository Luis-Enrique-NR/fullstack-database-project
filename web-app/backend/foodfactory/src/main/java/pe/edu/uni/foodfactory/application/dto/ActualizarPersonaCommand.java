package pe.edu.uni.foodfactory.application.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
public class ActualizarPersonaCommand {

    private String dni;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String direccion;
    private LocalDate fechaNacimiento;
    private String codigoUbigeo;
}
