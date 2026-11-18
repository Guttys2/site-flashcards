# Vetly Studio — GitHub + Cloudflare Pages (duas pessoas)

O repositório original continua com `index.html`, `manifest.json`, `sw.js` e o ícone intactos. O **novo site** está em `public/`, com IA segura em `functions/api/generate.js`.

## Publicar o novo site

1. Revise e faça merge do PR que adiciona `public/` e `functions/` à branch main.
2. Na [Cloudflare](https://dash.cloudflare.com/), abra **Workers & Pages → Create → Pages → Connect to Git**. Autorize o repositório `Guttys2/site-flashcards` e a branch `main`.
3. Escolha framework **None**, **Root directory** = raiz do repositório, **Build command** vazio e **Build output directory** = `public`.
4. Depois do primeiro deploy, abra **Settings → Variables and Secrets**, ambiente de **produção**. Cadastre **como secrets**:
   - `OPENAI_API_KEY`: chave do projeto criado na OpenAI Platform
   - `VETLY_ACCESS_TOKEN_1`: código privado para a pessoa 1
   - `VETLY_ACCESS_TOKEN_2`: código privado diferente para a pessoa 2
5. Gere dois códigos aleatórios com pelo menos 32 caracteres de alta entropia (por exemplo, no Node.js: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"` executado duas vezes). **Não os envie ao chat nem coloque no GitHub**.
6. Reimplante o site depois de cadastrar os segredos. Acesse o endereço `https://NOME.pages.dev`, clique em **Criar flashcards → IA com pesquisa** e informe o seu código privado. A segunda pessoa usa o outro código.
7. Verifique gastos, alertas e limites do projeto OpenAI. A API é cobrada separadamente do ChatGPT; esta função não tem quota global de dinheiro ou requisições.

## Segurança, conteúdo e dados

- O GitHub só contém código público. Nunca adicione arquivos `.env` ou `.dev.vars` com valores reais.
- A IA requer autorização por um dos dois códigos. Os códigos não são salvos pelo site; são digitados a cada abertura.
- O servidor não salva o resumo; ele o envia à OpenAI apenas após a autorização e o clique em **Gerar**.
- A pesquisa web ajuda a encontrar fontes, mas **não garante que o conteúdo seja correto**. Revise e marque cada resposta antes de salvá-la.
- Os flashcards e o progresso ficam no **localStorage de cada navegador**. Os dois usuários **não sincronizam os cartões** entre si.
- O antigo GitHub Pages pode continuar mostrando a versão antiga. A versão com IA funciona no endereço Cloudflare Pages.
- Antes de sair do navegador antigo, use **Exportar JSON** para garantir que seus cartões adicionados manualmente não sejam perdidos.

## Estrutura

```
public/
  index.html
  assets/style.css
  assets/app.js
  _routes.json
functions/
  api/generate.js
.gitignore
README.md
```

Para testar gratuitamente o visual, abra `public/index.html`. A IA só responderá após configurar os segredos e publicar na Cloudflare Pages.
