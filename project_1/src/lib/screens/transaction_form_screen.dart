import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/finance_controller.dart';
import '../models/transaction.dart';
import '../widgets/responsive_scaffold.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.existing});

  final FinanceTransaction? existing;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _description;
  late double _amount;
  late String _category;
  late DateTime _date;
  late bool _isIncome;

  final List<String> _defaultCategories = <String>[
    'General',
    'Food',
    'Housing',
    'Transport',
    'Entertainment',
    'Salary',
    'Savings',
  ];

  @override
  void initState() {
    super.initState();
    final FinanceTransaction? existing = widget.existing;
    _description = existing?.description ?? '';
    _amount = existing?.amount ?? 0;
    _category = existing?.category ?? 'General';
    _date = existing?.date ?? DateTime.now();
    _isIncome = existing?.isIncome ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find<FinanceController>();

    return ResponsiveScaffold(
      destination: AppDestination.transactions,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.existing == null
                    ? 'Add transaction'
                    : 'Edit transaction',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _description = value!.trim();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    _amount == 0 ? '' : _amount.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final double? parsed = double.tryParse(
                    value.replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a positive number';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _amount = double.parse(
                    value!.replaceAll(',', '.'),
                  );
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _category,
                          isExpanded: true,
                          items: _defaultCategories
                              .map<DropdownMenuItem<String>>(
                                (String c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(c),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _category = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _date = picked;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('This is income'),
                value: _isIncome,
                onChanged: (bool value) {
                  setState(() {
                    _isIncome = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _formKey.currentState!.save();

                    final FinanceTransaction tx = (widget.existing ??
                            FinanceTransaction(
                              id: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              description: '',
                              amount: 0,
                              category: '',
                              date: _date,
                              isIncome: _isIncome,
                            ))
                        .copyWith(
                      description: _description,
                      amount: _amount,
                      category: _category,
                      date: _date,
                      isIncome: _isIncome,
                    );

                    await controller.upsert(tx);

                    if (mounted) {
                      Get.offNamed('/transactions/${tx.id}');
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

