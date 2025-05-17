import 'package:flutter/cupertino.dart';

import 'package:data_forms/core/field_callback.dart';

abstract class NotifiableStatefulWidget<T> extends StatefulWidget
    implements FormFieldCallBack<T> {
  const NotifiableStatefulWidget({super.key});
}
