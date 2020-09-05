// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;
//
// main() async {
//   var channel =
//       IOWebSocketChannel.connect("ws://wit-bot-server.herokuapp.com/");
//
//   channel.stream.listen((message) {
//     channel.sink.add("received!");
//     channel.sink.close(status.goingAway);
//   });
// }
// import 'package:web_socket_channel/io.dart';
//
// main() async {
//   var channel = IOWebSocketChannel.connect("ws://192.168.0.5:8000");
//   channel.sink.add("connected!");
//   channel.stream.listen((message) {
//     print(message);
//   });
// }
// import 'package:web_socket_channel/html.dart';
//
// main() async {
//   var channel = HtmlWebSocketChannel.connect("ws://127.0.0.1:8000");
//   channel.sink.add("connected!");
//   channel.stream.listen((message) {
//     print(message);
//   });
// }
