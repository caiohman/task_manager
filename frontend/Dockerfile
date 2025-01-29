FROM node:lts-alpine

# instala um servidor http simples para servir conteúdo estático
RUN yarn global add http-server

# faz da pasta 'app' o diretório atual de trabalho
WORKDIR /app

# copia os arquivos 'package.json'
COPY package.json ./

# instala dependências do projeto
RUN yarn install

# copia arquivos e pastas para o diretório atual de trabalho (pasta 'app')
COPY . .

# compila a aplicação de produção com minificação
RUN npx vite build

EXPOSE 8080
CMD [ "http-server", "dist" ]
