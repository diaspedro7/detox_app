import 'package:detox_app/features/permission/viewmodel/permission_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../detox/screens/home/home_page.dart';
import '../ask_permission/pedir_permissao_page.dart';

class VerificaPermissaoPage extends StatefulWidget {
  const VerificaPermissaoPage({super.key});

  @override
  State<VerificaPermissaoPage> createState() => _VerificaPermissaoPageState();
}

class _VerificaPermissaoPageState extends State<VerificaPermissaoPage> {
  bool? verificaPermisao;
  bool? verificaPermisaoObterDados;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PermissionViewModel>(context, listen: true);

    return (controller.isBothPermissionsAccepted() == true
        ? const HomePage()
        : const PedirPermissaoPage());
  }
}
