import 'package:car_repair_service/login/login.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChangeAuthStatus {
  final AuthStatus payload;

  ChangeAuthStatus(this.payload);
}

class UpdateUser {
  final FirebaseUser payload;

  UpdateUser(this.payload);
}

class UpdateUserInfo {
  final UserInfo payload;

  UpdateUserInfo(this.payload);
}

class CreateUserInfo {
  final UserInfo payload;

  CreateUserInfo(this.payload);
}

enum Statuses {
  Accepted,
  Paid,
  InProgress,
  Done,
}

class Status {
  Statuses status;

  Status(this.status);

  Status.fromString(String s) {
    switch (s) {
      case "accepted":
        {
          this.status = Statuses.Accepted;
          break;
        }
      case "in_progress":
        {
          this.status = Statuses.InProgress;
          break;
        }
      case "paid":
        {
          this.status = Statuses.Paid;
          break;
        }
      case "done":
        {
          this.status = Statuses.Done;
          break;
        }
    }
  }

  text() {
    switch (this.status) {
      case Statuses.Accepted:
        return "Принят в обработку";
      case Statuses.InProgress:
        return "В работе";
      case Statuses.Paid:
        return "Оплачен";
      case Statuses.Done:
        return "Выполнено";
    }
  }

  toJson() {
    switch (this.status) {
      case Statuses.Accepted:
        return "accepted";
      case Statuses.InProgress:
        return "in_progress";
      case Statuses.Paid:
        return "paid";
      case Statuses.Done:
        return "done";
    }
  }

  icon() {
    switch (this.status) {
      case Statuses.Accepted:
        return Icons.hourglass_empty;
      case Statuses.InProgress:
        return Icons.timer;
      case Statuses.Paid:
        return Icons.attach_money;
      case Statuses.Done:
        return Icons.done;
    }
  }

  color() {
    switch (this.status) {
      case Statuses.Accepted:
        return Colors.deepOrange;
      case Statuses.InProgress:
        return Colors.orangeAccent;
      case Statuses.Paid:
        return Colors.green.shade300;
      case Statuses.Done:
        return Colors.green;
    }
  }
}

class OrderWork {
  String key;
  String orderID;
  double price;
  String name;

  int count;

  OrderWork({this.orderID, this.price, this.name, this.count});

  OrderWork.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        orderID = snapshot.value["order_id"],
        price = double.parse(snapshot.value["price"].toString()),
        count = int.parse(snapshot.value["count"].toString()),
        name = snapshot.value["name"];

  toJson() {
    return {
      "order_id": orderID,
      "price": price,
      "name": name,
      "count": count,
    };
  }
}

class OrderMaterial {
  String key;
  String orderID;
  double price;
  String name;
  int count;

  OrderMaterial({this.orderID, this.price, this.name, this.count});

  OrderMaterial.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        orderID = snapshot.value["order_id"],
        price = double.parse(snapshot.value["price"].toString()),
        count = int.parse(snapshot.value["count"].toString()),
        name = snapshot.value["name"];

  toJson() {
    return {
      "order_id": orderID,
      "price": price,
      "name": name,
      "count": count,
    };
  }
}

class Order {
  String key;
  String userID;
  DateTime date;
  String text;
  Status status;

  Order({this.userID, this.date, this.text, this.status}) {
    if (this.status == null) {
      this.status = Status(Statuses.Accepted);
    }
  }

  Order.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userID = snapshot.value["user_id"],
        date = DateTime.fromMillisecondsSinceEpoch(snapshot.value["timestamp"]),
        status = Status.fromString(snapshot.value["status"]),
        text = snapshot.value["text"];

  toJson() {
    return {
      "user_id": userID,
      "timestamp": date.millisecondsSinceEpoch,
      "text": text,
      "status": status.toJson(),
    };
  }
}

class UserInfo {
  String key;
  String userID;
  String email;
  String name;

  String surname;

  String phone;

  UserInfo({this.userID, this.email, this.name, this.surname, this.phone});

  UserInfo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userID = snapshot.value["user_id"],
        email = snapshot.value["email"],
        name = snapshot.value["name"],
        surname = snapshot.value["surname"],
        phone = snapshot.value["phone"];

  toJson() {
    return {
      "user_id": userID,
      "email": email,
      "surname": surname,
      "name": name,
      "phone": phone,
    };
  }
}

class AppState {
  final db = FirebaseDatabase.instance.reference();
  BaseAuth auth;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  FirebaseUser user;
  UserInfo userInfo;

  AppState(BaseAuth auth) {
    if (this.auth == null) {
      this.auth = new Auth();
    }
  }
}

AppState counterReducer(AppState store, dynamic action) {
  if (action is ChangeAuthStatus) {
    store.authStatus = action.payload;
  } else if (action is UpdateUser) {
    store.user = action.payload;
  } else if (action is CreateUserInfo) {
    saveUserInfo(action.payload, store.db);
    store.userInfo = action.payload;
  } else if (action is UpdateUserInfo) {
    store.userInfo = action.payload;
  }
  return store;
}
