import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/parto_controller.dart';
import 'package:get/get.dart';

class PartoListagemView extends StatelessWidget {
  final PartoController controller = Get.put(PartoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 20, 120, 10)),
        title: Text(
          'Controle de Partos',
          style: TextStyle(
            color: const Color.fromARGB(255, 20, 120, 10),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => controller.voltar(),
        ),
      ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Lista de partos
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromARGB(255, 20, 120, 10),
                          ),
                        );
                      }

                      if (controller.partos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.baby_changing_station,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhum parto para acompanhar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                controller.temDiagnosticosPositivos
                                    ? 'Os partos aparecerão aqui\nbaseados nos diagnósticos positivos'
                                    : 'Realize diagnósticos de gestação\npositivos primeiro',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: controller.partos.length,
                        itemBuilder: (context, index) {
                          final parto = controller.partos[index];
                          return Dismissible(
                            key: Key(parto.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 20, 120, 10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              // Não confirmar dismiss, apenas abrir modal
                              controller.abrirModalConfirmacaoParto(parto);
                              return false; // Não remove o item da lista
                            },
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        parto.pariu
                                            ? Colors.green
                                            : Colors.orange,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    parto.pariu
                                        ? Icons.check_circle
                                        : Icons.schedule,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  'Animal: ${parto.animal.nome}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                      255,
                                      20,
                                      120,
                                      10,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Brinco: ${parto.animal.numeroBrinco}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      'Status: ${parto.statusParto}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            parto.pariu
                                                ? Colors.green
                                                : Colors.orange,
                                      ),
                                    ),
                                    Text(
                                      parto.pariu
                                          ? 'Data do Parto: ${parto.dataPartoRealizada}'
                                          : 'Previsão: ${parto.dataPrevisaoParto}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.swipe_left,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                    Text(
                                      'Deslize',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _mostrarDetalhesParto(context, parto);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalhesParto(BuildContext context, parto) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header fixo
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalhes do Parto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 20, 120, 10),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1),

            // Conteúdo scrollável
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status do parto
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color:
                            parto.pariu
                                ? Colors.green[100]
                                : Colors.orange[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: parto.pariu ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            parto.pariu ? Icons.check_circle : Icons.schedule,
                            color: parto.pariu ? Colors.green : Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              parto.statusPartoDetalhado,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    parto.pariu
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informações do animal
                    Text(
                      'Informações do Animal:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 20, 120, 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('Nome:', parto.animal.nome),
                    _buildDetailRow(
                      'Número do Brinco:',
                      parto.animal.numeroBrinco,
                    ),
                    _buildDetailRow('Lote:', parto.animal.lote),

                    SizedBox(height: 15),
                    Text(
                      'Informações da Gestação:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 20, 120, 10),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow(
                      'Data da Inseminação:',
                      parto.diagnosticoGestacao.inseminacao.dataInseminacao,
                    ),
                    _buildDetailRow(
                      'Data do Diagnóstico:',
                      parto.diagnosticoGestacao.dataDiagnostico,
                    ),
                    _buildDetailRow(
                      'Data Prevista do Parto:',
                      parto.dataPrevisaoParto,
                    ),

                    if (parto.pariu && parto.dataPartoRealizada != null)
                      _buildDetailRow(
                        'Data Real do Parto:',
                        parto.dataPartoRealizada!,
                      ),

                    SizedBox(height: 20),

                    // Botão para editar status
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back(); // Fechar bottomsheet
                          controller.abrirModalConfirmacaoParto(parto);
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text(
                          'Editar Status do Parto',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            20,
                            120,
                            10,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Espaço extra para o scroll
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
