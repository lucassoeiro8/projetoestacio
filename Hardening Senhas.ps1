# Define a variável para o caminho do arquivo de configuração temporário
$cfgPath = "C:\secpol.cfg"

# Função para aplicar as configurações de segurança
function Apply-SecurityPolicy {
    param (
        [string]$search,
        [string]$replace,
        [string]$description
    )

    # Exporta a configuração atual
    secedit /export /cfg $cfgPath

    # Substitui o valor desejado na configuração
    (GC $cfgPath) -Replace $search, $replace | Out-File $cfgPath

    # Aplica a nova configuração
    secedit /configure /db c:\windows\security\local.sdb /cfg $cfgPath /areas SECURITYPOLICY

    # Mensagem de status
    Write-Host "${description}: Alterado de '$search' para '$replace'."
}

# Ativar complexidade de senha
Apply-SecurityPolicy "PasswordComplexity = 0" "PasswordComplexity = 1" "Complexidade de Senha Ativada"

# Definir a expiração da senha (90 dias)
Apply-SecurityPolicy "MaxPasswordAge = 42" "MaxPasswordAge = 90" "Expiração de Senha Definida para 90 Dias"

# Definir o histórico de senhas (5 senhas anteriores)
Apply-SecurityPolicy "PasswordHistorySize = 0" "PasswordHistorySize = 5" "Histórico de Senhas Definido para 5"

# Configurar bloqueio de conta (5 tentativas)
Apply-SecurityPolicy "LockoutBadCount = 0" "LockoutBadCount = 5" "Bloqueio de Conta Definido para 5 Tentativas"

# Definir comprimento mínimo da senha (12 caracteres)
Apply-SecurityPolicy "MinPasswordLength = 0" "MinPasswordLength = 12" "Comprimento Mínimo da Senha Definido para 12 Caracteres"

# Remove o arquivo de configuração temporário
Remove-Item $cfgPath -Force

# Mensagem de conclusão
Write-Host "Todas as políticas de segurança de senha foram aplicadas com sucesso!"
