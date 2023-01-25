import 'dart:io';

void main(List<String> args) {
  String? num;

  do {
    print('escreva o numero de telefone ou escreva "0" para encerrar: ');
    num = stdin.readLineSync();
    if (num != null && num.isNotEmpty && num != '0') {
      Process.start(
        'start',
        ['https://api.whatsapp.com/send?phone=55$num'],
        runInShell: true,
      );
      num = "0";
    }
  } while (num == null || num.isEmpty || num != '0');
}
