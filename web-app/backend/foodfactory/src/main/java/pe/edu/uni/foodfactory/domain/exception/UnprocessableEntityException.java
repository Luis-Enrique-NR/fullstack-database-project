package pe.edu.uni.foodfactory.domain.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción personalizada para manejar errores de datos que no pueden ser procesados,
 * aunque la solicitud sea sintácticamente correcta.
 * Este código se usa cuando el servidor no puede procesar la entidad enviada por el cliente
 * debido a errores semánticos o de validación.
 *
 * @see HttpStatus#UNPROCESSABLE_ENTITY
 */

public class UnprocessableEntityException extends BusinessException {
    public UnprocessableEntityException(String message) {
        super(message);
    }

    public HttpStatus getHttpStatus() {
        return HttpStatus.UNPROCESSABLE_ENTITY;
    }
}
