# Aria World — Vet Atlas completo em /atlas/

## O que está incluído
Esta integração usa **o código Next.js original do Vet Atlas** de Ketbome, com revisão fixada em `424cfcc9a559da87847575bbfb5c0e780847d25f`: os modelos GLB reais de cão, gato, bovino e equino (4 camadas cada), seleção por estruturas, rotação, zoom, isolação, explodir, pesquisa, doenças, referências, páginas, idiomas inglês/espanhol e navegação em dispositivos móveis. Não é uma reprodução esquemática.

A compilação exporta o Atlas como arquivos estáticos para `public/atlas/`. A identidade visual é ajustada via `aria-theme.css`; os modelos 3D e o conteúdo não são adulterados. O atual `public/index.html`, `public/assets/` e `functions/api/generate.js` continuam intactos, exceto por dois links adicionados à página inicial **após uma compilação completa bem-sucedida**.

## Fluxo de implantação
1. O GitHub Actions dispara quando a integração for adicionada à branch `main` ou manualmente em Actions.
2. Primeiro job: clona exatamente a revisão registrada, executa `pnpm install --frozen-lockfile` e `pnpm build` com `NEXT_PUBLIC_BASE_PATH=/atlas`, verifica os 16 modelos, empacota o site.
3. Segundo job: baixa o artefato, confirma páginas e modelos e só então adiciona `public/atlas/` e os links de navegação, com um único commit.
4. O Cloudflare Pages que publica a pasta `public` detecta esse commit e disponibiliza `/atlas/`.

A compilação usa o repositório original em um job com **permissão de leitura**. Somente o job posterior, que não executa dependências do Atlas, tem autorização para gravar o resultado no GitHub. Isso reduz exposição a scripts de terceiros.

### Se o Actions não puder gravar
Verifique GitHub → Settings → Actions → General → Workflow permissions → **Read and write permissions**. Não compartilhe tokens no chat. Caso seja necessária uma configuração adicional, o job falha sem alterar o site publicado.

## Atribuição e limitações
- Software do Vet Atlas: MIT.
- Textos próprios: Creative Commons CC BY-SA 4.0.
- Modelos e imagens de terceiros: licenças individuais, ver SOURCES.json e atribuições nas páginas.
- Materiais com limitação não comercial não podem ser usados comercialmente sem nova verificação.
- Há anatomia obtida de escaneamento, modelada e ilustrativa. **Não usar para diagnóstico ou planejamento cirúrgico de pacientes**.
- O Atlas não converte, por si só, TC/RM/ultrassom pessoais em modelos específicos do paciente.
- Nunca envie dados de pacientes sem desidentificação e controles apropriados.

## Atualizações / reversão
Para atualizar o Vet Atlas, revise licenças e alterações do upstream e mude deliberadamente o SHA em `build.sh`; execute o workflow novamente. Para reverter o Atlas, faça revert do commit do conteúdo gerado `public/atlas` e dos links no `public/index.html`. Não altere as chaves de armazenamento local dos flashcards.
