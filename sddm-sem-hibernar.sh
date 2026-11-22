#!/bin/sh
# Tela de login (SDDM) sem o botão Hibernar.
#
# O FreeBSD não hiberna, mas o firmware anuncia o estado S4 e o ConsoleKit
# oferece a opção. Na tela de login, apertar Hibernar desliga a máquina de
# uma vez. A regra do polkit não alcança a tela de login, porque o SDDM roda
# como root, então este script faz uma cópia do tema Brisa com o botão
# desativado e passa a usá-la.
#
# Rode de novo depois de atualizar o Plasma (sudo pkg upgrade), para a cópia
# acompanhar o tema original:  sudo sh sddm-sem-hibernar.sh
#
# Licença: CC0-1.0.

set -eu
ORIG=/usr/local/share/sddm/themes/breeze
COPIA=/usr/local/share/sddm/themes/breeze-x230
CONF=/usr/local/etc/sddm.conf.d/10-tema.conf

[ "$(id -u)" -eq 0 ] || { echo "Execute como root: sudo sh $0" >&2; exit 1; }
[ -f "$ORIG/Main.qml" ] || { echo "Tema Brisa do SDDM não encontrado em $ORIG" >&2; exit 1; }

rm -rf "$COPIA"
cp -R "$ORIG" "$COPIA"
sed -i '' 's/enabled: sddm\.canHibernate/visible: false/' "$COPIA/Main.qml"
if grep -q 'sddm\.canHibernate' "$COPIA/Main.qml"; then
	echo "AVISO: o tema mudou e o botão Hibernar não foi escondido; mantendo o tema original." >&2
	rm -rf "$COPIA" "$CONF"
	exit 1
fi
sed -i '' 's/^Name=.*/Name=Breeze (X230, sem hibernar)/' "$COPIA/metadata.desktop" 2>/dev/null || true

mkdir -p "$(dirname "$CONF")"
printf '[Theme]\nCurrent=breeze-x230\n' > "$CONF"
echo "Tela de login: tema breeze-x230, sem o botão Hibernar (vale a partir do próximo login)."
