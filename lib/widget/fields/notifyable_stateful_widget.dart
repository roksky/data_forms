import 'package:flutter/cupertino.dart';

import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/model/state_manager.dart';

abstract class NotifiableStatefulWidget<T> extends StatefulWidget
    implements FormFieldCallBack<T> {
  const NotifiableStatefulWidget({super.key});
}
