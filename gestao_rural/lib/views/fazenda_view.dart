import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/auth_controller.dart';
import 'package:gestao_rural/controllers/fazenda_controller.dart';
import 'package:gestao_rural/widgets/legend_item.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class FazendaView extends StatelessWidget {
  final FazendaController controller = Get.find<FazendaController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 20, 120, 10)),
        title: Text(
          'Gestão Rural',
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color.fromARGB(255, 20, 120, 10)),
        ),
      ),
      drawer: buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B8D37), Color(0xFF14CC30)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra superior com título e botão de logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Seja Bem-vindo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () => authController.logout(),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Container principal
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Status do Rebanho',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 40),

                            // Gráfico de Pizza
                            Obx(
                              () =>
                                  controller.isLoading.value
                                      ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : SizedBox(
                                        height: 300,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: PieChart(
                                                PieChartData(
                                                  sections: [
                                                    // Vacas Não Inseminadas e Não Lactantes
                                                    PieChartSectionData(
                                                      value:
                                                          (controller
                                                                  .totalVacas
                                                                  .value)
                                                              .toDouble(),
                                                      title:
                                                          '${controller.totalVacas.value}',
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            189,
                                                            189,
                                                            189,
                                                          ),
                                                      radius: 100,
                                                      titleStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // Vacas Inseminadas
                                                    PieChartSectionData(
                                                      value:
                                                          (controller
                                                                  .vacasInseminadas
                                                                  .value)
                                                              .toDouble(),
                                                      title:
                                                          '${controller.vacasInseminadas.value}',
                                                      color: Colors.orange,
                                                      radius: 100,
                                                      titleStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  sectionsSpace: 2,
                                                  centerSpaceRadius: 0,
                                                  startDegreeOffset: 180,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            ),

                            // Legenda do gráfico
                            SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 20,
                              runSpacing: 10,
                              children: [
                                LegendItem(
                                  title: 'Total de Vacas',
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(width: 20),
                                LegendItem(
                                  title: 'Vacas Inseminadas',
                                  color: Colors.orange,
                                ),
                              ],
                            ),

                            SizedBox(height: 40),

                            // Botão de atualizar
                            GestureDetector(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : () => controller.fetchData(),
                              child: Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 28, 95, 25),
                                      Color.fromARGB(255, 93, 248, 2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(
                                        255,
                                        28,
                                        95,
                                        25,
                                      ).withAlpha(75),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Atualizar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Drawer Widget
  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 120, 10),
              image: DecorationImage(
                image: AssetImage(
                  'assets/icone-vaca.jpg',
                ), // Substitua pelo seu asset
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.green.withAlpha(205),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: const Text(
                'Gestão da Fazenda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Botões do drawer
          ListTile(
            leading: Icon(
              Icons.pets,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'Lista de Animais',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirListaAnimais();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.medical_services,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'Sanitário',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirSanitario();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.science,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'Inseminações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirInseminacoes();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.medical_information,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'Av. Diagnóstica',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirAvGinecologica();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.medical_services,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'DG',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirDiagnostico();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.schedule,
              color: const Color.fromARGB(255, 20, 120, 10),
            ),
            title: Text(
              'Partos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Get.back(); // Fecha o drawer
              controller.abrirPartos();
            },
          ),
          Divider(),
          // Estatísticas
          /*Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumo do Rebanho',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 20, 120, 10),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        title: 'Total de Vacas',
                        value: '${controller.totalVacas.value}',
                        icon: Icons.pets,
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        title: 'Vacas Inseminadas',
                        value: '${controller.vacasInseminadas.value}',
                        icon: Icons.science,
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        title: 'Vacas Lactantes',
                        value: '${controller.vacasLactantes.value}',
                        icon: Icons.opacity,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),*/
        ],
      ),
    );
  }

  // Widget para os cards de informação
  /*Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 20, 120, 10)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 20, 120, 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
