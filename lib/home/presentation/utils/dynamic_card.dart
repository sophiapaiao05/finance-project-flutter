import 'package:finance_project_sophia_flutter/utils/app_sizes.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class DynamicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const DynamicCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.all(AppSizes.marginLarge),
    this.padding = const EdgeInsets.all(AppSizes.paddingLarge),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: FinanceProjectColors.deepBlue,
      margin: margin,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
