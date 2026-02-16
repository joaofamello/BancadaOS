package br.com.bancada_os.api.dto;

import br.com.bancada_os.api.enums.CargoUsuario;
import br.com.bancada_os.api.model.Usuario;

public record UsuarioResponseDTO(
        Long idUsuario,
        String nome,
        String email,
        CargoUsuario cargo,
        Boolean ativo

) {
    public UsuarioResponseDTO(Usuario usuario) {
        this(
            usuario.getIdUsuario(),
            usuario.getNome(),
            usuario.getEmail(),
            usuario.getCargo(),
            usuario.getAtivo()
        );
    }
}
