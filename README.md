# freebsd-x230

FreeBSD 15 com KDE Plasma no ThinkPad X230: pós-instalação, revisão e PJeOffice Pro.

O script instala os programas e configura o sistema e a sessão. As listas ficam dentro dele, por categoria e com a descrição de cada pacote, seguindo o `plasma.Brewfile` do repositório [brewfile](https://github.com/pedrohqb/brewfile) e a lista do CachyOS do [package-list](https://github.com/pedrohqb/package-list), com equivalentes para o que não existe no FreeBSD.

> **Estado:** escrito para o X230 a partir do que funciona no [openbsd-x230](https://github.com/pedrohqb/openbsd-x230), com os nomes dos pacotes conferidos na árvore de ports (ramo 2026Q4), mas **ainda não testado na máquina**. A lista do que testar está no fim.

## Arquivos

| Arquivo | O que faz |
|---|---|
| `freebsd-x230.sh` | Pós-instalação: atualiza o sistema, instala firmware e pacotes e configura vídeo, serviços, energia, teclado, TrackPoint, permissões, sudo, idioma, tema do Plasma e atalhos de aplicativos web |
| `revisao-freebsd.sh` | Revisão: confere pacotes, serviços, ajustes e arquivos, sem alterar nada, e lista o que falta |
| `pjeoffice-freebsd.sh` | Instala o PJeOffice Pro do CNJ na pasta pessoal, rodando no OpenJDK 11 do FreeBSD |
| `sddm-sem-hibernar.sh` | Tira o botão Hibernar da tela de login; rode de novo depois de atualizar o Plasma |
| `opensc-java.c` | Biblioteca que o script do PJeOffice compila para o Java assinar com token do OpenSC |

## Uso

### 1. Instalar o FreeBSD no segundo SSD

Baixe a imagem `memstick` ou `disc1` do [FreeBSD 15.1](https://www.freebsd.org/where/) e dê o boot por ela pelo menu de boot do SeaBIOS. No instalador:

- **Teclado:** *United States of America ISO-8859-1 (accent keys)*.
- **Componentes:** escolha os conjuntos de distribuição tradicionais (não a opção por pacotes do sistema base) e marque `lib32`, que o Wine usa.
- **Rede:** configure o Wi-Fi ali mesmo.
- **Disco:** *Auto (ZFS)* com estas opções:
  - *Pool Type:* `stripe`, marcando **só o segundo SSD**. Identifique-o pelo modelo e pelo tamanho; o disco do OpenBSD fica desmarcado e não é tocado.
  - *Partition Scheme:* `GPT (BIOS)`, porque o Skulls não tem UEFI.
  - *Encrypt Disks:* `YES` (GELI). A senha é pedida a cada boot.
  - *Encrypt Swap:* `YES`.
- **Fuso horário:** America/Sao_Paulo.
- **Serviços:** `ntpd` com `ntpd_sync_on_start` e `powerd`; deixe o `sshd` desligado.
- **Firmware:** aceite instalar o que o instalador sugerir.
- **Usuário:** crie o seu e convide-o para os grupos `wheel operator video`.

Para escolher o sistema depois, use o menu de boot do SeaBIOS: cada SSD tem o próprio carregador.

### 2. Rodar a pós-instalação

Entre como `root` no console:

```sh
pkg install -y git
git clone https://github.com/pedrohqb/freebsd-x230.git
sh freebsd-x230/freebsd-x230.sh pedro
shutdown -r now
```

Na primeira entrada pela tela de login, escolha a sessão **Plasma (X11)**. O SDDM lembra a escolha.

### 3. Conferir

Já na sessão gráfica, com o seu usuário:

```sh
sh freebsd-x230/revisao-freebsd.sh
```

### 4. PJeOffice Pro (opcional)

Com o seu usuário:

```sh
sh freebsd-x230/pjeoffice-freebsd.sh
```

O PJeOffice roda no OpenJDK 11, sem alteração no `.jar` do CNJ. O script troca o `ffmpeg` de Linux pelo do FreeBSD, impede a janela de recolher para a bandeja e prepara o player do corte por trechos com o JavaFX do pacote `openjfx14`. Para o **token**, indique `~/.local/share/pjeoffice-pro/opensc-java.so` (caminho completo) na aba A3 da configuração de certificado, e não o `opensc-pkcs11.so`: o Java 11 descarta os mecanismos RSA do OpenSC e a assinatura falha com `is not a RSAPrivateKey instance`; a biblioteca corrige isso.

## O que o script configura

- **Sistema:** `freebsd-update`, pacotes atualizados, firmware (`fwget`), microcódigo Intel, `sudo` para o grupo `wheel`, `atime=off` no ZFS e cache do ZFS limitado a 25% da RAM.
- **Vídeo e sessão:** driver Intel (`i915kms`), Xorg, Plasma 6 e tela de login SDDM.
- **Energia:** `powerd` (frequência automática), suspensão ao fechar a tampa, tela bloqueada ao voltar e sem a opção de hibernar, que o FreeBSD não tem.
- **Entrada:** teclado inglês internacional com teclas mortas, no console, na tela de login e no Plasma; TrackPoint e touchpad como aparelhos separados, rolagem segurando o botão do meio do TrackPoint (no Xorg e nas configurações do Plasma, que senão a desliga no login) e toque para clicar no touchpad.
- **Permissões:** pendrives, discos externos e gravador de CD/DVD para o grupo `operator`, montagem sem root e webcam pelo `webcamd`.
- **Usuário:** fish como shell, Plasma e tela de login em português do Brasil, tema Brisa escuro e pastas pessoais criadas no primeiro login.
- **Aplicativos web:** ChatGPT, Claude, Discord e YouTube Music no Chromium, em janela própria, e Zoom no Firefox.

## Observações

- **Plasma e Wayland:** os pacotes trimestrais em uso (2026Q4) trazem o Plasma 6.7, que ainda tem a sessão X11. O Plasma 6.8 só tem Wayland e deve chegar aos pacotes trimestrais em 2027; o FreeBSD mantém um Plasma LTS com X11 (`plasma6lts-plasma`), mas ele é compilado à parte dos aplicativos do KDE dos pacotes oficiais e pode conflitar com eles. No Wayland, o touchpad e o TrackPoint se ajustam em Configurações do sistema → Mouse e touchpad, e os programas X11 (como o PJeOffice) rodam pelo XWayland.
- **Sem equivalente no FreeBSD:** ONLYOFFICE, PDFsam Basic, Tessera e tudo o que é Flatpak (o FreeBSD não tem Flatpak), Mission Center, Gear Lever, Distrobox e os drivers SafeNet, SafeSign e SerproID. Claude e ChatGPT viram aplicativos web. O port `misc/claude-code` existe, mas não é oficial e altera o programa da Anthropic; ficou de fora.
- **Brave:** ainda não está nos pacotes trimestrais; o Chromium faz o papel dele. Quando o pacote chegar, troque `www/chromium` por `www/brave` e `WEBAPP_BROWSER` por `brave` no topo do script.
- **GIMP:** o FreeBSD ainda empacota a versão 2.10.
- **DVDs de vídeo comerciais:** a `libdvdcss` não é distribuída em pacote, por causa da licença. Para tê-la, compile o port: `sudo make -C /usr/ports/multimedia/libdvdcss install clean` (com a árvore de ports baixada).
- **e-SAJ:** a extensão [Jamegão](https://github.com/pedrohqb/jamegao) substitui o WebSigner no Firefox e no Chromium, com certificado A1.
- **Spotify:** não há cliente oficial. O player web exige o Widevine, que só se instala compilando os ports `www/linux-widevine-cdm` e `www/foreign-cdm` (licença do Google). O YouTube Music funciona como aplicativo web.
- **Hibernar:** o FreeBSD não hiberna, mas o firmware anuncia a hibernação. No Plasma, uma regra do polkit esconde a opção. Na tela de login, onde a regra não vale porque o SDDM roda como root, apertar Hibernar desliga a máquina de uma vez; por isso o script usa uma cópia do tema Brisa sem o botão. Depois de atualizar o Plasma, rode `sudo sh sddm-sem-hibernar.sh` para refazer a cópia.
- **Atualizações e volta atrás:** `sudo freebsd-update fetch install` e `sudo pkg upgrade`. Antes de uma atualização grande, `sudo bectl create antes-da-atualizacao` cria um ambiente de boot; se algo quebrar, escolha-o no menu do carregador do FreeBSD.
- **Wi-Fi:** o instalador grava a rede. Para outras redes, use o NetworkMgr no painel ou acrescente-as em `/etc/wpa_supplicant.conf`.
- **VPN WireGuard:** o WireGuard faz parte do kernel; o `wireguard-tools` traz o `wg-quick`. Guarde o `.conf` como `/usr/local/etc/wireguard/wg0.conf`, com permissão `600`, e use `sudo wg-quick up wg0` e `sudo wg-quick down wg0`.
- **Impressora de rede:** se o nome `.local` da impressora não resolver, faça como no OpenBSD: reserve o IP no roteador e registre o nome em `/etc/hosts`. A administração do CUPS fica em `http://localhost:631`.
- **Pastas de rede (Samba):** o Dolphin abre `smb://servidor/pasta`.
- **OneDrive:** o mesmo cliente do CachyOS (`onedrive`) ou, para copiar sob demanda, o `rclone config` com "Microsoft OneDrive".
- **Token ePass2003 no Firefox:** Configurações → Privacidade e Segurança → Dispositivos de segurança → Carregar: `/usr/local/lib/pkcs11/opensc-pkcs11.so`.

## O que testar na máquina

1. Boot pelo menu do SeaBIOS e senha do GELI.
2. Vídeo (`kldstat | grep i915`) e sessão Plasma (X11).
3. Wi-Fi e NetworkMgr no painel.
4. Suspensão pela tampa e volta com a tela bloqueada.
5. Teclas de brilho e volume da ThinkPad. Se as de volume não fizerem nada, vá em Configurações do sistema → Teclado → Atalhos → Volume do áudio, clique em **Padrões** e em **Aplicar**. O botão de silenciar o microfone não é reconhecido pelo FreeBSD (nem pelo OpenBSD).
6. TrackPoint com rolagem e toque no touchpad.
7. Áudio, microfone e webcam (Firefox e Chromium).
8. Pendrive pelo Dolphin.
9. PJeOffice com A1 e com o token, e o corte de vídeo por trechos.
10. Teams e compartilhamento de tela.

## Licença

[CC0 1.0 Universal](LICENSE): domínio público. Use à vontade.
