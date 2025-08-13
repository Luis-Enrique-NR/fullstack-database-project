package pe.edu.uni.foodfactory.application.mapper.persona.base;

import pe.edu.uni.foodfactory.domain.entity.Persona;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.presentation.dto.PersonaInformacionResponseDTO;

import java.util.Optional;

public class PersonaBaseMapper {

    public static PersonaInformacionResponseDTO toDTOFromEntity(Persona persona, Ubigeo ubigeo) {
        return PersonaInformacionResponseDTO.builder()
                .dni(persona.getDni())
                .nombreCompleto(persona.getNombreCompleto())
                .direccion(persona.getDireccion())
                .zonaResidencia(
                        Optional.ofNullable(ubigeo) // Reemplaza lógica condicional para casos donde es nulo
                                .map(Ubigeo::getZonaUbigeo)
                                .orElse(null) // Puede tomar un valor como "Desconocida"
                )
                .fechaNacimiento(persona.getFechaNacimiento())
                .build();
    }

}
