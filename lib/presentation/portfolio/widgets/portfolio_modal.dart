import 'package:ceres_tools_app/core/theme/dimensions.dart';
import 'package:ceres_tools_app/core/widgets/input_field.dart';
import 'package:ceres_tools_app/domain/models/wallet.dart';
import 'package:flutter/material.dart';

class PortfolioModal extends StatefulWidget {
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
  State<PortfolioModal> createState() => _PortfolioModalState();
}

class _PortfolioModalState extends State<PortfolioModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.wallet.name;
    addressController.text = widget.wallet.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.wallet.address.isNotEmpty
                        ? 'Edit wallet'
                        : 'Add new wallet',
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
                enabledValidation: widget.wallet.name.isNotEmpty,
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
                enabledValidation: true,
                hint: 'Enter wallet address',
              ),
              const SizedBox(height: Dimensions.DEFAULT_MARGIN),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.wallet.address.isNotEmpty)
                    (TextButton(
                      onPressed: () {
                        widget.removeWallet(widget.wallet);
                        Navigator.pop(context);
                      },
                      child: const Text('Remove this wallet'),
                    )),
                  const SizedBox(width: Dimensions.DEFAULT_MARGIN),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        widget.addEditWallet(
                            Wallet(nameController.text, addressController.text,
                                nameController.text.isEmpty),
                            widget.wallet);
                        Navigator.pop(context);
                      }
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
      ),
    );
  }
}
