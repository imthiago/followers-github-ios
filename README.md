# Followers on GitHub

Projeto desenvolvido a nível de um case para apresentação. 
O propósito funcional do projeto é obter os seguidores de um determinado perfil no GitHub, listando em uma CollectionView seus seguidores com login e foto de perfil.
Para o feedback das ações do usuário, foi desenvolvido um modal customizado para evitar o uso do componente padrão do iOS.
Além disso, estão presentes as seguintes funcionalidades:

- Listar seguidores por perfil
- Adicionar um perfil como **favorito**
- Exibir a lista de favoritos salvos anteriormente
- Visualizar os dados do usuário:
		-	Login
		-	Nome Completo
		-	Localização
		-	Bio
		-	Quantidade de repositórios públicos
		-	Quantidade de gists públicos
		-	Quantidade de seguidores
		-	Quantidade de perfis seguidos
		-	Data de criação do perfil		
-	Visualizar o perfil completo deste usuário utilizando Safari (através do botão "Github Profile")
-	Visualizar a lista de seguidores do perfil
## Gestão de Dependências
Foi utilizado cocoapods para fazer gestão de dependências terceiras.
Este utiliza apenas duas dependências de terceiros. Sendo elas:

- Swiftlint
		- Para garantir a legibilidade mínima de código, assim como convenções e boas práticas da linguagem Swift
- Resolver
		- Para realizar a injeção de dependências nas classes do projeto (serviços, use cases, repositórios, etc)
			- ** Obs.: Para este projeto, o Resolver foi utilizado somente para injeção da classe NetworkService (responsável por fazer as requisições externas.

## Iniciando o projeto
Primeiramente, é necessário ter o cocoapods instalado localmente.
A partir disso, navegue até o diretório ../followers-github-ios/FollowersGitHubiOS e execute o comando **pod install**.
Aguarde a instalação das dependências e abra o arquivo com extensão **.xcworkspace**

## Próximos passos
Modificar a estrutura do projeto seguindo o padrão MVVM utilizando Combine ou RxSwift para o binding de dados entre view e viewmodels.
Adicionar Coordinator para garantir os fluxos entre telas, incluindo os delegates já criados atualmente. Provendo assim uma maior testabilidade na camada de apresentação.
Adição de testes de snapshot. Uma vez que o projeto não possui tanta lógica envolvida, seja uma maneira de garantir a permanência do design das views.
Adição de testes unitários serviços de networking e user defaults. Seria possível encapsular a execução de ambos e melhorar a testabilidade de código com mocks.

## Demonstração

![](https://github.com/imthiago/followers-github-ios/blob/main/demo.gif)

```