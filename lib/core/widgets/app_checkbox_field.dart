import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Checkbox with a tappable label that takes part in [Form] validation
/// (e.g. "I agree to the terms"). Without [validator] it is a plain
/// checkbox row (e.g. "Remember me").
class AppCheckboxField extends FormField<bool> {
  AppCheckboxField({
    super.key,
    required Widget label,
    bool initialValue = false,
    ValueChanged<bool>? onChanged,
    super.validator,
  }) : super(
         initialValue: initialValue,
         builder: (state) {
           final theme = Theme.of(state.context);
           void toggle() {
             final next = !(state.value ?? false);
             state.didChange(next);
             onChanged?.call(next);
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               MergeSemantics(
                 child: InkWell(
                   onTap: toggle,
                   borderRadius: BorderRadius.circular(AppRadius.sm),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(
                       vertical: AppSpacing.space1,
                     ),
                     child: Row(
                       children: [
                         Checkbox(
                           value: state.value ?? false,
                           onChanged: (_) => toggle(),
                           activeColor: AppColors.primary,
                           side: BorderSide(
                             color: state.hasError
                                 ? AppColors.error
                                 : AppColors.neutral400,
                             width: 1.5,
                           ),
                         ),
                         const SizedBox(width: AppSpacing.space1),
                         Expanded(
                           child: DefaultTextStyle.merge(
                             style: theme.textTheme.bodyMedium,
                             child: label,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsetsDirectional.only(
                     start: AppSpacing.space3,
                   ),
                   child: Text(
                     state.errorText!,
                     style: theme.textTheme.bodySmall?.copyWith(
                       color: AppColors.error,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}
