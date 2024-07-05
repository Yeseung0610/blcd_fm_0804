import 'package:bldc_fm_0803_application/config/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme/colors_style.dart';
import '../providers/blcd_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<BLCDProvider>(
        create: (context) => BLCDProvider(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('BLDC 주차관리 프로그램'),
            ),
            body: Consumer<BLCDProvider>(
              builder: (context, provider, _) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isConnected ? kGreen : kRed,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(provider.isConnected ? '연결 중' : '연결 안됨', style: kBody11RegularStyle)
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => provider.connectToDevice(context),
                          child: const Text('블루투스 연결'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => provider.disconnectToDevice(context),
                          child: const Text('블루투스 해제'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: provider.checkOutVehicle,
                          child: const Text('출고'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: provider.checkInVehicle,
                          child: const Text('입고'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
