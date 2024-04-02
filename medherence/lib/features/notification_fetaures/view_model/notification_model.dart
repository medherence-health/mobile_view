import 'package:stacked/stacked.dart';

import '../../../core/model/models/notification_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';

class NotificationViewModel extends BaseViewModel {
  final List<NotificationModel> _listNotification = notificationLists;
  List<NotificationModel>? get notificationList {
    return _listNotification;
  }
}
