package pe.edu.uni.foodfactory.domain.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción personalizada para manejar la situación cuando un recurso no es encontrado
 * en el servidor.
 *
 * Este código es útil cuando el cliente intenta acceder a un recurso que no existe
 * en el sistema (por ejemplo, una entidad con un id inexistente).
 *
 * @see HttpStatus#NOT_FOUND
 */

public class NotFoundException extends BusinessException {
    public NotFoundException(String message) {
        super(message);
    }

    public HttpStatus getHttpStatus() {
        return HttpStatus.NOT_FOUND;
    }
}
