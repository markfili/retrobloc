# retrobloc

From Bloc to network and back.

# Contains

- Flutter Bloc
- Retrofit
- JSON serialization
- Equatable
- Flutter bloc with context.watch/select/read
- Logger
- Pretty Dio Logger (interceptor)
- Another Flushbar (wacky Snackbar)
- Refresh indicator
- API Error handling
- Liquid Pull to refresh

# TODO

- dependency injection
- project structure

# Notes

After adding a new class annotated with `@JsonSerializable` run:
```
    flutter pub run build_runner build
```

API Error handling inspired by:
- [handling-network-calls-and-exceptions-in-flutter, Ashish Rawat](https://dev.to/ashishrawat2911/handling-network-calls-and-exceptions-in-flutter-54me)
- [android-error-handling-in-clean-architecture, Duy Pham](https://proandroiddev.com/android-error-handling-in-clean-architecture-844a7fc0dc03)
- [retrofit.dart docs](https://github.com/trevorwang/retrofit.dart#error-handling)
- [ApiResultInterceptor example](https://gist.github.com/ipcjs/c0896bf90effe955a863ed9813d006c5)
- [GeekySingh/flutter_stacked_architecture_with_retrofit](https://github.com/GeekySingh/flutter_stacked_architecture_with_retrofit/blob/master/lib/common/network/result.dart)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
