import 'package:ceres_locker_app/core/style/app_text_style.dart';
import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/utils/ui_helpers.dart';
import 'package:ceres_locker_app/core/widgets/item_container.dart';
import 'package:ceres_locker_app/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class FaqsItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function scrollToSelectedContent;

  const FaqsItem({Key? key, required this.item, required this.scrollToSelectedContent}) : super(key: key);

  @override
  _FaqsItemState createState() => _FaqsItemState();
}

class _FaqsItemState extends State<FaqsItem> with SingleTickerProviderStateMixin {
  final GlobalKey _expansionTileKey = GlobalKey();
  AnimationController? _controller;
  Animation<double>? _iconTurns;
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  bool open = false;

  @override
  void initState() {
    const Duration _kExpand = Duration(milliseconds: 200);
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _iconTurns = _controller?.drive(_halfTween.chain(_easeInTween));

    super.initState();
  }

  void _handleTap(bool value) {
    setState(() {
      if (value) {
        _controller?.forward();
        widget.scrollToSelectedContent(_expansionTileKey);
        open = true;
      } else {
        _controller?.reverse();
        open = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      builder: (context, sizingInformation) {
        return ItemContainer(
          sizingInformation: sizingInformation,
          smallMargin: true,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.all(Dimensions.DEFAULT_MARGIN_SMALL),
              key: _expansionTileKey,
              onExpansionChanged: (value) => _handleTap(value),
              initiallyExpanded: false,
              trailing: Container(
                constraints: const BoxConstraints(
                  maxWidth: Dimensions.ROW_TRAILING_MAX_WIDTH,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UIHelper.horizontalSpaceExtraSmall(),
                    RotationTransition(
                      turns: _iconTurns!,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: Dimensions.ICON_SIZE,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                widget.item['question'],
                style: faqsTitleStyle(sizingInformation),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Text(
                  widget.item['answer'],
                  style: faqsDescriptionStyle(sizingInformation),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
