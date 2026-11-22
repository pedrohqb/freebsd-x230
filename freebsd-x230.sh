#!/bin/sh
################################################################################
# FreeBSD 15 no ThinkPad X230: desktop KDE Plasma                              #
#                                                                              #
# Replica, até onde o FreeBSD permite, os programas do plasma.Brewfile         #
# (https://github.com/pedrohqb/brewfile) e da lista do CachyOS                 #
# (https://github.com/pedrohqb/package-list), trocando por equivalentes o que  #
# não existe nos pacotes do FreeBSD.                                           #
#                                                                              #
# USO (depois da instalação, já com rede e com o seu usuário criado):          #
#   su -m root -c 'sh freebsd-x230.sh pedro'                                   #
#                                                                              #
# - Pode ser executado mais de uma vez: pacotes já instalados são pulados e    #
#   todo arquivo do sistema alterado ganha antes uma cópia .orig, com o        #
#   conteúdo original da instalação.                                           #
# - Pacote que não existir na sua versão não interrompe o script: ele entra    #
#   num resumo no fim.                                                         #
# - As listas usam a origem do pacote (categoria/nome), que é estável entre    #
#   versões. Exclua ou comente o que não for necessário.                       #
#                                                                              #
# Licença: CC0-1.0. Pedro Henrique Quitete Barreto 2026                        #
################################################################################

set -u

# ------------------------------------------------------------------------------
# Ajustes rápidos
# ------------------------------------------------------------------------------
IDIOMA="pt_BR.UTF-8"                       # idioma da sessão
XKB_LAYOUT="us"                            # teclado: inglês americano...
XKB_VARIANT="intl"                         # ...internacional, com teclas mortas (' + c = ç)
CONSOLE_KEYMAP="us.acc.kbd"                # o mesmo teclado no console de texto
LOGIN_SHELL="/usr/local/bin/fish"          # shell do usuário (vazio: mantém o atual)
LOOK_AND_FEEL="org.kde.breezedark.desktop" # tema global do Plasma (Brisa escuro)
ARC_PCT=25                                 # % da RAM que o cache do ZFS pode usar
WEBAPP_BROWSER="chrome"                    # navegador dos aplicativos web (o Chromium)

# ------------------------------------------------------------------------------
# Listas de pacotes, por origem (categoria/nome)
# Formato: origem  # descrição
# ------------------------------------------------------------------------------
PKG_DESKTOP='
# Base gráfica
x11/xorg                                 # Xorg: servidor gráfico (sessão X11 e tela de login)
graphics/drm-kmod                        # DRM: driver de vídeo Intel (i915) do kernel
multimedia/libva-intel-driver            # VA-API: aceleração de vídeo nas Intel de 3ª geração
x11/plasma6-plasma                       # KDE Plasma 6: área de trabalho completa (Dolphin vem à parte)
x11/sddm                                 # SDDM: tela de login
sysutils/cpu-microcode-intel             # Microcódigo Intel: correções do processador no boot

# Aplicativos do KDE (os mesmos do CachyOS)
x11-fm/dolphin                           # Dolphin: gerenciador de arquivos
x11/konsole                              # Konsole: terminal
editors/kate                             # Kate: editor de texto
archivers/ark                            # Ark: compacta e extrai arquivos
graphics/gwenview                        # Gwenview: visualizador de imagens
graphics/okular                          # Okular: leitor de PDF e documentos
sysutils/filelight                       # Filelight: uso de disco em gráfico
math/kcalc                               # KCalc: calculadora
deskutils/kfind                          # KFind: procura arquivos
deskutils/kcharselect                    # KCharSelect: mapa de caracteres
sysutils/kdialog                         # KDialog: janelas de diálogo para scripts
security/kwalletmanager                  # KWalletManager: cofre de senhas do KDE
deskutils/kdeconnect-kde                 # KDE Connect: integra o celular ao computador
multimedia/haruna                        # Haruna: reprodutor de vídeo
graphics/kdegraphics-thumbnailers        # Miniaturas de PDF e imagens no Dolphin
multimedia/kdemultimedia-ffmpegthumbs    # Miniaturas de vídeos no Dolphin
devel/kio-extras                         # Pastas de rede (smb://, sftp://) e extras do Dolphin
sysutils/bsdisks                         # BSDisks: pendrives e discos externos no Dolphin
benchmarks/kdiskmark                     # KDiskMark: mede a velocidade de HDs e SSDs

# Fontes
x11-fonts/noto-basic                     # Noto: fontes com cobertura ampla de idiomas
x11-fonts/noto-emoji                     # Noto Emoji: emojis coloridos
x11-fonts/cantarell-fonts                # Cantarell: fonte de interface do GNOME
x11-fonts/dejavu                         # DejaVu: fontes livres de uso geral
x11-fonts/liberation-fonts-ttf           # Liberation: métricas de Arial, Times e Courier
x11-fonts/opensans-ttf                   # Open Sans
x11-fonts/bitstream-vera                 # Bitstream Vera
x11-fonts/jetbrains-mono                 # JetBrains Mono: fonte monoespaçada
x11-fonts/nerd-fonts-meslo               # MesloLGS Nerd Font (a do terminal do CachyOS)

# Multimídia e arquivos
multimedia/gstreamer1-libav              # GStreamer libav: decodificadores do FFmpeg
multimedia/gstreamer1-plugins-bad        # GStreamer: plugins extras
multimedia/gstreamer1-plugins-ugly       # GStreamer: MP3, DVD e outros formatos
# (libdvdcss, para DVDs de vídeo comerciais, não sai em pacote: veja o README)
archivers/unzip                          # unzip: extrai arquivos .zip
archivers/7-zip                          # 7-Zip: compacta e extrai .7z e outros formatos
archivers/unrar                          # unrar: extrai arquivos .rar
filesystems/ntfs                         # NTFS: lê e grava discos externos em NTFS
filesystems/exfat                        # exFAT: lê e grava pendrives e cartões em exFAT
devel/xdg-user-dirs                      # xdg-user-dirs: cria Documentos, Downloads, Imagens etc.

# Impressão
print/cups                               # CUPS: sistema de impressão
print/cups-filters                       # cups-filters: filtros genéricos de impressão
print/gutenprint                         # Gutenprint: drivers de impressoras
print/foomatic-db                        # Foomatic: banco de drivers de impressoras
print/brlaser                            # brlaser: lasers monocromáticas da Brother
print/cups-pdf                           # CUPS-PDF: impressora virtual que gera PDF
print/system-config-printer              # system-config-printer: configura impressoras

# Rede e webcam
net-mgmt/networkmgr                      # NetworkMgr: Wi-Fi e rede no painel
multimedia/webcamd                       # webcamd: webcams USB, como a do X230
'

PKG_CLI='
# Sistema
security/sudo                            # sudo: administração com a senha do usuário
shells/fish                              # fish: shell com sugestões e autocompletar (o do CachyOS)
editors/nano                             # nano: editor de texto simples
editors/micro                            # micro: editor de texto com atalhos comuns
editors/vim                              # Vim: editor de texto avançado
sysutils/fastfetch                       # fastfetch: resumo do sistema no terminal
sysutils/btop                            # btop: monitor de processos
sysutils/py-glances                      # Glances: monitor do sistema
sysutils/tree                            # tree: árvore de pastas
sysutils/smartmontools                   # smartmontools: saúde dos discos
ftp/wget                                 # wget: baixa arquivos pelo terminal
net/rsync                                # rsync: copia e sincroniza pastas

# Desenvolvimento
devel/git                                # Git: controle de versão
devel/gh                                 # GitHub CLI: repositórios, issues, pull requests e releases
www/node                                 # Node.js: executa JavaScript fora do navegador
www/npm                                  # npm: gerenciador de pacotes JavaScript

# Inteligência Artificial
misc/codex                               # Codex: agente de IA da OpenAI no terminal
# (o port misc/claude-code não é oficial e altera o programa da Anthropic; ficou de fora)

# Internet e Nuvem
net/onedrive                             # OneDrive Client for Linux: sincroniza com o OneDrive (o do CachyOS)
net/rclone                               # rclone: copia arquivos de e para o OneDrive sob demanda
net/wireguard-tools                      # WireGuard: wg e wg-quick, para o .conf da VPN
www/yt-dlp                               # yt-dlp: baixa vídeos e áudios

# PDF e OCR
textproc/py-ocrmypdf                     # OCRmyPDF: camada de texto pesquisável em PDFs digitalizados
textproc/pdfgrep                         # pdfgrep: pesquisa texto dentro de PDFs
graphics/tesseract                       # Tesseract: OCR, com todos os idiomas (inclusive português)

# Utilitários
graphics/GraphicsMagick                  # GraphicsMagick: converte e edita imagens em lote
sysutils/rdfind                          # rdfind: localiza arquivos duplicados
textproc/ripgrep                         # ripgrep: procura texto em pastas inteiras
benchmarks/sysbench                      # sysbench: testa CPU, memória e disco
'

PKG_GUI='
# Áudio e Vídeo
audio/audacity                           # Audacity: editor e gravador de áudio
multimedia/kdenlive                      # Kdenlive: editor de vídeo
multimedia/obs-studio                    # OBS Studio: gravação de tela e transmissão

# Comunicação
mail/evolution                           # Evolution: e-mail, contatos e calendário
mail/evolution-ews                       # Evolution EWS: contas do Microsoft 365 e do Exchange
security/gnome-keyring                   # GNOME Keyring: cofre de senhas que o Evolution usa
net-im/teams                             # Teams for Linux: cliente não oficial do Teams
net-im/telegram-desktop                  # Telegram
net-im/py-zapzap                         # ZapZap: WhatsApp em janela própria
# (Discord e Zoom: atalhos de aplicativo web, criados mais abaixo)

# Desenvolvimento
textproc/meld                            # Meld: compara e mescla arquivos e pastas

# Escritório e PDF
deskutils/joplin-desktop                 # Joplin: notas em Markdown, com sincronização
editors/libreoffice                      # LibreOffice: suíte de escritório
portuguese/libreoffice-pt_BR             # LibreOffice: português do Brasil
print/pdfarranger                        # PDF Arranger: junta, divide, gira e reordena páginas
# (ONLYOFFICE e PDFsam Basic não têm versão para FreeBSD)

# Estudo e Leitura
misc/bibletime                           # BibleTime: estudo da Bíblia

# Gravação de Mídias
sysutils/k3b                             # K3b: grava CDs, DVDs e Blu-rays (o do CachyOS)

# Imagens e Fotografia
graphics/digikam                         # digiKam: organizador de fotos
graphics/gimp                            # GIMP: editor de imagens (no FreeBSD, ainda a 2.10)
graphics/kolourpaint                     # KolourPaint: editor de imagens simples

# Internet e Nuvem
www/chromium                             # Chromium: navegador (o Brave ainda não chegou aos pacotes trimestrais); abre os aplicativos web
www/firefox                              # Firefox: navegador da Mozilla
net/krdc                                 # KRDC: área de trabalho remota (RDP e VNC)
net-p2p/qbittorrent                      # qBittorrent: cliente BitTorrent

# Música e Rádio
audio/shortwave                          # Shortwave: rádio pela internet
# (Spotify: sem cliente oficial; veja o README. O YouTube Music vira aplicativo web)

# Segurança e Senhas
security/keepassxc                       # KeePassXC: gerenciador de senhas
security/opensc                          # OpenSC: tokens com suporte livre, como o ePass2003
devel/libccid                            # CCID: driver genérico de leitoras e tokens USB
devel/pcsc-lite                          # PC/SC Lite: serviço de acesso a leitoras e tokens
# (Tessera, drivers SafeNet, SafeSign e SerproID e os assinadores web dependem
#  de Linux ou de Flatpak; o PJeOffice Pro tem script próprio: pjeoffice-freebsd.sh)

# Virtualização
emulators/qemu                           # QEMU: máquinas virtuais
emulators/wine                           # Wine: programas do Windows (no lugar do Bottles)
'

# Aplicativos web: id|Nome|URL|ícone|categorias|navegador
# Ícone "site:dominio": baixa o ícone do próprio site.
# Navegador "app": janela própria no $WEBAPP_BROWSER; "firefox": janela do Firefox.
WEBAPPS='
chatgpt|ChatGPT|https://chatgpt.com/|site:chatgpt.com|Network;|app
claude|Claude|https://claude.ai/|site:claude.ai|Network;|app
discord|Discord|https://discord.com/app|site:discord.com|Network;InstantMessaging;|app
ytmusic|YouTube Music|https://music.youtube.com/|site:music.youtube.com|AudioVideo;Audio;|app
zoom|Zoom|https://app.zoom.us/wc|site:zoom.us|Network;VideoConference;|firefox
'

# ------------------------------------------------------------------------------
# Funções auxiliares
# ------------------------------------------------------------------------------
msg()  { printf '\n==> %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '    AVISO: %s\n' "$*" >&2; AVISOS="${AVISOS}
  - $*"; }
AVISOS=""

# Guarda uma cópia .orig antes da primeira alteração de um arquivo existente.
# Não copia os arquivos que o próprio script cria (na pasta pessoal e os dois
# arquivos dele no sistema): numa segunda execução, a cópia seria só lixo.
backup() {
	case "$1" in
	"$CASA"/*|*/30-x230.conf|*/50-sem-hibernar.rules) return 0 ;;
	esac
	[ -e "$1" ] && [ ! -e "$1.orig" ] && cp -p "$1" "$1.orig"
	return 0
}

# Grava a entrada padrão no arquivo indicado, criando a pasta e a cópia .orig.
put() {
	mkdir -p "$(dirname "$1")"
	backup "$1"
	cat > "$1"
}

# Acrescenta a linha ao arquivo se ela ainda não estiver lá.
linha() {
	touch "$2"
	grep -qxF "$1" "$2" || { backup "$2"; echo "$1" >> "$2"; }
}

# Instala os pacotes de uma lista, um a um, sem parar se algum não existir.
# Confere pela lista de origens instaladas (pkg query %o), comparando a linha inteira.
instalado() { pkg query '%o' 2>/dev/null | grep -qxF "$1"; }
install_list() {
	printf '%s\n' "$1" | sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' |
	while read -r origem; do
		if instalado "$origem"; then
			info "já instalado: $origem"
			continue
		fi
		pkg install -y "$origem" >/dev/null 2>&1
		if instalado "$origem"; then
			info "instalado:    $origem"
		else
			info "NÃO INSTALOU: $origem"
			echo "$origem" >> "$TMP_FALTANDO"
		fi
	done
}

# ------------------------------------------------------------------------------
# Verificações
# ------------------------------------------------------------------------------
[ "$(uname -s)" = "FreeBSD" ] || { echo "Este script é para FreeBSD." >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Execute como root: su -m root -c 'sh $0 usuário'" >&2; exit 1; }

ALVO="${1:-${SUDO_USER:-}}"
[ -n "$ALVO" ] || { echo "Indique o usuário: sh $0 usuário" >&2; exit 1; }
id "$ALVO" >/dev/null 2>&1 || { echo "Usuário '$ALVO' não existe." >&2; exit 1; }
[ "$ALVO" != "root" ] || { echo "Indique o seu usuário comum, não o root." >&2; exit 1; }
CASA="$(getent passwd "$ALVO" | cut -d: -f6)"
GRUPO="$(id -gn "$ALVO")"
[ -d "$CASA" ] || { echo "Pasta pessoal '$CASA' não encontrada." >&2; exit 1; }

TMP_FALTANDO="$(mktemp /tmp/faltando.XXXXXX)"
trap 'rm -f "$TMP_FALTANDO"' EXIT

msg "FreeBSD $(freebsd-version) em $(kenv -q smbios.system.version 2>/dev/null || kenv -q smbios.system.product); usuário: $ALVO"

# ------------------------------------------------------------------------------
# 1. Sistema: atualizações, pacotes e firmware
# ------------------------------------------------------------------------------
msg "Correções de segurança do sistema base (freebsd-update)"
PAGER="cat" freebsd-update --not-running-from-cron fetch install ||
	info "freebsd-update: nada a aplicar (ou indisponível agora)"

msg "Gerenciador de pacotes"
env ASSUME_ALWAYS_YES=yes pkg bootstrap -f >/dev/null 2>&1 || true
pkg update -f || warn "pkg update falhou; confira a rede"
pkg upgrade -y || warn "pkg upgrade falhou"

msg "Firmware (Wi-Fi e vídeo)"
if command -v fwget >/dev/null 2>&1; then
	fwget || warn "fwget falhou; rode 'fwget' com a rede funcionando"
else
	info "fwget não existe nesta versão: pulado"
fi

# ------------------------------------------------------------------------------
# 2. Pacotes
# ------------------------------------------------------------------------------
msg "Ambiente de trabalho"
install_list "$PKG_DESKTOP"
msg "Programas de linha de comando"
install_list "$PKG_CLI"
msg "Programas gráficos"
install_list "$PKG_GUI"

# ------------------------------------------------------------------------------
# 3. Sistema: serviços, boot, energia e permissões
# ------------------------------------------------------------------------------
msg "Serviços (/etc/rc.conf)"
backup /etc/rc.conf
sysrc kld_list+="i915kms" >/dev/null           # vídeo Intel
sysrc dbus_enable="YES" sddm_enable="YES" cupsd_enable="YES" \
      pcscd_enable="YES" webcamd_enable="YES" powerd_enable="YES" \
      powerd_flags="-a hiadaptive -b adaptive" \
      keymap="$CONSOLE_KEYMAP" clear_tmp_enable="YES" \
      devfs_system_ruleset="localrules" sddm_lang="${IDIOMA%%.*}" >/dev/null &&
	info "dbus, sddm, cupsd, pcscd, webcamd e powerd ativados no boot" ||
	warn "não consegui gravar o /etc/rc.conf"

# Boot: TrackPoint e touchpad como aparelhos separados, teclas da ThinkPad,
# brilho, câmera USB (cuse), sensores e microcódigo.
msg "Boot (/boot/loader.conf)"
for l in 'hw.psm.synaptics_support="1"' 'hw.psm.trackpoint_support="1"' \
         'acpi_ibm_load="YES"' 'acpi_video_load="YES"' 'cuse_load="YES"' \
         'coretemp_load="YES"' 'cpu_microcode_load="YES"' \
         'cpu_microcode_name="/boot/firmware/intel-ucode.bin"'; do
	linha "$l" /boot/loader.conf
done

# Tampa fechada suspende; teclado e mouse vão direto ao Xorg/Wayland (evdev);
# montar pendrives sem root; buffers maiores para o Wayland; cache do ZFS limitado.
msg "Ajustes do kernel (/etc/sysctl.conf)"
RAM=$(sysctl -n hw.physmem)
ARC=$(( RAM / 100 * ARC_PCT ))
backup /etc/sysctl.conf
touch /etc/sysctl.conf
for l in "hw.acpi.lid_switch_state=S3" "kern.evdev.rcpt_mask=12" \
         "vfs.usermount=1" "net.local.stream.sendspace=65536" \
         "net.local.stream.recvspace=65536" "vfs.zfs.arc.max=$ARC"; do
	sed -i '' "/^${l%%=*}=/d" /etc/sysctl.conf 2>/dev/null
	linha "$l" /etc/sysctl.conf
	sysctl "$l" >/dev/null 2>&1 || true
done
info "cache do ZFS: até $(( ARC / 1048576 )) MB"

# Pendrives, discos externos e gravador de CD/DVD para o grupo operator.
msg "Permissões de discos removíveis (/etc/devfs.rules)"
if ! grep -q '^\[localrules=' /etc/devfs.rules 2>/dev/null; then
	backup /etc/devfs.rules
	cat >> /etc/devfs.rules <<'EOF'
[localrules=10]
add path 'da*' mode 0660 group operator
add path 'cd*' mode 0660 group operator
add path 'pass*' mode 0660 group operator
add path 'xpt*' mode 0660 group operator
add path 'ugen*' mode 0660 group operator
add path 'usb/*' mode 0660 group operator
EOF
fi
service devfs restart >/dev/null 2>&1 || true

msg "Grupos de $ALVO: wheel, operator, video e webcamd"
for g in wheel operator video webcamd; do
	pw groupmod "$g" -m "$ALVO" 2>/dev/null || warn "não consegui pôr $ALVO no grupo $g"
done

# Sem cópia .orig aqui: tudo em sudoers.d é lido pelo sudo. O visudo também
# exige modo 0440 nos arquivos da pasta (o do NetworkMgr vem com 0644).
# "00-" para vir antes dos outros: os arquivos são lidos em ordem alfabética e
# vale a última regra que se encaixa; com outro nome, esta passaria por cima da
# regra sem senha do NetworkMgr, que então não abre no login.
msg "sudo para o grupo wheel"
mkdir -p /usr/local/etc/sudoers.d
echo '%wheel ALL=(ALL:ALL) ALL' > /usr/local/etc/sudoers.d/00-wheel
rm -f /usr/local/etc/sudoers.d/wheel /usr/local/etc/sudoers.d/wheel.orig
chmod 440 /usr/local/etc/sudoers.d/*
visudo -c >/dev/null 2>&1 || warn "o visudo -c acusou erro; rode 'visudo -c' para ver qual arquivo"

msg "ZFS sem atime (menos gravações no SSD)"
if zpool list zroot >/dev/null 2>&1; then
	zfs set atime=off zroot && info "atime=off em zroot"
else
	info "sem o pool zroot: pulado"
fi

# Xorg: toque para clicar no touchpad e rolagem segurando o botão do meio
# do TrackPoint (na sessão X11; no Wayland, ajuste nas Configurações do sistema).
msg "Touchpad e TrackPoint no Xorg"
put /usr/local/etc/X11/xorg.conf.d/30-x230.conf <<'EOF'
Section "InputClass"
	Identifier "Touchpad"
	MatchIsTouchpad "on"
	Driver "libinput"
	Option "Tapping" "on"
EndSection

Section "InputClass"
	Identifier "TrackPoint"
	MatchProduct "TrackPoint"
	Driver "libinput"
	Option "ScrollMethod" "button"
	Option "ScrollButton" "2"
EndSection
EOF

# O FreeBSD não hiberna (S4). Sem esta regra, a tela de login e o menu de saída
# do Plasma oferecem "Hibernar", que não funciona.
msg "Sem a opção de hibernar (polkit)"
put /usr/local/etc/polkit-1/rules.d/50-sem-hibernar.rules <<'EOF'
// O FreeBSD não hiberna: esconde Hibernar e Suspensão híbrida.
polkit.addRule(function(action, subject) {
	if (action.id.indexOf("org.freedesktop.consolekit.system.hibernate") == 0 ||
	    action.id.indexOf("org.freedesktop.consolekit.system.hybridsleep") == 0) {
		return polkit.Result.NO;
	}
});
EOF
chmod 644 /usr/local/etc/polkit-1/rules.d/50-sem-hibernar.rules

# Na tela de login a regra acima não vale (o SDDM roda como root), e lá o
# botão Hibernar desliga a máquina de uma vez: usa uma cópia do tema sem ele.
msg "Tela de login sem o botão Hibernar"
if [ -f "$(dirname "$0")/sddm-sem-hibernar.sh" ]; then
	sh "$(dirname "$0")/sddm-sem-hibernar.sh" | sed 's/^/    /' ||
		warn "não consegui tirar o Hibernar da tela de login"
else
	warn "sddm-sem-hibernar.sh não está ao lado deste script"
fi

# Teclado internacional já na tela de login.
msg "Teclado na tela de login (SDDM)"
XSETUP=/usr/local/share/sddm/scripts/Xsetup
if [ -f "$XSETUP" ]; then
	grep -q setxkbmap "$XSETUP" ||
		{ backup "$XSETUP"; echo "setxkbmap -layout $XKB_LAYOUT -variant $XKB_VARIANT"  >> "$XSETUP"; }
else
	warn "$XSETUP não existe; o SDDM foi instalado?"
fi

# ------------------------------------------------------------------------------
# 4. Usuário: shell, idioma, teclado, tema e aplicativos web
# ------------------------------------------------------------------------------
if [ -n "$LOGIN_SHELL" ] && [ -x "$LOGIN_SHELL" ]; then
	msg "Shell de $ALVO: $LOGIN_SHELL"
	grep -qxF "$LOGIN_SHELL" /etc/shells || echo "$LOGIN_SHELL" >> /etc/shells
	pw usermod "$ALVO" -s "$LOGIN_SHELL" || warn "não consegui trocar o shell"
fi

msg "Idioma $IDIOMA"
put "$CASA/.login_conf" <<EOF
me:\\
	:charset=UTF-8:\\
	:lang=$IDIOMA:
EOF
cap_mkdb "$CASA/.login_conf"

CFG="$CASA/.config"
msg "Plasma: teclado $XKB_LAYOUT $XKB_VARIANT, idioma, TrackPoint e bloqueio ao suspender"
put "$CFG/kxkbrc" <<EOF
[Layout]
LayoutList=$XKB_LAYOUT
VariantList=$XKB_VARIANT
ResetOldOptions=true
Use=true
EOF
# O Plasma (X11) aplica a configuração dele no login e desligava a rolagem pelo
# TrackPoint que o Xorg já deixava ligada; esta é a chave que a tela de Mouse grava.
if command -v kwriteconfig6 >/dev/null 2>&1; then
	kwriteconfig6 --file "$CFG/kcminputrc" --group Mouse --key XLbInptScrollOnButtonDown true
else
	warn "kwriteconfig6 não encontrado: ligue a rolagem do TrackPoint em Configurações > Mouse e touchpad"
fi
put "$CFG/plasma-localerc" <<EOF
[Formats]
LANG=$IDIOMA

[Translations]
LANGUAGE=${IDIOMA%%.*}
EOF
put "$CFG/kscreenlockerrc" <<'EOF'
[Daemon]
Autolock=true
LockOnResume=true
Timeout=10
EOF

msg "Atalhos de aplicativos web ($WEBAPP_BROWSER; Zoom no Firefox)"
APPS="$CASA/.local/share/applications"
ICONES="$CASA/.local/share/icons"
mkdir -p "$APPS" "$ICONES"
printf '%s\n' "$WEBAPPS" | sed '/^$/d' | while IFS='|' read -r id nome url icone cats nav; do
	if [ "$nav" = "firefox" ]; then cmd="firefox --new-window $url"
	else cmd="$WEBAPP_BROWSER --app=$url --class=webapp-$id"; fi
	case "$icone" in
	site:*)
		arq="$ICONES/webapp-$id.png"
		if [ -s "$arq" ] || fetch -q -o "$arq" \
		    "https://www.google.com/s2/favicons?sz=128&domain=${icone#site:}" 2>/dev/null; then
			icone="$arq"
		else
			rm -f "$arq"; icone="applications-internet"
		fi ;;
	esac
	put "$APPS/webapp-$id.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$nome
Comment=$nome (aplicativo web)
Exec=$cmd
Icon=$icone
Categories=$cats
StartupWMClass=webapp-$id
EOF
	info "$nome"
done

# No primeiro login: cria as pastas pessoais e aplica o tema global.
mkdir -p "$CASA/.local/bin"
put "$CASA/.local/bin/primeiro-login.sh" <<EOF
#!/bin/sh
xdg-user-dirs-update
plasma-apply-lookandfeel -a $LOOK_AND_FEEL
rm -f "\$HOME/.config/autostart/primeiro-login.desktop"
EOF
chmod 755 "$CASA/.local/bin/primeiro-login.sh"
put "$CFG/autostart/primeiro-login.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Ajustes do primeiro login
Exec=$CASA/.local/bin/primeiro-login.sh
EOF
rm -f "$CFG/autostart/primeiro-login.desktop.orig"   # a cópia não pode ficar na pasta de início

chown -R "$ALVO:$GRUPO" "$CFG" "$CASA/.local" "$CASA/.login_conf" "$CASA/.login_conf.db"

# ------------------------------------------------------------------------------
# Resumo
# ------------------------------------------------------------------------------
msg "Concluído"
if [ -s "$TMP_FALTANDO" ]; then
	echo "    Pacotes não instalados (rode 'pkg install origem' para ver o motivo):"
	sed 's/^/      - /' "$TMP_FALTANDO"
fi
[ -n "$AVISOS" ] && printf '    Avisos:%s\n' "$AVISOS"
cat <<EOF

    Próximos passos:
      1. Reinicie: shutdown -r now. A tela de login (SDDM) abre sozinha.
         Na primeira vez, escolha a sessão "Plasma (X11)" no canto da tela.
      2. Confira tudo: sh revisao-freebsd.sh (com o seu usuário).
      3. PJeOffice Pro: sh pjeoffice-freebsd.sh (com o seu usuário).
      4. OneDrive: onedrive (primeiro login) ou rclone config.
      5. Token ePass2003 no Firefox: Configurações > Privacidade e Segurança >
         Dispositivos de segurança > Carregar:
         /usr/local/lib/pkcs11/opensc-pkcs11.so

EOF
