package pe.edu.uni.foodfactory.application.mapper.persona.create;

import pe.edu.uni.foodfactory.application.dto.RegistrarPersonaCommand;
import pe.edu.uni.foodfactory.domain.entity.Persona;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.presentation.dto.RegistrarPersonaRequestDTO;

public class PersonaCreateMapper {

    public static RegistrarPersonaCommand toCommandFromRegisterDTO(RegistrarPersonaRequestDTO dto) {
        return RegistrarPersonaCommand.builder()
                .dni(dto.getDni())
                .nombre(dto.getNombre())
                .apellidoPaterno(dto.getApellidoPaterno())
                .apellidoMaterno(dto.getApellidoMaterno())
                .direccion(dto.getDireccion())
                .codigoUbigeo(dto.getCodigoUbigeo())
                .fechaNacimiento(dto.getFechaNacimiento())
                .build();
    }

    public static Persona toEntityFromRegisterCommand(RegistrarPersonaCommand dto, Ubigeo ubigeo) {
        return Persona.builder()
                .dni(dto.getDni())
                .nombre(dto.getNombre())
                .apellidoPaterno(dto.getApellidoPaterno())
                .apellidoMaterno(dto.getApellidoMaterno())
                .fechaNacimiento(dto.getFechaNacimiento())
                .direccion(dto.getDireccion())
                .ubigeo(ubigeo)
                .build();
    }
}
