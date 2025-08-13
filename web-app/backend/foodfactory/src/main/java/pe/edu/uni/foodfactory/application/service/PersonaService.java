package pe.edu.uni.foodfactory.application.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.uni.foodfactory.application.dto.RegistrarPersonaCommand;
import pe.edu.uni.foodfactory.application.mapper.persona.PersonaMapper;
import pe.edu.uni.foodfactory.domain.entity.Persona;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.domain.exception.ConflictException;
import pe.edu.uni.foodfactory.domain.exception.NotFoundException;
import pe.edu.uni.foodfactory.infrastructure.repository.PersonaRepository;
import pe.edu.uni.foodfactory.infrastructure.repository.UbigeoRepository;
import pe.edu.uni.foodfactory.presentation.dto.ActualizarPersonaRequestDTO;
import pe.edu.uni.foodfactory.presentation.dto.PersonaInformacionResponseDTO;
import pe.edu.uni.foodfactory.presentation.dto.RegistrarPersonaRequestDTO;

import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class PersonaService {

    private final PersonaRepository personaRepository;
    private final UbigeoRepository ubigeoRepository;
    private final UbigeoService ubigeoService;

    // Obtener información completa de una persona

    public PersonaInformacionResponseDTO getPersonaInformacion(String dni) {
        Persona persona = personaRepository.findByDni(dni).
                orElseThrow(() -> new NotFoundException("No se encontró persona con dni: " + dni));

        Ubigeo ubigeo = persona.getUbigeo();

        return PersonaMapper.toDTOFromEntity(persona, ubigeo);
    }

    // Registrar una nueva persona

    public PersonaInformacionResponseDTO registerPersona(RegistrarPersonaRequestDTO dtoPresentation) {

        if (personaRepository.existsByDni(dtoPresentation.getDni())) {
            throw new ConflictException("Ya existe una persona con el dni " + dtoPresentation.getDni());
        } else {
            RegistrarPersonaCommand dtoApplication = PersonaMapper.toCommandFromRegisterDTO(dtoPresentation);
            Ubigeo ubigeo = Optional.ofNullable(dtoPresentation.getCodigoUbigeo())
                    .map(codigo -> ubigeoRepository.findById(codigo)
                            .orElseThrow(() -> new NotFoundException("No se encontró ubigeo con código " + codigo)))
                    .orElse(null);

            Persona persona = PersonaMapper.toEntityFromRegisterCommand(dtoApplication, ubigeo);

            personaRepository.save(persona);

            return getPersonaInformacion(dtoApplication.getDni());
        }

        /*
        RegistrarPersonaCommand dtoApplication = DTOToCommand(dtoPresentation);

        /*
        // Forma tradicional con condicionales if - else

        Ubigeo ubigeo;
        if (dtoPresentation.getCodigoUbigeo() == null) {
            ubigeo = null;
        } else {
            ubigeo = ubigeoRepository.findById(dtoApplication.getCodigoUbigeo())
                    .orElseThrow(() -> new NotFoundException("No se encontró ubigeo con código " + dtoApplication.getCodigoUbigeo()));
        }
        //

        // Uso de optional
        Ubigeo ubigeo = Optional.ofNullable(dtoPresentation.getCodigoUbigeo())
                .map(codigo -> ubigeoRepository.findById(codigo)
                    .orElseThrow(() -> new NotFoundException("No se encontró ubigeo con código " + codigo)))
                .orElse(null);

        Persona persona = CommandToEntity(dtoApplication, ubigeo);

        personaRepository.save(persona);

        return getPersonaInformacion(dtoApplication.getDni());
        */
    }

    public PersonaInformacionResponseDTO actualizarDatosPersona(ActualizarPersonaRequestDTO dtoPresentation) {

        Persona persona = personaRepository.findByDni(dtoPresentation.getDni())
                .orElseThrow(() -> new NotFoundException("No se encontró persona con dni " + dtoPresentation.getDni()));

        Ubigeo ubigeo = Optional.ofNullable(dtoPresentation.getCodigoUbigeo())
                .map(codigo -> ubigeoRepository.findById(codigo)
                        .orElseThrow(() -> new NotFoundException("No se encontró ubigeo con código " + codigo)))
                .orElse(null);

        PersonaMapper.updateEntityFromDTO(dtoPresentation, ubigeo, persona);

        personaRepository.save(persona);

        return getPersonaInformacion(dtoPresentation.getDni());
    }

}
