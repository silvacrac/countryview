**DESAFIO**:  
**Desenvolva um cliente REST**
Desenvolva um cliente REST que nos permite obter e visualizar as informações de propriedades dos países presentes na API (https://restcountries.com) 
como nome,
capital, região,
sub-região, população,
área, fuso horário,
nome nativo e o link para visualizar a bandeira.

Implemente um mecanismo dentro do cliente REST para exportar as informações dos países para o formato XLS, CSV e XML.




**Solução Desenvolvida**

A solução foi desenvolvida utilizando Flutter e Dart, garantindo uma aplicação multiplataforma com uma interface moderna e responsiva.

Funcionalidades Implementadas

**Barra de Pesquisa:**

O cliente pode pesquisar qualquer país pelo nome.

Os países são listados de acordo com as letras digitadas.

**Slide Show Interativo:**

Permite navegar entre os países de forma intuitiva deslizando na tela.

**Detalhes dos Países:**

Cada país apresenta suas informações detalhadas.

Botão "Ver mais" para acessar detalhes adicionais.

Exportação de Dados:

As informações podem ser exportadas para os seguintes formatos:

XLS (Excel)

CSV (Comma Separated Values)

XML (Extensible Markup Language)

**Tecnologias Utilizadas**

Flutter: Para criação da interface de usuário responsiva.

Dart: Linguagem de programação para a lógica de negócio.

REST API: Consumo da API https://restcountries.com para obter os dados.

**Pacotes Utilizados:**

http para requisições HTTP.

excel para geração de arquivos XLS.

csv para exportação de dados em formato CSV.

xml para criação de documentos XML.

**Como Executar o Projeto**

**Primeiro garanta ter o ambiente flutter e dart instalado**

Clone o repositório:

**git clone  git remote add origin https://github.com/silvacrac/countryview.git**

Acesse a pasta do projeto:

**cd countryview**

Instale as dependências:

**flutter pub get**

Execute o projeto:
**flutter run**

