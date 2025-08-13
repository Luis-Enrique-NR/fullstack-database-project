package pe.edu.uni.foodfactory.domain.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción personalizada para manejar errores causados por solicitudes inválidas del cliente.
 *
 * Esto aplica cuando el cliente envía datos que no tienen sentido según la lógica del negocio,
 * como por ejemplo un id inexistente.
 *
 * @see HttpStatus#BAD_REQUEST
 */

public class BadRequestException extends BusinessException {

  public BadRequestException(String message) {
    super(message);
  }

  public HttpStatus getHttpStatus() {
    return HttpStatus.BAD_REQUEST;
  }
}
