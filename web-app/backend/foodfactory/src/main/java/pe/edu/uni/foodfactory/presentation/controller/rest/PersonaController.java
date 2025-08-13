package pe.edu.uni.foodfactory.presentation.controller.rest;

import lombok.RequiredArgsConstructor;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import pe.edu.uni.foodfactory.application.service.PersonaService;
import pe.edu.uni.foodfactory.presentation.dto.ActualizarPersonaRequestDTO;
import pe.edu.uni.foodfactory.presentation.dto.PersonaInformacionResponseDTO;
import pe.edu.uni.foodfactory.presentation.dto.RegistrarPersonaRequestDTO;
import pe.edu.uni.foodfactory.shared.util.ApiResponse;

@RestController
@RequestMapping("/api/personas")
@RequiredArgsConstructor
public class PersonaController {

    private final PersonaService personaService;

    @GetMapping("/buscar")
    public ResponseEntity<ApiResponse<PersonaInformacionResponseDTO>> getInformacion(
            @RequestParam String dni
    ) {
        PersonaInformacionResponseDTO personaInformacionDTO = personaService.getPersonaInformacion(dni);
        return ResponseEntity.ok(new ApiResponse<>("Se encontró una persona exitosamente", "200", personaInformacionDTO));

        /*
        try {
            ResponsePersonaInformacionDTO personaInformacionDTO = personaService.getPersonaInformacion(dni);
            return ResponseEntity.ok(new ApiResponse<>("Se encontró una persona exitosamente", personaInformacionDTO));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).
                    body(new ApiResponse<>("No se encontró persona con dni " + dni, null));
            //return ResponseEntity.ok(new ApiResponse<>(e.getMessage(), null));
        }
         */
    }

    @PostMapping("/registrar")
    public ResponseEntity<ApiResponse<PersonaInformacionResponseDTO>> postPersona(
            @RequestBody @Validated RegistrarPersonaRequestDTO dto
    ) {
        PersonaInformacionResponseDTO personaInformacionResponseDTO = personaService.registerPersona(dto);
        return ResponseEntity.ok(new ApiResponse<>("Se registró exitosamente", "200", personaInformacionResponseDTO));
    }

    @PatchMapping("/actualizar")
    public ResponseEntity<ApiResponse<PersonaInformacionResponseDTO>> updateInformationPersona(
            @RequestBody @Validated ActualizarPersonaRequestDTO dto
    ) {
        PersonaInformacionResponseDTO personaInformacionResponseDTO = personaService.actualizarDatosPersona(dto);
        return ResponseEntity.ok(new ApiResponse<>("Se registraron los datos actualizados", "200", personaInformacionResponseDTO));
    }
}
