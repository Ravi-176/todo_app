import 'package:flutter/material.dart';

class ResponsiveHelper extends StatelessWidget{
  final Widget Function(BuildContext,BoxConstraints) builder;
  const ResponsiveHelper({super.key,required this.builder});
  @override
  Widget build(BuildContext context){
    return LayoutBuilder(builder:builder);
  }
}