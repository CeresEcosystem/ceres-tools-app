import 'package:ceres_tools_app/core/constants/constants.dart';
import 'package:ceres_tools_app/core/style/app_text_style.dart';
import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/utils/sizing_information.dart';
import 'package:ceres_tools_app/core/utils/ui_helpers.dart';
import 'package:ceres_tools_app/presentation/tracker/widgets/faqs_item.dart';
import 'package:flutter/material.dart';

const _faqs = [
  {
    'question': 'What is Polkaswap?',
    'answer':
        'Polkaswap is a next-generation, cross-chain liquidity aggregator DEX protocol for swapping tokens based on the Polkadot (and Kusama) network(s), Parachains, and blockchains connected via bridges. Through the development of bridge technologies, Polkaswap enables Ethereum-based tokens to be traded. This is done seamlessly, at high speed and low fees, while exchanging assets in a non-custodial manner on the SORA network.'
  },
  {
    'question': 'What is the purpose of Polkaswap (PSWAP) token?',
    'answer':
        '• Used to reward liquidity providers on Polkaswap\n• Decreasing supply, with tokens burned with every token swap on Polkaswap\n• The 0.3% fee for every swap on the Polkaswap DEX is used to buy back PSWAP tokens, which are then burned.'
  },
  {
    'question': 'What is the distribution of PSWAP?',
    'answer':
        'PSWAP max supply is 10 billion, decreasing with tokens burned.\n• ~6% rewards at launch (Sora farm game finished)\n• 30% supply for development team (released)\n• 25% token bonding curve rewards (vested)\n• 35% liquidity rewards (vested)\n• ~4% market making rewards (vested)'
  },
  {
    'question': 'How PSWAP burning and reminting work?',
    'answer':
        'Unlike transaction fee models on other exchanges, on Polkaswap, trading fees are used to buy back and burn PSWAP tokens and then new PSWAP tokens are minted to reward LPs. Newly minted PSWAP tokens to liquidity providers start at 90% of the amount of burned PSWAP tokens in a 24 hour time period, and will gradually decrease down to a constant at 35% of daily burned tokens after 5 years.'
  },
  {
    'question': 'How can I earn PSWAP tokens?',
    'answer':
        'PSWAP tokens can be earned in three ways:\n• The first way to earn PSWAP tokens is to be one of the liquidity providers on Polkaswap.\n• The second way to earn PSWAP is to buy XOR with ETH, DAI, DOT, or KSM from the token bonding curve.\n• The third way to earn PSWAP tokens is from market making rebates on Polkaswap.'
  },
  {
    'question':
        'What are the benefits of being liquidity provider on Polkaswap?',
    'answer':
        'About 2,500,000 PSWAP will be allocated daily to liquidity providers on Polkaswap, and after a vesting period, users will be able to claim them. To read the full article on the first incentive program, have a look',
    'link':
        'https://medium.com/polkaswap/pswap-rewards-1-polkaswap-liquidity-reward-farming-3e045d71509'
  },
  {
    'question': 'How to earn PSWAP tokens using token bonding curve (TBC)?',
    'answer':
        'Buying XOR with ETH, DAI, DOT, or KSM would help grow the SORA ecosystem, collateralize the bonding curve, and in the case of DOT and KSM, help SORA secure parachain slots for the Polkadot and Kusama chains respectively. 2.5 billion PSWAP tokens have been allocated as rewards for XOR buyers.'
  },
  {
    'question': 'What are market making rebates on Polkaswap?',
    'answer':
        '400 million PSWAP (20 million per month) will be reserved proportionally for market makers that have at least 500 transactions with an average of at least 1 XOR in each transaction. You can read the details',
    'link':
        'https://medium.com/polkaswap/pswap-rewards-part-3-polkaswap-market-making-rebates-1856f62ccfaa'
  },
];

class Faqs extends StatelessWidget {
  final SizingInformation sizingInformation;

  const Faqs({
    Key? key,
    required this.sizingInformation,
  }) : super(key: key);

  void _scrollToSelectedContent(GlobalKey expansionTileKey) {
    final keyContext = expansionTileKey.currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimensions.DEFAULT_MARGIN),
          child: Text(
            kFAQSTitle,
            style: trackerTitleStyle(sizingInformation),
            textAlign: TextAlign.center,
          ),
        ),
        UIHelper.verticalSpaceExtraSmall(),
        Text(
          kFAQSSubtitle,
          style: trackerSubtitleStyle(sizingInformation),
        ),
        UIHelper.verticalSpaceMediumLarge(),
        Column(
          children: _faqs.map((e) {
            return FaqsItem(
              item: e,
              scrollToSelectedContent: _scrollToSelectedContent,
            );
          }).toList(),
        ),
      ],
    );
  }
}
