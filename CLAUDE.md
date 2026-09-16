# Instruções do projeto — watts-up-coach

Databricks Asset Bundle. Leia este arquivo antes de qualquer alteração.

## 1. Escopo de alteração

- Alterar apenas arquivos dentro da pasta do projeto.
  Referência na máquina local: `C:\Users\gmelo7\Documents\Gustavo - Estudos`.
  Em sessão remota, equivale ao diretório do repositório clonado.
- Escrever fora dessa pasta exige permissão explícita, pedida antes.

## 2. Ações destrutivas

Exigem autorização explícita, caso a caso. Nunca pré-aprovadas:

- `git push --force`, reescrita de histórico, `git reset --hard`
- deletar arquivos, branches ou tags
- `databricks bundle destroy`, remover jobs, clusters ou schemas
- alterar `targets`, `host` ou `service_principal_name` em `databricks.yml`
- rodar deploy em `qa` ou `prod`
- criar tag de versão

## 3. Idioma

- Documentação em inglês: README, CHANGELOG, docstrings, comentários de código,
  título e descrição de PR, mensagens de commit.
- Conversa com o usuário: português.

## 4. Versionamento (semver x.y.z)

- Fonte da versão: `CHANGELOG.md` (formato Keep a Changelog) + tag git `vX.Y.Z`.
- MAJOR: quebra de contrato (schema de tabela, interface de job).
- MINOR: novo job, notebook ou feature retrocompatível.
- PATCH: correção sem mudança de contrato.

## 5. Fluxo de branches

- `develop` → `qa` → `main`, espelhando `deploy-dev.yml`, `deploy-qa.yml`, `deploy-prod.yml`.
- Trabalho novo sai de `develop`.
- PR sempre em draft.
- `pr-validate.yml` escolhe o target pela branch base — validar localmente no mesmo target.

## 6. Commits

- Convencionais: `feat:`, `fix:`, `chore:`, `docs:`, `ci:`, `refactor:`, `test:`.
- Mensagem em inglês, imperativo.
- Uma mudança lógica por commit.

## 7. Databricks

- Antes de commitar mudança em `databricks.yml` ou em assets:
  `databricks bundle validate -t dev`.
- Nunca commitar credenciais. Autenticação vem de secrets do GitHub Actions.
- Não editar `.github/workflows/` sem confirmar com o usuário.

## 8. Como trabalhar comigo

- Etapas curtas: propor, validar, avançar. Não emendar várias mudanças sem checagem.
- Código em blocos pequenos, um assunto por vez.
- Respostas sucintas.
