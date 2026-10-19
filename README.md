# zerocoderdodiddone

**DoDidDone** — менеджер задач на Flutter с Firebase: авторизация, облачные задачи
и напоминания.

A Flutter task manager backed by Firebase: auth, cloud tasks and reminders.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)

> UI-прототип без бэкенда: **[zc_dodiddone](../zc_dodiddone)**.
> The backend-free UI prototype: **[zc_dodiddone](../zc_dodiddone)**.

---

## 🇷🇺 Русский

### Описание

Полноценная версия приложения DoDidDone: задачи хранятся в Cloud Firestore
в персональной коллекции каждого пользователя, напоминания приходят через
локальные уведомления, аватар загружается в Firebase Storage.

### Возможности

- **Авторизация**: email + пароль и Google Sign-In (Firebase Auth),
  отправка письма для подтверждения почты, выход из аккаунта
- **Задачи в Firestore**: коллекция `tasks<uid>` — создание, редактирование,
  удаление, отметка выполнения
- **Три списка-вкладки** на стримах Firestore:
  - **Задачи** — все задачи,
  - **Сегодня** (`is_for_today`),
  - **Выполнено** (`completed`)
- **Напоминания**: отложенные локальные уведомления
  (`flutter_local_notifications` + `timezone`), запрос разрешения на Android 13+
- **Профиль**: аватар с камеры или из галереи (`image_picker`, сжатие до 50%),
  статус подтверждения почты
- **Тема**: переключение светлой/тёмной темы (`DoDidDoneTheme`)
- Диалог добавления задачи с выбором даты и времени дедлайна

### Технологии

- **Flutter**, Dart 3.4+
- [firebase_core](https://pub.dev/packages/firebase_core), [firebase_auth](https://pub.dev/packages/firebase_auth),
  [cloud_firestore](https://pub.dev/packages/cloud_firestore), [firebase_storage](https://pub.dev/packages/firebase_storage)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) + [timezone](https://pub.dev/packages/timezone)
- [image_picker](https://pub.dev/packages/image_picker), [intl](https://pub.dev/packages/intl),
  [build_runner](https://pub.dev/packages/build_runner) + [json_serializable](https://pub.dev/packages/json_serializable)

### Структура проекта

```
zerocoderdodiddone/
├── lib/
│   ├── main.dart                  # инициализация Firebase и уведомлений
│   ├── firebase_options.dart      # конфиг Firebase CLI
│   ├── app/app.dart               # MaterialApp, выбор экрана по авторизации, тема
│   ├── pages/
│   │   ├── login_page.dart        # вход / регистрация
│   │   ├── main_page.dart         # нижняя навигация
│   │   └── profile_page.dart      # обёртка профиля
│   ├── screens/                   # Задачи / Сегодня / Выполнено / Профиль
│   ├── services/
│   │   ├── firebase_auth.dart     # email + Google авторизация
│   │   ├── firebase_data_sevice.dart  # CRUD задач в Firestore
│   │   └── notification_sevrvice.dart # локальные уведомления по расписанию
│   ├── theme/theme.dart
│   ├── utils/image_picer_util.dart
│   └── widgets/                   # карточка задачи, диалоги
├── android/app/google-services.json
├── firebase.json
└── pubspec.yaml
```

### Запуск

1. Создайте свой проект в [Firebase Console](https://console.firebase.google.com),
   включите **Authentication** (Email/Google) и **Cloud Firestore**.
2. Замените `android/app/google-services.json` и `lib/firebase_options.dart`
   на данные своего проекта (`flutterfire configure`).
3. Соберите:

```bash
flutter pub get
flutter run
```

---

## 🇬🇧 English

### Overview

The full DoDidDone app: tasks live in Cloud Firestore in a per-user collection,
reminders arrive as local notifications, and the avatar is uploaded to Firebase Storage.

### Features

- **Auth**: email + password and Google Sign-In (Firebase Auth),
  verification email, sign out
- **Firestore tasks**: `tasks<uid>` collection — create, edit, delete, complete
- **Three stream-backed list tabs**:
  - **Tasks** — everything,
  - **Today** (`is_for_today`),
  - **Done** (`completed`)
- **Reminders**: scheduled local notifications
  (`flutter_local_notifications` + `timezone`), Android 13+ permission request
- **Profile**: avatar from camera or gallery (`image_picker`, 50% quality),
  email verification status
- **Theme**: light/dark toggle (`DoDidDoneTheme`)
- Add-task dialog with deadline date and time pickers

### Tech stack

- **Flutter**, Dart 3.4+
- [firebase_core](https://pub.dev/packages/firebase_core), [firebase_auth](https://pub.dev/packages/firebase_auth),
  [cloud_firestore](https://pub.dev/packages/cloud_firestore), [firebase_storage](https://pub.dev/packages/firebase_storage)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) + [timezone](https://pub.dev/packages/timezone)
- [image_picker](https://pub.dev/packages/image_picker), [intl](https://pub.dev/packages/intl),
  [build_runner](https://pub.dev/packages/build_runner) + [json_serializable](https://pub.dev/packages/json_serializable)

### Project structure

```
zerocoderdodiddone/
├── lib/
│   ├── main.dart                  # Firebase + notifications init
│   ├── firebase_options.dart      # Firebase CLI config
│   ├── app/app.dart               # MaterialApp, auth-based routing, theme
│   ├── pages/
│   │   ├── login_page.dart        # login / registration
│   │   ├── main_page.dart         # bottom navigation
│   │   └── profile_page.dart      # profile wrapper
│   ├── screens/                   # Tasks / Today / Done / Profile
│   ├── services/
│   │   ├── firebase_auth.dart     # email + Google auth
│   │   ├── firebase_data_sevice.dart  # Firestore task CRUD
│   │   └── notification_sevrvice.dart # scheduled local notifications
│   ├── theme/theme.dart
│   ├── utils/image_picer_util.dart
│   └── widgets/                   # task card, dialogs
├── android/app/google-services.json
├── firebase.json
└── pubspec.yaml
```

### Getting started

1. Create a project in [Firebase Console](https://console.firebase.google.com) and
   enable **Authentication** (Email/Google) and **Cloud Firestore**.
2. Replace `android/app/google-services.json` and `lib/firebase_options.dart`
   with your own project's config (`flutterfire configure`).
3. Build:

```bash
flutter pub get
flutter run
```
