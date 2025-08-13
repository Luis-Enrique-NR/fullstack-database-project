package pe.edu.uni.foodfactory.application.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.uni.foodfactory.domain.entity.Ubigeo;
import pe.edu.uni.foodfactory.domain.exception.InternalServerErrorException;
import pe.edu.uni.foodfactory.infrastructure.repository.UbigeoRepository;

@Service
@Transactional
@RequiredArgsConstructor
public class UbigeoService {

    private final UbigeoRepository ubigeoRepository;

    public Ubigeo getUbigeo(String id) {
        return ubigeoRepository.findById(id).
                orElseThrow(() -> new InternalServerErrorException("No se encontró el ubigeo con el id: " + id) );
    }

    //TODO
}
