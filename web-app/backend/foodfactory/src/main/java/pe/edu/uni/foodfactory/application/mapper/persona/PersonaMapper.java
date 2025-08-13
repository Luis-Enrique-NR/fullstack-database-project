package pe.edu.uni.foodfactory.application.mapper.persona;

import pe.edu.uni.foodfactory.application.dto.RegistrarPersonaCommand;
import pe.edu.uni.foodfactory.application.mapper.persona.base.PersonaBaseMapper;
import pe.edu.uni.foodfactory.application.mapper.persona.create.PersonaCreateMapper;
import pe.edu.uni.foodfactory.application.mapper.persona.update.PersonaUpdateMapper;
import pe.edu.uni.foodfactory.domain.entity.Persona;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.presentation.dto.ActualizarPersonaRequestDTO;
import pe.edu.uni.foodfactory.presentation.dto.PersonaInformacionResponseDTO;
import pe.edu.uni.foodfactory.presentation.dto.RegistrarPersonaRequestDTO;

import java.util.Optional;

public class PersonaMapper {

    public static PersonaInformacionResponseDTO toDTOFromEntity(Persona persona, Ubigeo ubigeo) {
        return PersonaBaseMapper.toDTOFromEntity(persona, ubigeo);
    }

    public static RegistrarPersonaCommand toCommandFromRegisterDTO(RegistrarPersonaRequestDTO dto) {
        return PersonaCreateMapper.toCommandFromRegisterDTO(dto);
    }

    public static Persona toEntityFromRegisterCommand(RegistrarPersonaCommand dto, Ubigeo ubigeo) {
        return PersonaCreateMapper.toEntityFromRegisterCommand(dto, ubigeo);
    }

    public static void updateEntityFromDTO(ActualizarPersonaRequestDTO dto, Ubigeo ubigeo, Persona persona) {
        PersonaUpdateMapper.updateEntityFromDTO(dto, ubigeo, persona);
    }
}
