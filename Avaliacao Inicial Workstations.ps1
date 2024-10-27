# Define o diretório para salvar o relatório de avaliação
$reportPath = "C:\Relatorio_Avaliacao\"
if (!(Test-Path -Path $reportPath)) {
    New-Item -ItemType Directory -Path $reportPath
}

# 1. Listar serviços em execução
$servicos = Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name, DisplayName, Status
$servicos | Out-File -FilePath "${reportPath}Servicos_Ativos.txt"

# 2. Listar aplicativos instalados
$appList = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*, `
                     HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
           Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
$appList | Out-File -FilePath "${reportPath}Aplicativos_Instalados.txt"

# 3. Listar permissões de pastas principais
# Define as pastas a serem analisadas (adicionar ou remover conforme necessário)
$pastasPrincipais = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users")

# Coleta permissões de cada pasta e salva no relatório
foreach ($pasta in $pastasPrincipais) {
    $acl = Get-Acl -Path $pasta
    $aclInfo = "Permissões para: $pasta`n" + ($acl.Access | Format-Table -AutoSize | Out-String) + "`n"
    $aclInfo | Out-File -FilePath "${reportPath}Permissoes_Pastas.txt" -Append
}

# Relatório finalizado
Write-Output "A avaliação inicial foi concluída. Relatórios salvos em $reportPath."