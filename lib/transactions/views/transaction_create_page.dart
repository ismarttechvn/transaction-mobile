import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:transactions/constants/api.dart';
import 'package:transactions/transactions/models/cost_center.dart';
import 'package:transactions/transactions/models/cost_element.dart';
import 'package:transactions/transactions/models/payment_method.dart';

import '../blocs/transaction_bloc.dart';

class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  final _formKey = GlobalKey<FormState>();

  CostElement? _selectedCostElement;
  List<CostElement> _dropdownCostElement = [];

  PaymentMethod? _selectedPaymentMethod;
  List<PaymentMethod> _dropdownPaymentMethod = [];

  CostCenter? _selectedCostCenter;
  List<CostCenter> _dropdownCostCenter = [];

  @override
  void initState() {
    super.initState();
    _loadCostElement();
    _loadCostCenter();
    _loadPaymentMethod();
  }

  final TextEditingController _dateCtl = TextEditingController();
  final TextEditingController _costCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  Future<void> _submitCreateTransaction() async {
    await http.post(
      Uri.http(
        apiUrl,
        transactionUrlPath,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "cost": _costCtrl.text,
        "costCenterId": _selectedCostCenter!.id.toString(),
        "payAt": _dateCtl.text,
        "costElementId": _selectedCostElement!.id.toString(),
        "paymentMethodId": _selectedPaymentMethod!.id.toString(),
        "content": _contentCtrl.text
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Center(
          child: Text(
            'Tạo giao dịch',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _dateCtl,
                  decoration:
                      const InputDecoration(labelText: 'Ngày thanh toán'),
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng chọn ngày thanh toán';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime date = DateTime.now();
                    FocusScope.of(context).requestFocus(FocusNode());
                    var dateSelect = await showDatePicker(
                        context: context,
                        initialDate: _dateCtl.text != ''
                            ? DateTime.parse(_dateCtl.text)
                            : DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    if (dateSelect != null) {
                      date = dateSelect;
                    }
                    _dateCtl.text = date.toIso8601String();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                DropdownButtonFormField(
                  value: _selectedCostElement,
                  onChanged: (CostElement? newValue) {
                    setState(() {
                      _selectedCostElement = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Loại chi phí",
                    hintText: "Hạng mục chi phí",
                  ),
                  validator: (CostElement? value) {
                    if (value == null) {
                      return 'Vui lòng chọn một loại chi phí';
                    }
                    return null;
                  },
                  items: _dropdownCostElement
                      .map<DropdownMenuItem<CostElement>>((CostElement value) {
                    return DropdownMenuItem<CostElement>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Số tiền',
                    hintText: '1000000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    return null;
                  },
                  controller: _costCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                DropdownButtonFormField(
                  value: _selectedCostCenter,
                  onChanged: (CostCenter? newValue) {
                    setState(() {
                      _selectedCostCenter = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Chi cho",
                    hintText: "Chọn người thụ hưởng",
                  ),
                  validator: (CostCenter? value) {
                    if (value == null) {
                      return 'Vui lòng chọn mục đích chi';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: _dropdownCostCenter
                      .map<DropdownMenuItem<CostCenter>>((CostCenter value) {
                    return DropdownMenuItem<CostCenter>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField(
                  value: _selectedPaymentMethod,
                  onChanged: (PaymentMethod? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue!;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "Phương thức thanh toán",
                    hintText: "Chọn phương thức thanh toán",
                  ),
                  validator: (PaymentMethod? value) {
                    if (value == null) {
                      return 'Vui lòng chọn phương thức thanh toán';
                    }
                    return null;
                  },
                  items: _dropdownPaymentMethod
                      .map<DropdownMenuItem<PaymentMethod>>(
                          (PaymentMethod value) {
                    return DropdownMenuItem<PaymentMethod>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nội dung"),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập nội dung giao dịch';
                    }
                    return null;
                  },
                  minLines: 2,
                  maxLines: 3,
                  controller: _contentCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitCreateTransaction().then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tạo giao dịch thành công'),
                            ),
                          );
                          context
                              .read<TransactionBloc>()
                              .add(TransactionFetched(isReload: true));

                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Tạo chi phí'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadCostElement() async {
    final response = await http.get(
      Uri.http(
        apiUrl,
        costElementUrlPath,
        <String, String>{'__limit': '100'},
      ),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data']['result'] as List;
      var list = data.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return CostElement.fromJson(map);
      }).toList();

      setState(() {
        _dropdownCostElement = list;
      });
    }
  }

  Future<void> _loadCostCenter() async {
    final response = await http.get(
      Uri.http(
        apiUrl,
        costCenterUrlPath,
        <String, String>{'__limit': '100'},
      ),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data']['result'] as List;
      print(data);
      var list = data.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return CostCenter.fromJson(map);
      }).toList();

      setState(() {
        _dropdownCostCenter = list;
      });
    }
  }

  Future<void> _loadPaymentMethod() async {
    final response = await http.get(
      Uri.http(
        apiUrl,
        paymentMethodUrlPath,
        <String, String>{'__limit': '100'},
      ),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data']['result'] as List;
      var list = data.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return PaymentMethod.fromJson(map);
      }).toList();

      setState(() {
        _dropdownPaymentMethod = list;
      });
    }
  }
}
