import 'package:flutter/cupertino.dart';

import '../../core/field_callback.dart';
import 'package:data_forms/gs_form/model/state_manager.dart';

abstract class NotifiableStatefulWidget extends StatefulWidget
    implements GSFieldCallBack {

  const NotifiableStatefulWidget({super.key});
}
