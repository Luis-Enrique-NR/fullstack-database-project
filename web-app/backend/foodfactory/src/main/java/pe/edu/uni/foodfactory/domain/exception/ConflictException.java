package pe.edu.uni.foodfactory.domain.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción personalizada para manejar situaciones de conflicto con el estado actual
 * del servidor. Por ejemplo, cuando se intenta crear un recurso duplicado.
 *
 * @see HttpStatus#CONFLICT
 */

public class ConflictException extends BusinessException {
    public ConflictException(String message) {
        super(message);
    }

    public HttpStatus getHttpStatus() {
        return HttpStatus.CONFLICT;
    }
}
