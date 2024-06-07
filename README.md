<h2>Tópicos 📋</h2>

   <p>

   - [📖 Descrição do projeto](#-descrição)
   - [📱 Preview](#-preview)
   - [🛠️ Funcionalidades](#%EF%B8%8F-funcionalidades)
   - [🏦🎲 Estrutura do Banco de Dados](#-estrutura-do-banco-de-dados)
   - [🤔 Como usar](#-como-rodar-e-testar-o-projeto)
   </p>

---

<h2>📖 Descrição</h2>
Este projeto é um aplicativo CRUD (Create, Read, Update, Delete) desenvolvido em Flutter, conectado a um banco de dados SQLite. O aplicativo permite a criação, leitura, atualização e exclusão de itens, além de oferecer pesquisas interativas e a opção de exportar dados para um arquivo CSV.

<h2>📱 Preview</h2>

https://github.com/ArtthSilva/receitinhas/assets/113397588/6927c177-fd3a-4c6d-9621-7216167b8eee



<h2>🛠️ Funcionalidades</h2>

- **CRUD Completo**: Permite criar, ler, atualizar e deletar itens.
- **Pesquisa Interativa**: Permite filtrar itens por categoria.
- **Exportação de Dados**: Exporta os dados para um arquivo CSV.
- **Atualização Automática de Timestamps**: Mantém o registro de quando cada item foi criado e atualizado pela última vez.

<h2>🎲 Estrutura do Banco de Dados</h2>

A tabela `items` contém as seguintes colunas:
- `id` (INTEGER, PRIMARY KEY)
- `title` (TEXT)
- `category` (TEXT)
- `value` (TEXT)
- `createdAt` (TIMESTAMP, não nulo, padrão CURRENT_TIMESTAMP)
- `updatedAt` (TIMESTAMP)

### Trigger

Um trigger é usado para atualizar a coluna `updatedAt` sempre que um registro é atualizado:

```sql
CREATE TRIGGER update_updatedAt
AFTER UPDATE ON items
FOR EACH ROW
BEGIN
  UPDATE items SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;


   ```
---

<h2>🤔 Como rodar e testar o projeto</h2>

   ```
   Configure o ambiente de desenvolvimento na sua máquina:
   https://flutter.dev/docs/get-started/install


   - Clone o repositório:
   $ git clone https://github.com/ArtthSilva/crud_bd_avancado.git crudbd

   - Entre no diretório:
   $ cd crudbd

   - Instale as dependências:
   $ flutter pub get

   - Execute:
   $ flutter run

- Deve ser realizado usando Dart/Flutter na versão 3.16 ou superior.
   ```


---
