import 'package:flutter/cupertino.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/model/state_manager.dart';

abstract class NotifiableStatefulWidget extends StatefulWidget
    implements FormFieldCallBack {
  const NotifiableStatefulWidget({super.key});
}
