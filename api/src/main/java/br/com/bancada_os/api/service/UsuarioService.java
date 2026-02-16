package br.com.bancada_os.api.service;

import br.com.bancada_os.api.dto.UsuarioRequestDTO;
import br.com.bancada_os.api.dto.UsuarioResponseDTO;
import br.com.bancada_os.api.exception.EmailJaCadastradoException;
import br.com.bancada_os.api.model.Usuario;
import br.com.bancada_os.api.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    private final UsuarioRepository repository;
    private final PasswordEncoder encoder;

    public UsuarioService(UsuarioRepository repository, PasswordEncoder encoder) {
        this.repository = repository;
        this.encoder = encoder;
    }

    @Transactional
    public UsuarioResponseDTO cadastrar(UsuarioRequestDTO dados) {
        if(repository.existsByEmail(dados.email())) {
            throw new EmailJaCadastradoException("Email já cadastrado no sistema.");
        }

        var usuario = new Usuario(
                dados.nome(),
                dados.email(),
                encoder.encode(dados.senha()),
                dados.cargo()
        );

        repository.save(usuario);
        return new UsuarioResponseDTO(usuario);
    }

    public List<UsuarioResponseDTO> listar() {
        return repository.findAll().stream().map(UsuarioResponseDTO::new).toList();
    }
}
