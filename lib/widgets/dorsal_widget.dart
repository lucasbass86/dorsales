import 'package:animate_do/animate_do.dart';
import 'package:dorsales/models/dorsal_model.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DorsalWidget extends StatelessWidget {
  final Dorsal dorsal;
  const DorsalWidget({required this.dorsal});

  @override
  Widget build(BuildContext context) {
    const double pointLocation = 7;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return DorsalInfoWidget(dorsal: dorsal, bottomContext: context);
          },
        );
      },
      child: ZoomIn(
        child: Container(
          width: 175,
          height: 125,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          decoration: BoxDecoration(
            color: Utils.blue,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: const Offset(5, 5),
                blurRadius: Utils.blurRadius,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    child: Center(
                      child: FittedBox(fit: BoxFit.fitWidth, child: Text(dorsal.carrera)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                      ),
                      child: Center(
                        child: Text(dorsal.numero.toString(), style: TextStyle(fontSize: 50, color: Colors.black.withOpacity(0.75))),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: pointLocation,
                left: pointLocation,
                child: _punto(),
              ),
              Positioned(
                top: pointLocation,
                right: pointLocation,
                child: _punto(),
              ),
              Positioned(
                bottom: pointLocation,
                left: pointLocation,
                child: _punto(),
              ),
              Positioned(
                bottom: pointLocation,
                right: pointLocation,
                child: _punto(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _punto() {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }
}
