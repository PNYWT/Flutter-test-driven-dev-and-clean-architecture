#Section 1 Understand Dartz Type Either and Architecture Layer

- Core
  - errors (dynamic)
  - usecase (dynamic)
  - utilis
- Domain Layer
  - Entities
  - repositories
  - usecases

#Section 2 Create and understand test

- Unit Test -> usecase
- Arrange → Act → Assert

#Section 3 Data layer and test

- Model
- Unit Test -> model
- RepositoryImplementation

#Section 4 Repository and Authentication

- Unit Test -> RepositoryImplementation

#Section 5 DataSource - HTTP layer and test

- AuthenticationRemoteDataSource and AuthenticationRemoteDataSourceImpl
- Unit Test -> AuthenticationRemoteDataSourceImpl
  - createUser Sucessful and Error
  - getUsers Successful and Error

#Section 6 Presentation layer and bloc and usecase

- BLoC and Cubit
- Unit Test -> Cubit

#Section 7 Dependency Injection
