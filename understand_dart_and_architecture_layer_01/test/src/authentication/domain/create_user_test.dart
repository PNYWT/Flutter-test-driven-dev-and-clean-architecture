// What dose the class depend on - Ans AuthenticationRepository
// how can we create a fake version of the dependency e.g. mock response API - Ans Use Mocktail
// How do we control what our dependencies do - Ans Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/create_user.dart';
import 'authentication_repository.mock.dart';

// Target คือ ตรวจสอบว่า usecase(params) เรียก repository.createUser(...) ถูกต้อง ได้ตามผลที่คาดไว้
void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  // สร้าง mock repository และ usecase
  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUser(repository);
  });

  test("should call the [Repository.createUser]", () async {
    // Arrange
    // STUB (mock object)
    when(
      () => repository.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    ); // บอก mock ว่า “ถ้ามีคนเรียก method นี้” → ให้ตอบกลับ Right(null) ทันที

    const params = CreateUserParams.empty();
    // Act
    final result = await usecase(params);

    // Assert
    expect(
      result,
      equals(const Right<dynamic, void>(null)),
    ); // ตรวจว่า result ที่ได้จาก usecase เป็น Right(null) ตามที่คาดไว้
    verify(
      () => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      ),
    ).called(
      1,
    ); // ตรวจว่า method createUser() ถูกเรียกหนึ่งครั้งเท่านั้น และ parameter ที่ส่งตรงกับค่าจาก params
    verifyNoMoreInteractions(
      repository,
    ); // ตรวจว่า usecase ไม่เรียก method อื่นใน repository นอกเหนือจากที่เราทดสอบ
  });
}
