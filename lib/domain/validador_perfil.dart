class DadosPerfil {
    final String nome;
    final String? perfil;
    final String codigo;
    final String senha;
    final String confirmarSenha;


    DadosPerfil({
        required this.nome,
        required this.perfil,
        required this.codigo,
        required this.senha,
        required this.confirmarSenha,
    });
}

abstract class ValidadorPerfil {
   ValidadorPerfil? _proximo;

   ValidadorPerfil definirProximo(ValidadorPerfil proximo){
       _proximo = proximo;
       return proximo;
   }
   String? validar(DadosPerfil dados){
       final erro = verificar(dados);
       if (erro != null) return erro;
       return _proximo?.validar(dados);
   }
    String? verificar(DadosPerfil dados);
}

class ValidadorNome extends ValidadorPerfil {
    @override
    String? verificar(DadosPerfil dados){
        if(dados.nome.trim().isEmpty){
            return 'Informe seu nome';
        }
        return null;
    }
}

class ValidadorAvatar extends ValidadorPerfil{
    @override
    String? verificar(DadosPerfil dados){
        if(dados.perfil == null){
            return 'Escolha um avatar!';
        }
        return null;
    }
}

class ValidadorCodigo extends ValidadorPerfil{
    @override
    String? verificar(DadosPerfil dados){
        if(dados.codigo.trim().isEmpty){
            return 'Informe ou gere o código da família!';
        }
        return null;
    }
}

class ValidadorSenha extends ValidadorPerfil {
    @override
    String? verificar(DadosPerfil dados){
        if(dados.senha.length < 6){
            return 'A senha deve ter pelo menos 8 caracteres';
        }
        if(!RegExp(r'[A-Za-z]').hasMatch(dados.senha)){
            return 'A senha deve ter letras';
        }
        if(!RegExp(r'[0-9]').hasMatch(dados.senha)){
            return 'A senha deve ter números';
        }
        return null;
    }
}

class ValidadorConfirmarSenha extends ValidadorPerfil {
    @override
    String? verificar(DadosPerfil dados){
        if(dados.senha != dados.confirmarSenha){
            return 'As senhas não conferem';
        }
        return null;
    }
}

ValidadorPerfil montarFila(){
    final primeiro = ValidadorNome();

    primeiro
        .definirProximo(ValidadorAvatar())
        .definirProximo(ValidadorCodigo())
        .definirProximo(ValidadorSenha())
        .definirProximo(ValidadorConfirmarSenha());

    return primeiro;

}
