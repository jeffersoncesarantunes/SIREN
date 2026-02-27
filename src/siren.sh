#!/usr/bin/env bash
# S.I.R.E.N. - Shell Interactive Runtime Entity Notifier
# Author: Jefferson Cesar Antunes

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}🚨 S.I.R.E.N. - Forensic Memory Streamer${NC}"
echo "------------------------------------------"

# Verificação de Root
if [[ $EUID -ne 0 ]]; then
   echo "Este script deve ser executado como root."
   exit 1
fi

stream_analysis() {
    local source=$1
    local output_dir="../dumps"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Garante que a pasta de destino existe
    mkdir -p "$output_dir"
    
    echo -e "${YELLOW}[!] Iniciando aquisição de:${NC} $source"
    echo "[!] Os resultados serão salvos em: $output_dir"
    
    # O Pipeline Real
    cat "$source" | tee >(sha256sum > "$output_dir/dump_$timestamp.sha256") \
                  | strings > "$output_dir/strings_$timestamp.txt"

    echo -e "${YELLOW}[+] Processo concluído.${NC}"
}

# --- Lógica de Execução ---

# Por enquanto, vamos testar com um arquivo seguro do sistema (ex: /proc/version)
# para validar se o pipeline gera os arquivos na pasta /dumps
read -p "Deseja realizar um teste de pipeline em /proc/version? (y/n): " confirm
if [[ $confirm == "y" ]]; then
    stream_analysis "/proc/version"
else
    echo "Operação cancelada."
fi
