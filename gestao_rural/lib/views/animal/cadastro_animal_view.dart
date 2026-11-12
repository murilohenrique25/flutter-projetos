import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gestao_rural/controllers/animal_controller.dart';

class CadastroAnimalView extends StatelessWidget {
  final AnimalController controller = Get.find<AnimalController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 20, 120, 10)),
        title: Text(
          'Cadastrar Animal',
          style: TextStyle(
            color: const Color.fromARGB(255, 20, 120, 10),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Center(
                      child: Text(
                        'Dados do Animal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 20, 120, 10),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Informações Básicas
                    Text(
                      'Informações Básicas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 20, 120, 10),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Número do Brinco
                    _buildTextField(
                      controller: controller.numeroBrincoController,
                      label: 'Número do Brinco *',
                      icon: Icons.tag,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 15),

                    // Nome
                    _buildTextField(
                      controller: controller.nomeController,
                      label: 'Nome *',
                      icon: Icons.pets,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 15),

                    // Lote
                    _buildTextField(
                      controller: controller.loteController,
                      label: 'Lote *',
                      icon: Icons.group,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 15),

                    // Peso no Nascimento
                    _buildTextField(
                      controller: controller.pesoNascimentoController,
                      label: 'Peso no Nascimento (kg) *',
                      icon: Icons.monitor_weight,
                      inputType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Data de Nascimento
                    _buildDateField(
                      controller: controller.dataNascimentoController,
                      label: 'Data de Nascimento *',
                      icon: Icons.calendar_today,
                      context: context,
                    ),
                    SizedBox(height: 15),

                    // Raça
                    _buildTextField(
                      controller: controller.racaController,
                      label: 'Raça *',
                      icon: Icons.category,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: 25),

                    // Informações Reprodutivas
                    Text(
                      'Informações Reprodutivas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 20, 120, 10),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Quantidade de Cios
                    _buildTextField(
                      controller: controller.quantidadeCiosController,
                      label: 'Quantidade de Cios',
                      icon: Icons.favorite,
                      inputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 15),

                    // Quantidade de Partos
                    _buildTextField(
                      controller: controller.quantidadePartosController,
                      label: 'Quantidade de Partos',
                      icon: Icons.child_care,
                      inputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 15),

                    // Data da Inseminação
                    _buildDateField(
                      controller: controller.dataInseminacaoController,
                      label: 'Data da Inseminação',
                      icon: Icons.science,
                      context: context,
                    ),
                    SizedBox(height: 15),

                    // Data do Parto
                    _buildDateField(
                      controller: controller.dataPartoController,
                      label: 'Data do Parto',
                      icon: Icons.baby_changing_station,
                      context: context,
                    ),
                    SizedBox(height: 30),

                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.adicionarAnimal(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Nota sobre campos obrigatórios
                    Text(
                      '* Campos obrigatórios',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 20, 120, 10)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 20, 120, 10),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: const Color.fromARGB(255, 20, 120, 10),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate =
              '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
          controller.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 20, 120, 10)),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.grey[600],
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 20, 120, 10),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
