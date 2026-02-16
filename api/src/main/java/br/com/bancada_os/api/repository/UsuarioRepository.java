package br.com.bancada_os.api.repository;

import br.com.bancada_os.api.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.core.userdetails.UserDetails;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    UserDetails findByEmail(String email);
    boolean existsByEmail(String email);
}
