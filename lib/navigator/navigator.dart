import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' as nav;

final navigationProvider = Provider((ref)=>(Navigator()));

class Navigator {

  navigateUsingPath(
      {required String path, required BuildContext context, Object? params}) {
    GoRouter.of(context).push(path, extra: params);
  }

  removeAllAndNavigate(
      {required BuildContext context, required String path, Object? params}) {
    GoRouter.of(context).go(path,extra: params);
  }

  removeCurrentAndNavigate(
      {required BuildContext context, required String path, Object? params}) {
    GoRouter.of(context).pushReplacement(path,extra: params);
  }


  removeTopPage({required BuildContext context}){
    GoRouter.of(context).pop();
  }

   removeDialog({required BuildContext context}){
    nav.Navigator.pop(context);
  }

  popUnTill({required BuildContext context,required String path})
  {
    GoRouter.of(context).popUntil(path, context);
  }

}

extension GoRouterEx on GoRouter {
  void popUntil(String path,BuildContext context) {
    final router = GoRouter.of(context);
    while (router.canPop() &&
        router.location() != path) {
      pop();
    }
  }
}

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}