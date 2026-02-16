package br.com.bancada_os.api.enums;

public enum CargoUsuario {
    ADMIN("ADMIN"),
    GERENTE("GERENTE"),
    TECNICO("TECNICO"),
    ATENDENTE("ATENDENTE");

    private String cargo;

    CargoUsuario(String cargo) {
        this.cargo = cargo;
    }

    public String getCargo(){
        return cargo;
    }
}
