# rom

CLI em Python pra achar e baixar ROMs, ISOs e jogos de Switch pelo terminal.
Tem UI interativa (Textual) igual ao `epub-search`, busca por nome, download com
barra de progresso e pasta organizada por plataforma.

## Requisitos

- Python 3.8+
- macOS ou Linux
- `textual` (o `install.sh` instala num venv próprio)

## Instalação

```bash
git clone git@github.com:sostenesapollo/rom-cli.git
cd rom-cli
./install.sh
```

Cria o venv em `~/.venvs/rom`, instala o `textual` e publica `rom` (e `rom-remote`)
em `~/bin`. Use `PREFIX=/usr/local ./install.sh` pra outro destino.

## Uso

```bash
rom                          # abre o seletor de plataforma e navega
rom -p switch                # já abre navegando o catálogo de Switch
rom -p switchports           # só os ports/homebrew de Switch
rom "metroid"                # busca em todas as fontes
rom -y -p gba "pokemon"      # baixa o melhor sem perguntar
rom --list "metroid"         # só lista, não baixa
rom --print-url -p switch …  # mostra o link direto (aria2/curl)
rom -l                       # lista as plataformas
rom --index                  # monta/mostra o índice do catálogo
rom --refresh                # reconstrói o índice (ignora cache)
```

Sem query o `rom` abre o **seletor de plataforma**; escolhendo uma, ele lista o
catálogo inteiro daquela plataforma (páginas de 300, `n`/`b` pra andar) — dá pra
navegar sem digitar nada. Digitar no campo e `Enter` volta a buscar.

Na UI: `↑↓` navega, `espaço` marca, `d` baixa (marcados ou o atual), `p` troca de
plataforma, `n`/`b` página, `ctrl+b` paleta de opções, `ctrl+a` marca tudo, `ctrl+n`
limpa, `q` sai.

| Flag | Descrição |
|------|-----------|
| `-p, --platform` | plataforma (switch, snes, gba, ps2, nds, wii…) |
| `-y, --yes` | baixa o melhor sem menu |
| `--list` | apenas lista |
| `--print-url` | só resolve e imprime o link direto |
| `--refresh` | reconstrói o índice do catálogo |
| `--index` | baixa/mostra o índice e sai |
| `-n, --number` | quantos resultados mostrar (padrão 15) |
| `-o, --out` | pasta de destino (padrão `~/Downloads/roms` ou `$ROM_DIR`) |
| `-l, --platforms` | lista plataformas |

Plataformas: `switch`, `switchports`, `ps5`, `ps4`, `ps3`, `psv`, `ps2`, `ps1`,
`psp`, `nds`, `gba`, `snes`, `pc`, `nes`, `gb`, `gbc`, `n64`, `3ds`, `gc`, `wii`,
`genesis`, `mastersystem`, `dreamcast`, `saturn`, `arcade`.

Os arquivos vão para `~/Downloads/roms/<plataforma>/`.

## Como funciona

- **Switch**: índice do dlarchive (`files_api.php`). A página do nsp-roms embute
  links com token que expira; aqui o `rom` resolve pelo índice e pega uma URL
  direta e sem token. Funciona também pra NDS, GBA, SNES e PC.
- **Ports de Switch**: homebrew/ports pra Switch (GTA, Halo, Twilight Princess etc.)
  saem com tipo `Port` e ficam na plataforma `switchports`.
- **PS3 e PS Vita**: NoPayStation — baixa `.pkg` direto do CDN da Sony
  (`zeus.dl.playstation.net`), sem token.
- **PS2, PS1 e PSP**: RomsGames (busca + POST que devolve o arquivo).
- **PS4 e PS5**: dlpsgame (busca via WP REST). O download direto sai quando o
  post tem link de host suportado (mediafire, Google Drive, 1fichier); quando
  não tem, o `rom` mostra a página pra pegar o link.
- **Melhores primeiro**: ao navegar uma plataforma, os mais vendidos (listas da
  Wikipedia, cache de 30 dias) aparecem primeiro com ★; o resto em ordem alfabética.
  Plataformas sem listagem completa (PS4/PS5) navegam pela própria lista de melhores.
- **Fallback**: Archive.org nas plataformas com pouca oferta.
- Índice do catálogo em cache (`~/.cache/rom-cli/dlarchive.json`, TTL 12h) —
  deixa a busca instantânea. `--refresh` reconstrói.
- Ranking por correspondência de título, penalidade pra hacks/traduções/betas e
  preferência por `Base` sobre `Update`/`DLC`.
- Valida o arquivo antes de gravar (zip, 7z, `PFS0` de `.nsp` e `PKG`/`CNT` de
  `.pkg`).
- Download com retomada (`.part` + `Range`).

## Modo remoto (`rom-remote`)

Roda no Mac worker (`ssh mac`) e traz os arquivos de volta. Útil quando a rede
deste Mac bloqueia os hosts de download.

```bash
rom-remote -p switch "mario kart"    # abre a UI no worker
rom-remote -y -p snes "metroid"      # baixa lá e sincroniza pra cá
```

Ajuste com `ROM_REMOTE_HOST`, `ROM_REMOTE_DIR` e `ROM_DIR`.

## Aviso

Use só o que você tem direito.
