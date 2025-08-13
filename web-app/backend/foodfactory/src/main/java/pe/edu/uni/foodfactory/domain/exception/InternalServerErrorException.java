package pe.edu.uni.foodfactory.domain.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción personalizada para manejar errores internos del servidor.
 * Este código se utiliza cuando hay un error inesperado que impide que el servidor
 * pueda procesar la solicitud del cliente.
 *
 * @see HttpStatus#INTERNAL_SERVER_ERROR
 */

public class InternalServerErrorException extends BusinessException {
  public InternalServerErrorException(String message) {
    super(message);
  }

  public HttpStatus getHttpStatus() {
    return HttpStatus.INTERNAL_SERVER_ERROR;
  }
}
