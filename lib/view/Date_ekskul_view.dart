import 'package:attandance_simple/core/component/appBar_component.dart';
import 'package:attandance_simple/core/cubit/cubit_date_ekskul/date_ekskul_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_date_ekskul/date_ekskul_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateEkskulView extends StatelessWidget {
  const DateEkskulView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: BlocBuilder<DateEkskulCubit, DateEkskulState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text("Error: ${state.error!}"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Jadwal Kehadiran untuk:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  context.read<DateEkskulCubit>().namaEkskul,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CalendarDatePicker(
                    initialDate: state.selectedDate,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2030),
                    onDateChanged: (date) {
                      context.read<DateEkskulCubit>().setSelectedDate(date);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _RekapCard(rekapStatus: state.rekapStatus),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<DateEkskulCubit>().saveDateAndNavigate(context);
                  },
                  icon: const Icon(Icons.checklist),
                  label: const Text('Lihat Kehadiran Ekskul'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RekapCard extends StatelessWidget {
  final Map<String, int> rekapStatus;
  const _RekapCard({required this.rekapStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.grey[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _rekapItem('Hadir', rekapStatus['H'] ?? 0, Colors.green),
            _rekapItem('Izin', rekapStatus['I'] ?? 0, Colors.blue),
            _rekapItem('Sakit', rekapStatus['S'] ?? 0, Colors.orange),
            _rekapItem('Alpa', rekapStatus['A'] ?? 0, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _rekapItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}