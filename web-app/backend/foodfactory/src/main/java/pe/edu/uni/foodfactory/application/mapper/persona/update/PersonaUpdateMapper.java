package pe.edu.uni.foodfactory.application.mapper.persona.update;

import pe.edu.uni.foodfactory.domain.entity.Persona;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.presentation.dto.ActualizarPersonaRequestDTO;

import java.util.Optional;

public class PersonaUpdateMapper {

    public static void updateEntityFromDTO(ActualizarPersonaRequestDTO dto, Ubigeo ubigeo, Persona persona) {
        Optional.ofNullable(dto.getNombre()).ifPresent(persona::setNombre);
        Optional.ofNullable(dto.getApellidoPaterno()).ifPresent(persona::setApellidoPaterno);
        Optional.ofNullable(dto.getApellidoMaterno()).ifPresent(persona::setApellidoMaterno);
        Optional.ofNullable(dto.getFechaNacimiento()).ifPresent(persona::setFechaNacimiento);
        Optional.ofNullable(dto.getDireccion()).ifPresent(persona::setDireccion);
        Optional.ofNullable(ubigeo).ifPresent(persona::setUbigeo);
    }
}
