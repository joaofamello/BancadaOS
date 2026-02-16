package br.com.bancada_os.api.infra;

import br.com.bancada_os.api.dto.ErroResponseDTO;
import br.com.bancada_os.api.exception.EmailJaCadastradoException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EmailJaCadastradoException.class)
    public ResponseEntity<ErroResponseDTO> tratarErroEmailJaCadastrado(EmailJaCadastradoException ex) {
        ErroResponseDTO erroResponse = new ErroResponseDTO(ex.getMessage());
        return ResponseEntity.badRequest().body(erroResponse);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity tratarErro400(MethodArgumentNotValidException ex) {
        var erros = ex.getFieldErrors().stream()
                .map(erro -> erro.getField() + ": " + erro.getDefaultMessage())
                .toList();
        return ResponseEntity.badRequest().body(erros);
    }
}
