import 'package:dorsales/pages/pages.dart';
import 'package:dorsales/providers/general_provider.dart';
import 'package:dorsales/services/dorsal_service.dart';
import 'package:dorsales/shared_preferences/preferences.dart';
import 'package:dorsales/utils/utils.dart';
import 'package:dorsales/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GeneralProvider generalProvider;
  late DorsalService dorsalService;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    generalProvider = Provider.of<GeneralProvider>(context);
    dorsalService = Provider.of<DorsalService>(context);

    return Scaffold(
      appBar: _appBar(context),
      bottomNavigationBar: _bottomNavigationBar(),
      body: PageView(
        physics: generalProvider.lockNewBibNumber
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        controller: pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) => setState(() => generalProvider.homeIndex = value),
        children: [HomePage(), NewBibNumber(pageController: pageController), StatisticsPage()],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: Row(
        spacing: 5,
        children: [
          Text(
            'Mis',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          Text(
            'Dorsales',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Utils.blue),
          ),
        ],
      ),
      actions: [
        IconButton(
            tooltip: 'Buscar',
            onPressed: () async {
              final resp = await _search(context);
              if (resp[0]) {
                Preferences.filterBusqueda = removeDiacritics(resp[1].toUpperCase());
                dorsalService.loadDorsales();
              }
            },
            icon: Icon(
              Icons.search,
              color: Utils.blueText,
            )),
        IconButton(
            tooltip: 'Ordenar',
            onPressed: () => _order(context),
            icon: Icon(
              Icons.sort,
              color: Utils.blueText,
            )),
        IconButton(
          tooltip: 'Filtrar',
          onPressed: () => _filter(context).then((_) => dorsalService.loadDorsales()),
          icon: Icon(
            Icons.filter_alt,
            color: Utils.blueText,
          ),
        ),
        IconButton(
          tooltip: 'Salir',
          onPressed: () => SystemNavigator.pop(),
          icon: Icon(
            Icons.power_settings_new_rounded,
            color: Utils.blueText,
          ),
        ),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return IgnorePointer(
      ignoring: generalProvider.lockNewBibNumber,
      child: BottomNavigationBar(
        currentIndex: generalProvider.homeIndex,
        selectedItemColor: Utils.blue,
        unselectedItemColor: Utils.grey,
        iconSize: 33,
        onTap: (value) => setState(() {
          generalProvider.homeIndex = value;
          pageController.jumpToPage(generalProvider.homeIndex);
        }),
        items: [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Nuevo', icon: Icon(Icons.add_card_rounded)),
          BottomNavigationBarItem(
            label: 'Estadísticas',
            icon: Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _order(BuildContext context) {
    String order = generalProvider.order == '' ? Utils.Distancia : generalProvider.order;
    String orderAsc = generalProvider.orderAsc == '' ? Utils.Ascendente : generalProvider.orderAsc;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 66, 66, 66),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Orden',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      IconButton.outlined(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Utils.grey),
                        ),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          isExpanded: true,
                          value: order,
                          elevation: 16,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (String? newValue) => setState(() => order = newValue!),
                          items: Utils.orders.map<DropdownMenuItem<String>>((String value) {
                            late final IconData icon;
                            if (value == Utils.Distancia)
                              icon = Icons.location_on;
                            else if (value == Utils.Fecha)
                              icon = Icons.calendar_today_rounded;
                            else if (value == Utils.Dorsal)
                              icon = Icons.confirmation_number_sharp;
                            else if (value == Utils.Tiempo || value == Utils.Ritmo)
                              icon = Icons.timer;
                            else if (value == Utils.Todo) icon = Icons.clear_all_rounded;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: Utils.blue,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Utils.grey),
                        ),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          isExpanded: true,
                          value: orderAsc,
                          elevation: 16,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (String? newValue) => setState(() => orderAsc = newValue!),
                          items: Utils.ascDesc.map<DropdownMenuItem<String>>((String value) {
                            late final icon;
                            if (value == Utils.Ascendente)
                              icon = Icons.arrow_circle_up_rounded;
                            else if (value == Utils.Descendente)
                              icon = Icons.arrow_circle_down_rounded;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: Utils.blue,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 150,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            generalProvider.order = order;
                            generalProvider.orderAsc = orderAsc;
                            dorsalService.loadDorsales();
                            Navigator.pop(context);
                          },
                          child:
                              Text('Aplicar', style: TextStyle(fontSize: 21, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> _search(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Buscar',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton.outlined(
                        onPressed: () => Navigator.pop(context, [false]),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'nombre, dorsal . . .',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Utils.grey,
                      ),
                    ),
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, [true, '']),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.cleaning_services_outlined,
                                  size: 40,
                                ),
                                Text(
                                  'Limpiar',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, [true, controller.text]),
                            child:
                                Text('Buscar', style: TextStyle(fontSize: 21, color: Colors.white)),
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
      },
    ).then((value) => value ?? [false]);
  }

  Future<dynamic> _filter(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 66, 66, 66),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  IconButton.outlined(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Años'),
                  const SizedBox(
                    height: 10,
                  ),
                  const YearsListWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Distancia'),
                  const SizedBox(
                    height: 10,
                  ),
                  const ListDistancesWidget(),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: OutlinedButton(
                            onPressed: () {
                              generalProvider.selDistance = Utils.sTodas;
                              generalProvider.selYear = Utils.sTodos;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.cleaning_services_outlined,
                                  size: 40,
                                ),
                                Text(
                                  'Limpiar',
                                  style: TextStyle(fontSize: 21),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Aplicar',
                                style: TextStyle(fontSize: 21, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
