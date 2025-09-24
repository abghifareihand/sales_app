import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  const BaseView({
    super.key,
    required this.builder,
    required this.model,
    required this.onModelReady,
    required this.onModelDispose,
    this.child,
  });

  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T model;
  final Function(T) onModelReady;
  final Function(T) onModelDispose;
  final Widget? child;

  @override
  BaseViewState<T> createState() => BaseViewState<T>();
}

class BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    widget.onModelReady(model);
  }

  @override
  void dispose() {
    widget.onModelDispose(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (BuildContext context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}