import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';

class AnimaisListagemView extends StatelessWidget {
  final AnimalController controller = Get.put(AnimalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 20, 120, 10)),
        title: Text(
          'Lista de Animais',
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
                // Botão de adicionar animal
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => controller.abrirCadastroAnimal(),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Cadastrar Novo Animal',
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

                // Lista de animais
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

                      if (controller.animais.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhum animal cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Toque no botão acima para\ncadastrar o primeiro animal',
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
                        itemCount: controller.animais.length,
                        itemBuilder: (context, index) {
                          final animal = controller.animais[index];
                          return Dismissible(
                            key: Key(animal.numeroBrinco),
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
                              controller.excluirAnimal(animal);
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
                                    color: const Color.fromARGB(
                                      255,
                                      20,
                                      120,
                                      10,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  'Brinco: ${animal.numeroBrinco}',
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
                                subtitle: Text(
                                  'Nome: ${animal.nome}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                onTap: () {
                                  _mostrarDetalhesAnimal(context, animal);
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

  void _mostrarDetalhesAnimal(BuildContext context, animal) {
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
                    'Detalhes do Animal',
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

              // Informações básicas
              _buildDetailRow('Número do Brinco:', animal.numeroBrinco),
              _buildDetailRow('Nome:', animal.nome),
              _buildDetailRow('Lote:', animal.lote),
              _buildDetailRow(
                'Peso no Nascimento:',
                '${animal.pesoNascimento} kg',
              ),
              _buildDetailRow('Data de Nascimento:', animal.dataNascimento),
              _buildDetailRow('Raça:', animal.raca),

              SizedBox(height: 15),
              Text(
                'Informações Reprodutivas:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 20, 120, 10),
                ),
              ),
              SizedBox(height: 10),

              _buildDetailRow(
                'Quantidade de Cios:',
                animal.quantidadeCios.toString(),
              ),
              _buildDetailRow(
                'Quantidade de Partos:',
                animal.quantidadePartos.toString(),
              ),
              _buildDetailRow(
                'Data da Inseminação:',
                animal.dataInseminacao.isEmpty
                    ? 'Não informado'
                    : animal.dataInseminacao,
              ),
              _buildDetailRow(
                'Data do Parto:',
                animal.dataParto.isEmpty ? 'Não informado' : animal.dataParto,
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
