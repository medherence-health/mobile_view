import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants_utils/color_utils.dart';
import '../../../core/model/models/notification_model.dart';
import '../../../core/model/simulated_data/simulated_values.dart';
import '../view_model/notification_model.dart';
import '../widget/notify_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationViewModel model;
  @override
  void initState() {
    super.initState();
    final notificationList =
        Provider.of<NotificationModelItems>(context, listen: false)
            .notificationItemList;
    model = NotificationViewModel(notificationList);
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationModel> unreadNotifications = model.notificationList!
        .where((notification) => !notification.read)
        .toList();
    List<NotificationModel> readNotifications = model.notificationList!
        .where((notification) => notification.read)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: model.notificationList!.isEmpty
              ? Center(
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          color: Colors.grey,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'You have no notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: unreadNotifications.isNotEmpty,
                      child: Text(
                        'Unread',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: unreadNotifications.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: unreadNotifications.length,
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(
                              height: 13,
                            );
                          },
                          itemBuilder: (context, index) {
                            return NotificationContainer(
                              key: Key(unreadNotifications[index]
                                  .hashCode
                                  .toString()),
                              notification: unreadNotifications[index],
                              onPressed: () {
                                // Handle notification tap
                              },
                              direction: DismissDirection.endToStart,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Visibility(
                      visible: readNotifications.isNotEmpty,
                      child: Text(
                        'Read',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: readNotifications.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: readNotifications.length,
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(
                              height: 13,
                            );
                          },
                          itemBuilder: (context, index) {
                            return NotificationContainer(
                              key: Key(
                                  readNotifications[index].hashCode.toString()),
                              notification: readNotifications[index],
                              onPressed: () {
                                // Handle notification tap
                              },
                              direction: DismissDirection.endToStart,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
