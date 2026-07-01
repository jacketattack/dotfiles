# Future considerations: Java/Spring in Vim

Current setup (already done): jdtls via ALE's `eclipselsp` linter, Lombok
javaagent, completion, LSP keymaps (`gd`/`gr`/`K`/rename/organize
imports/code actions), and `mvn` compiler integration for compile
errors + quickfix (`<Leader>mc`/`mt`/`mr`). See `~/.vimrc` and
`~/.vim/compiler/mvn.vim`.

Below are candidate follow-ups, not yet installed.

## 1. Spring Tools 4 language server (STS4)

Official Spring/Broadcom project — the same engine VSCode's Spring Boot
extension uses. Runs as a *second* LSP alongside jdtls for the same
buffers.

- Gets you: `application.yml`/`.properties` key completion + validation,
  `@Value`/`@ConfigurationProperties` completion, bean reference checking.
- Closest match to IntelliJ Ultimate's Spring plugin.
- Effort: moderate — download the STS4 language server jar, add another
  ALE linter definition (or a second LSP client) that targets the same
  file types without conflicting with eclipselsp.
- Trust: high (official Spring/Broadcom project, actively maintained).

## 2. Breakpoint debugging (vimspector)

The biggest real capability gap vs. IntelliJ right now — jdtls gives
diagnostics/completion but no stepping through code.

- Plugin: `puremourning/vimspector` — the established Vim-native DAP
  (Debug Adapter Protocol) client.
- Pairs with `microsoft/java-debug`, the same Java debug adapter VSCode
  uses, distributed as a jdtls plugin jar.
- Gets you: real breakpoints, variable inspection, step over/into/out,
  call stack — IntelliJ's debugger.
- Effort: moderate-high — install vimspector, download java-debug jar,
  wire up a `.vimspector.json` launch config for the Spring Boot app
  (likely `mvn spring-boot:run` under a debug-enabled JVM, or attach to
  a `-agentlib:jdwp=...` process).
- Trust: high (vimspector is the most widely used Vim8/9 DAP client;
  java-debug is Microsoft's own VSCode Java debugger backend).

## 3. Test failures in quickfix

Right now `<Leader>mt` runs `mvn test` but failures just dump to the
terminal/Dispatch output — no jump-to-failure.

- Extend `~/.vim/compiler/mvn.vim` (or add a sibling `mvn-test.vim`
  compiler) with an errorformat that parses Surefire's `***FAILURES***`
  blocks and stack traces into quickfix entries with file:line.
- Effort: low-moderate — mostly errorformat pattern work, similar to
  what was done for compile errors. Surefire output includes full stack
  traces, so the pattern needs to pick the first project-relative frame
  rather than JDK internals.
- Trust: n/a (this would be a small hand-rolled compiler file, not a
  third-party plugin).

## 4. vim-dadbod / vim-dadbod-ui

Inline database access, given the project stack (Postgres + Spring Data
JPA + Flyway).

- Plugins: `tpope/vim-dadbod` (core) + `kristijanhusak/vim-dadbod-ui`
  (browsable sidebar UI).
- Gets you: run SQL against the dev Postgres instance, browse
  schema/tables, inspect data — without leaving Vim or opening a
  separate DB client.
- Effort: low — install both plugins via Pathogen, add a `db` connection
  string (e.g. pointing at the local/testcontainers Postgres).
- Trust: high (tpope is the same author as vim-fugitive/vim-surround,
  already in use; dadbod-ui is the de facto standard companion UI).

## 5. Smaller/optional

- **vim-rest-console** (`diepm/vim-rest-console`) — write and execute
  HTTP requests from a scratch buffer, equivalent to IntelliJ's `.http`
  scratch files. Useful for poking the Spring Boot REST endpoints
  directly.
- **yamllint via ALE** — jdtls doesn't validate YAML, so
  `application.yml` gets no linting today. ALE already supports
  `yamllint` as a linter; just needs the `yamllint` binary installed and
  `'yaml': ['yamllint']` added to `g:ale_linters`.
- **google-java-format / Spotless** — only relevant if the project
  itself adopts a formatter (e.g. via `spotless-maven-plugin` in
  `pom.xml`). ALE already ships a `google_java_format` fixer, ready to
  enable the moment the binary/plugin exists.
- **fzf.vim** — potential upgrade over the current CtrlP setup for
  fuzzy file/symbol search backed by ripgrep; not Java-specific, general
  QoL.
