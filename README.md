# Projeto Financeiro - Flutter FIAP

Este é um projeto Flutter para gerenciar transações financeiras, permitindo que os usuários filtrem transações por categoria e data, visualize gráficos e adicione transações.

## Funcionalidades

- Exibir lista de transações;
- Filtrar transações por categoria;
- Filtrar transações por intervalo de datas;
- Suporte a múltiplos métodos de pagamento;
- Gráfico de gastos;
- Análise Financeira;
- Login com Firebase;
- Dados de tela salvos no Firebase;

## Instalação

1. Clone o repositório:
```bash
   git clone https://github.com/sophiapaiao05/finance-project-flutter
```

2. Navegue até o diretório do projeto:
```bash
 cd finance-project-sophia-flutter
```

3. Instalar as dependências do Flutter:
```bash
flutter pub get
```
4. Execute o aplicativo:
```bash
flutter run
```

## Estrutura

- lib/: Contém o código fonte do aplicativo.
- main.dart: Ponto de entrada do aplicativo.
- home/: Contém a página inicial e seus componentes.
- transactions/: Contém a lógica e a interface de usuário para gerenciar transações.
- login/: Contém login do usuário.
- utils/: Contém utilitários e constantes usadas no aplicativo.

## Dependências
- provider: Gerenciamento de estado.
- Firebase services

## Configuração dos Emuladores do Firebase

Para configurar e iniciar os emuladores do Firebase no seu projeto, siga estas etapas:

### Inicializar os Emuladores do Firebase

1. No terminal, execute o comando para inicializar os emuladores:
```bash
   firebase init emulators
```

2. Durante a configuração, selecione os emuladores que deseja usar (Authentication).

3. Configure as portas para cada emulador conforme necessário.

```json
{
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "host": "localhost",
      "port": 8081
    },
    "ui": {
      "enabled": true,
      "port": 4000
    }
  }
}
```

###  Iniciar os Emuladores
No terminal, execute o comando para iniciar os emuladores:
```bash
firebase emulators:start
```