import 'package:asset_management_mobile/features/assets/presentation/viewmodel/metric/metric_view_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/create_asset_model.dart';
import '../viewmodel/asset_view_model.dart';

class AddAssetForm extends ConsumerStatefulWidget {
  const AddAssetForm({super.key});

  @override
  ConsumerState<AddAssetForm> createState() => _AddAssetFormState();
}

class _AddAssetFormState extends ConsumerState<AddAssetForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedStatus;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _serialNoController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final metricProvider = ref.watch(metricViewModelProvider);
    return metricProvider.when(
      data: (metrics) {
        final metricsList = metrics != null
            ? metrics.counts
            : <String, String>{};
        final statuses = metricsList.keys.toList();
        if (_selectedStatus == null && statuses.isNotEmpty) {
          _selectedStatus = statuses.first;
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            color: const Color(0xFFF7F7F5),
            height: size.height * 0.5,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Add Asset Form',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Asset Name"),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _serialNoController,
                      decoration: _inputDecoration("Serial No"),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration("Description"),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: _inputDecoration("Status"),
                      items: statuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final asset = CreateAssetModel(
                              name: _nameController.text,
                              serialNo: _serialNoController.text,
                              description: _descriptionController.text,
                              status: _selectedStatus,
                            );
                            ref
                                .read(assetCreateViewModelProvider.notifier)
                                .createNewAsset([asset]);
                            Navigator.pop(context);
                            ref.invalidate(assetViewModelProvider);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Save Asset"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (e, st) {
        return const Center(child: Text("Something went wrong"));
      },
      loading: () {
        return Center(child: CupertinoActivityIndicator());
      },
    );
  }
}
