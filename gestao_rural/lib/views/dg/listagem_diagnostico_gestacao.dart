import 'package:flutter/material.dart';
import 'package:gestao_rural/controllers/diagnostico_controller.dart';
import 'package:get/get.dart';

class DiagnosticoGestacaoListagemView extends StatelessWidget {
  final DiagnosticoGestacaoController controller = Get.put(
    DiagnosticoGestacaoController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 20, 120, 10)),
        title: Text(
          'Diagnóstico de Gestação',
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
                // Botão de adicionar diagnóstico
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => controller.abrirCadastroDiagnostico(),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Cadastrar Novo Diagnóstico',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 20, 120, 10),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),

                // Lista de diagnósticos
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

                      if (controller.diagnosticos.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pregnant_woman,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhum diagnóstico cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Toque no botão acima para\ncadastrar o primeiro diagnóstico',
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
                        itemCount: controller.diagnosticos.length,
                        itemBuilder: (context, index) {
                          final diagnostico = controller.diagnosticos[index];
                          return Dismissible(
                            key: Key(diagnostico.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (direction) {
                              controller.removerDiagnostico(diagnostico);
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
                                        diagnostico.prenha
                                            ? Colors.green
                                            : Colors.red,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    diagnostico.prenha
                                        ? Icons.pregnant_woman
                                        : Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  'Animal: ${diagnostico.animal.nome}',
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
                                      'Brinco: ${diagnostico.animal.numeroBrinco}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      'Status: ${diagnostico.statusPrenhaTexto}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            diagnostico.prenha
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      'Data Inseminação: ${diagnostico.inseminacao.dataInseminacao}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      'Data Diagnóstico: ${diagnostico.dataDiagnostico}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                onTap: () {
                                  _mostrarDetalhesDiagnostico(
                                    context,
                                    diagnostico,
                                  );
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

  void _mostrarDetalhesDiagnostico(BuildContext context, diagnostico) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalhes do Diagnóstico',
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
              Divider(),
              SizedBox(height: 10),

              // Status da prenha
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color:
                      diagnostico.prenha ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: diagnostico.prenha ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      diagnostico.prenha ? Icons.check_circle : Icons.cancel,
                      color: diagnostico.prenha ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      diagnostico.statusPrenhaDetalhado,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            diagnostico.prenha
                                ? Colors.green[800]
                                : Colors.red[800],
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
              _buildDetailRow('Nome:', diagnostico.animal.nome),
              _buildDetailRow(
                'Número do Brinco:',
                diagnostico.animal.numeroBrinco,
              ),
              _buildDetailRow('Lote:', diagnostico.animal.lote),

              SizedBox(height: 15),
              Text(
                'Informações da Inseminação:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 20, 120, 10),
                ),
              ),
              SizedBox(height: 10),
              _buildDetailRow('Tipo:', diagnostico.inseminacao.tipoInseminacao),
              _buildDetailRow(
                'Data da Inseminação:',
                diagnostico.inseminacao.dataInseminacao,
              ),

              SizedBox(height: 15),
              Text(
                'Informações do Diagnóstico:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 20, 120, 10),
                ),
              ),
              SizedBox(height: 10),
              _buildDetailRow(
                'Data do Diagnóstico:',
                diagnostico.dataDiagnostico,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
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
