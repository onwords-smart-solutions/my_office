import 'package:my_office/features/home/domain/repository/home_repository.dart';

class GetRandomNumberCase{
  final HomeRepository homeRepository;

  GetRandomNumberCase({required this.homeRepository});

  int execute()  => homeRepository.getRandomNumber();
}