#!/bin/sh
# Revisão da instalação feita pelo freebsd-x230.sh. Só confere; não altera nada.
# Uso (com o seu usuário, na mesma pasta do freebsd-x230.sh):  sh revisao-freebsd.sh
DIR="$(dirname "$0")"
SCRIPT="$DIR/freebsd-x230.sh"
[ -f "$SCRIPT" ] || { echo "Não achei $SCRIPT ao lado deste script." >&2; exit 1; }

ok=0; falta=0
bom()  { ok=$((ok+1)); }
ruim() { falta=$((falta+1)); printf '  FALTA: %s\n' "$*"; }

echo "== Pacotes (as listas do freebsd-x230.sh)"
ORIGENS="$(awk "/^PKG_[A-Z]*='/{f=1; next} f && /^'/{f=0} f" "$SCRIPT" |
	sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d')"
INSTALADOS="$(pkg query '%o' 2>/dev/null)"
for o in $ORIGENS; do
	if printf '%s\n' "$INSTALADOS" | grep -qxF "$o"; then bom; else ruim "pacote $o"; fi
done

echo "== Serviços ativados no boot"
for s in dbus sddm cupsd pcscd webcamd powerd; do
	if [ "$(sysrc -n ${s}_enable 2>/dev/null)" = "YES" ]; then bom; else ruim "serviço $s"; fi
done
case " $(sysrc -n kld_list 2>/dev/null) " in
*" i915kms "*) bom ;;
*) ruim "i915kms em kld_list (vídeo Intel)" ;;
esac
if kldstat -q -n i915kms; then bom; else ruim "módulo de vídeo i915kms carregado"; fi

echo "== Boot (/boot/loader.conf)"
for l in hw.psm.synaptics_support hw.psm.trackpoint_support acpi_ibm_load \
         acpi_video_load cuse_load coretemp_load cpu_microcode_load; do
	if grep -q "^$l=" /boot/loader.conf 2>/dev/null; then bom; else ruim "$l em /boot/loader.conf"; fi
done

echo "== Ajustes do kernel (sysctl)"
for par in hw.acpi.lid_switch_state=S3 kern.evdev.rcpt_mask=12 vfs.usermount=1 \
           net.local.stream.sendspace=65536 net.local.stream.recvspace=65536; do
	atual="$(sysctl -n "${par%%=*}" 2>/dev/null)"
	if [ "$atual" = "${par#*=}" ]; then bom
	else ruim "sysctl ${par%%=*} está em '$atual' (esperado ${par#*=})"; fi
done
if grep -q '^vfs.zfs.arc.max=' /etc/sysctl.conf 2>/dev/null; then bom; else ruim "limite do cache do ZFS em /etc/sysctl.conf"; fi

echo "== Arquivos de configuração"
for f in /etc/devfs.rules /usr/local/etc/sudoers.d/wheel \
         /usr/local/etc/X11/xorg.conf.d/30-x230.conf \
         /usr/local/etc/polkit-1/rules.d/50-sem-hibernar.rules \
         /usr/local/etc/sddm.conf.d/zz-x230-tema.conf \
         "$HOME/.login_conf" "$HOME/.config/kxkbrc" "$HOME/.config/plasma-localerc" \
         "$HOME/.config/kscreenlockerrc"; do
	if [ -e "$f" ]; then bom; else ruim "arquivo $f"; fi
done
for a in chatgpt claude discord ytmusic zoom; do
	f="$HOME/.local/share/applications/webapp-$a.desktop"
	if [ -e "$f" ]; then bom; else ruim "atalho web $a"; fi
done

if [ "$(sysrc -n sddm_lang 2>/dev/null)" = "pt_BR" ]; then bom; else ruim "tela de login em português (sddm_lang)"; fi

echo "== Usuário e sistema"
for g in wheel operator video webcamd; do
	if id -Gn | tr ' ' '\n' | grep -qx "$g"; then bom; else ruim "grupo $g"; fi
done
if [ "$(zfs get -H -o value atime zroot 2>/dev/null)" = "off" ]; then bom; else ruim "atime=off no ZFS"; fi
if grep -q setxkbmap /usr/local/share/sddm/scripts/Xsetup 2>/dev/null; then bom; else ruim "teclado internacional na tela de login"; fi
n="$(sysctl -n hw.ncpu 2>/dev/null)"
if [ "$n" = "4" ]; then bom; else ruim "threads ativos: $n (esperado 4)"; fi
if ifconfig | grep 'inet ' | grep -qv '127.0.0.1'; then bom; else ruim "rede sem endereço"; fi
if [ -e /dev/video0 ]; then bom; else ruim "webcam (/dev/video0)"; fi

echo
echo "Resultado: $ok itens certos, $falta faltando."
