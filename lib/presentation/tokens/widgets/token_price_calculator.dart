import 'package:ceres_tools_app/core/assets/fonts/flaticon.dart';
import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/services/currency_service.dart';
import 'package:ceres_tools_app/core/style/app_colors.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/currency_format.dart';
import 'package:ceres_tools_app/core/utils/decimal_formatter.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/core/widgets/input_field.dart';
import 'package:ceres_tools_app/core/widgets/item_container.dart';
import 'package:ceres_tools_app/core/widgets/round_image.dart';
import 'package:ceres_tools_app/core/widgets/tokens_dialog.dart';
import 'package:ceres_tools_app/domain/models/token.dart';
import 'package:ceres_tools_app/presentation/tokens/tokens_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class TokenPriceCalculator extends StatefulWidget {
  final SizingInformation sizingInformation;
  final Function setShowTokenPriceCalculator;

  const TokenPriceCalculator({
    Key? key,
    required this.sizingInformation,
    required this.setShowTokenPriceCalculator,
  }) : super(key: key);

  @override
  State<TokenPriceCalculator> createState() => _TokenPriceCalculatorState();
}

class _TokenPriceCalculatorState extends State<TokenPriceCalculator> {
  final CurrencyService currencyService = Get.find<CurrencyService>();
  final TokensController controller = Get.find<TokensController>();

  late Map<String, dynamic> selectedCurrency;
  Token? firstToken;
  Token? secondToken;
  double result = 0;

  TextEditingController firstTokenController = TextEditingController();
  TextEditingController secondTokenController = TextEditingController();

  @override
  void initState() {
    selectedCurrency = currencyService.currencies[0];
    super.initState();
  }

  Map<String, dynamic> _calculateTokenPrice(
    String value,
    Token token,
    Token otherToken,
  ) {
    if (value.isNotEmpty) {
      String textFormatted = toNumericString(value, allowPeriod: true);
      final numberValue = double.parse(textFormatted);
      final valueInCurrency = numberValue * token.price!;
      final otherValue = (valueInCurrency / otherToken.price!).toString();

      return {
        'v': removeTrailingZeros(
          toCurrencyString(otherValue, mantissaLength: 10),
        ),
        'vInCurrency': valueInCurrency * selectedCurrency['rate']
      };
    }

    return {'v': '', 'vInCurrency': 0.0};
  }

  void _changeFirstToken(String token) {
    Token? t =
        controller.allTokens.firstWhereOrNull((t) => t.shortName == token);

    if (t != null && t != firstToken) {
      setState(() {
        firstToken = t;
      });

      if (secondToken != null) {
        final res = _calculateTokenPrice(
          secondTokenController.text,
          secondToken!,
          t,
        );

        firstTokenController.text = res['v'];

        setState(() {
          result = res['vInCurrency'];
        });
      }
    }
  }

  void _changeSecondToken(String token) {
    Token? t =
        controller.allTokens.firstWhereOrNull((t) => t.shortName == token);

    if (t != null && t != secondToken) {
      setState(() {
        secondToken = t;
      });

      if (firstToken != null) {
        final res = _calculateTokenPrice(
          firstTokenController.text,
          firstToken!,
          t,
        );

        secondTokenController.text = res['v'];

        setState(() {
          result = res['vInCurrency'];
        });
      }
    }
  }

  void _firstTokenValueChange(String text) {
    if (text.isNotEmpty) {
      if (firstToken != null && secondToken != null) {
        final res = _calculateTokenPrice(text, firstToken!, secondToken!);
        secondTokenController.text = res['v'];

        setState(() {
          result = res['vInCurrency'];
        });
      }
    } else {
      if (result != 0) {
        setState(() {
          result = 0;
        });
      }

      if (secondTokenController.text.isNotEmpty) {
        secondTokenController.clear();
      }
    }
  }

  void _secondTokenValueChange(String text) {
    if (text.isNotEmpty) {
      if (firstToken != null && secondToken != null) {
        final res = _calculateTokenPrice(text, secondToken!, firstToken!);
        firstTokenController.text = res['v'];

        setState(() {
          result = res['vInCurrency'];
        });
      }
    } else {
      if (result != 0) {
        setState(() {
          result = 0;
        });
      }

      if (firstTokenController.text.isNotEmpty) {
        firstTokenController.clear();
      }
    }
  }

  void _changeCurrency(Map<String, dynamic> currency) {
    firstTokenController.clear();
    secondTokenController.clear();

    setState(() {
      selectedCurrency = currency;
      if (result != 0) {
        result = 0;
      }
    });
  }

  @override
  void dispose() {
    firstTokenController.dispose();
    secondTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemContainer(
            sizingInformation: widget.sizingInformation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Convert token prices',
                      style: tokenPriceConverterTitleTextStyle(),
                    ),
                    Wrap(
                      spacing: 4.0,
                      children: currencyService.currencies.map((curr) {
                        return currencyButton(curr);
                      }).toList(),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMedium(),
                tokenInput(
                  firstTokenController,
                  firstToken != null,
                  controller.allTokens.where((t) => t != secondToken).toList(),
                  firstToken,
                  _changeFirstToken,
                  (String text) => _firstTokenValueChange(text),
                ),
                UIHelper.verticalSpaceSmall(),
                tokenInput(
                  secondTokenController,
                  secondToken != null,
                  controller.allTokens.where((t) => t != firstToken).toList(),
                  secondToken,
                  _changeSecondToken,
                  (String text) => _secondTokenValueChange(text),
                ),
                UIHelper.verticalSpaceMedium(),
                Text(
                  '${selectedCurrency['sign']}${formatToCurrency(result, showSymbol: false, decimalDigits: 3)}',
                  style: tokenPriceConverterPriceTextStyle(),
                ),
                UIHelper.verticalSpaceMediumLarge(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.DEFAULT_MARGIN_SMALL,
                        ),
                      ),
                    ),
                    child: Text(
                      'Return to token list',
                      style: buttonLightTextStyle(widget.sizingInformation),
                    ),
                    onPressed: () => widget.setShowTokenPriceCalculator(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget currencyButton(Map<String, dynamic> currency) {
    bool isSelected = selectedCurrency['sign'] == currency['sign'];

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          _changeCurrency(currency);
        }
      },
      child: Container(
        height: Dimensions.GRID_LODO,
        width: Dimensions.GRID_LODO,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? backgroundPink : Colors.white10,
        ),
        child: Center(
          child: Text(
            currency['sign'],
            style: tokenPriceConverterTitleTextStyle(),
          ),
        ),
      ),
    );
  }

  Widget tokenInput(
      TextEditingController textEditingController,
      bool enabled,
      List<Token> tokens,
      Token? token,
      Function onTokenSelect,
      Function(String) onChanged) {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.all(
        Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.dialog(
              TokensDialog(
                tokens: tokens,
                changeToken: (String t, [bool reloadWebView = false]) =>
                    onTokenSelect(t),
                sizingInformation: widget.sizingInformation,
                showAllTokensOption: false,
                showFavoriteTokensOptions: false,
              ),
              barrierDismissible: false,
            ),
            child: Container(
              height: double.infinity,
              alignment: Alignment.centerLeft,
              constraints: const BoxConstraints(minWidth: 120.0),
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: Dimensions.DEFAULT_MARGIN_EXTRA_SMALL,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius:
                      BorderRadius.circular(Dimensions.DEFAULT_MARGIN_SMALL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (token != null)
                      (Row(
                        children: [
                          RoundImage(
                            image:
                                '$kImageStorage${token.shortName}${token.imageExtension}',
                            size: Dimensions.ICON_SIZE,
                            extension: token.imageExtension,
                          ),
                          UIHelper.horizontalSpaceExtraSmall(),
                        ],
                      )),
                    Text(
                      token != null ? token.shortName! : 'Choose token',
                      style: tokenPriceConverterTokenTextStyle(),
                    ),
                    UIHelper.horizontalSpaceExtraSmall(),
                    const Icon(
                      Flaticon.arrowDown,
                      size: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
          UIHelper.horizontalSpaceSmall(),
          Expanded(
            child: InputField(
              hint: '0.0',
              enabled: enabled,
              controller: textEditingController,
              onChanged: onChanged,
              inputFormatters: [
                DecimalFormatter(),
              ],
              textInputType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
