package br.com.bancada_os.api.dto;

import br.com.bancada_os.api.enums.CargoUsuario;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UsuarioRequestDTO(
        @NotBlank(message = "O nome é obrigatório") String nome,
        @NotBlank(message = "O email é obrigatório") @Email(message = "Formato de email inválido") String email,
        @NotBlank(message = "A senha é obrigatória") String senha,
        @NotNull(message = "O cargo é obrigatório") CargoUsuario cargo
) {
}
