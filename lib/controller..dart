import 'utils/Dialogs.dart';
import 'repositories/audio_repository.dart';
import 'repositories/usuario_repository.dart';
import 'package:animationlogin2/utils/Session.dart';
import 'package:animationlogin2/widget/loading.dart';

final Session session = Session();
final Dialogs dialogs = Dialogs();
final LoadingWidgets loading = LoadingWidgets();
final UsuarioRepository usuarioRepository = UsuarioRepository();
final AudioRepository audioRepository = AudioRepository();