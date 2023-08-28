import 'package:ceres_locker_app/core/theme/dimensions.dart';
import 'package:ceres_locker_app/core/widgets/input_field.dart';
import 'package:ceres_locker_app/domain/models/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PortfolioModal extends HookWidget {
  final Wallet wallet;
  final Function(Wallet wallet, Wallet previousWallet) addEditWallet;
  final Function(Wallet wallet) removeWallet;

  const PortfolioModal({
    Key? key,
    required this.wallet,
    required this.addEditWallet,
    required this.removeWallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController =
        useTextEditingController.fromValue(TextEditingValue(text: wallet.name));
    final addressController = useTextEditingController
        .fromValue(TextEditingValue(text: wallet.address));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  wallet.address.isNotEmpty ? 'Edit wallet' : 'Add new wallet',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: Dimensions.DEFAULT_MARGIN_SMALL),
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Wallet name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            InputField(
              controller: nameController,
              hint: 'Enter wallet name',
            ),
            const SizedBox(height: Dimensions.DEFAULT_MARGIN_SMALL),
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Wallet address',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            InputField(
              controller: addressController,
              hint: 'Enter wallet address',
            ),
            const SizedBox(height: Dimensions.DEFAULT_MARGIN),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (wallet.address.isNotEmpty)
                  (TextButton(
                    onPressed: () {
                      removeWallet(wallet);
                      Navigator.pop(context);
                    },
                    child: const Text('Remove this wallet'),
                  )),
                const SizedBox(width: Dimensions.DEFAULT_MARGIN),
                ElevatedButton(
                  onPressed: () {
                    addEditWallet(
                        Wallet(nameController.text, addressController.text),
                        wallet);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
