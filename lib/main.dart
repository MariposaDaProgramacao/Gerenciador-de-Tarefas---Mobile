import 'package:flutter/material.dart';

// ========== CORES DA PALETA "AUTUMN HARVEST" ==========
class AutumnColors {
  static const Color toastedRed = Color(0xFF6F1D1B);
  static const Color goldenBrown = Color(0xFFBB9457);
  static const Color darkBrown = Color(0xFF432818);
  static const Color mediumBrown = Color(0xFF99582A);
  static const Color mellowGold = Color(0xFFFFE6A7);
}

// ========== MODELO DE DADOS ==========
class Tarefa {
  final String id;
  String texto;
  bool concluida;
  final DateTime dataCriacao;

  Tarefa({
    required this.id,
    required this.texto,
    this.concluida = false,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  Tarefa copyWith({
    String? texto,
    bool? concluida,
  }) {
    return Tarefa(
      id: id,
      texto: texto ?? this.texto,
      concluida: concluida ?? this.concluida,
      dataCriacao: dataCriacao,
    );
  }
}

// ========== APLICATIVO PRINCIPAL ==========
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AutumnColors.toastedRed,
          primary: AutumnColors.toastedRed,
          secondary: AutumnColors.goldenBrown,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AutumnColors.toastedRed,
          foregroundColor: AutumnColors.mellowGold,
          elevation: 4,
          titleTextStyle: TextStyle(
            color: AutumnColors.mellowGold,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AutumnColors.goldenBrown,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AutumnColors.mediumBrown,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AutumnColors.mellowGold.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AutumnColors.goldenBrown),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AutumnColors.toastedRed, width: 2),
          ),
          labelStyle: const TextStyle(color: AutumnColors.darkBrown),
        ),
      ),
      home: const TelaTarefas(),
    );
  }
}

// ========== TELA PRINCIPAL ==========
class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final TextEditingController _controlador = TextEditingController();
  List<Tarefa> _tarefas = [];
  String _filtroAtual = 'Todas';
  String _ordenacaoAtual = 'Data';

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano $hora:$minuto';
  }

  void _adicionarTarefa() {
    String novaTarefa = _controlador.text.trim();
    if (novaTarefa.isEmpty) {
      _mostrarSnackbar('Digite uma tarefa antes de adicionar!', AutumnColors.goldenBrown);
      return;
    }

    if (!mounted) return;
    setState(() {
      _tarefas.add(Tarefa(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: novaTarefa,
      ));
      _controlador.clear();
    });
    _mostrarSnackbar('✨ Tarefa adicionada com sucesso!', AutumnColors.goldenBrown);
  }

  void _removerTarefa(int indice) {
    final tarefaRemovida = _tarefas[indice].texto;
    if (!mounted) return;
    setState(() {
      _tarefas.removeAt(indice);
    });
    _mostrarSnackbar('🦋 Tarefa removida: "$tarefaRemovida"', AutumnColors.toastedRed);
  }

  void _alternarConcluida(int indice) {
    if (!mounted) return;
    setState(() {
      final tarefa = _tarefas[indice];
      _tarefas[indice] = tarefa.copyWith(concluida: !tarefa.concluida);
    });
    
    final status = _tarefas[indice].concluida ? '✅ concluída' : '⏳ pendente';
    final cor = _tarefas[indice].concluida ? AutumnColors.goldenBrown : AutumnColors.mediumBrown;
    _mostrarSnackbar('Tarefa marcada como $status', cor);
  }

  void _editarTarefa(int indice) {
    final tarefa = _tarefas[indice];
    final controller = TextEditingController(text: tarefa.texto);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '✏️ Editar Tarefa',
          style: TextStyle(color: AutumnColors.darkBrown),
        ),
        backgroundColor: AutumnColors.mellowGold.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Novo texto',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: AutumnColors.darkBrown),
          ),
          autofocus: true,
          style: const TextStyle(color: AutumnColors.darkBrown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AutumnColors.mediumBrown,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final novoTexto = controller.text.trim();
              if (novoTexto.isEmpty) {
                _mostrarSnackbar('O texto não pode estar vazio!', AutumnColors.toastedRed);
                return;
              }
              if (!mounted) return;
              setState(() {
                _tarefas[indice] = tarefa.copyWith(texto: novoTexto);
              });
              Navigator.pop(context);
              _mostrarSnackbar('✏️ Tarefa editada com sucesso!', AutumnColors.goldenBrown);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AutumnColors.goldenBrown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _limparTodasTarefas() {
    if (_tarefas.isEmpty) {
      _mostrarSnackbar('Nenhuma tarefa para limpar', AutumnColors.goldenBrown);
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '🦋 Limpar Todas as Tarefas',
          style: TextStyle(color: AutumnColors.darkBrown),
        ),
        content: const Text(
          'Deseja realmente excluir TODAS as tarefas?',
          style: TextStyle(fontSize: 16, color: AutumnColors.darkBrown),
        ),
        backgroundColor: AutumnColors.mellowGold.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AutumnColors.mediumBrown,
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!mounted) return;
              setState(() {
                _tarefas.clear();
              });
              Navigator.pop(context);
              _mostrarSnackbar('🦋 Todas as tarefas foram removidas!', AutumnColors.toastedRed);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AutumnColors.toastedRed,
              foregroundColor: AutumnColors.mellowGold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  List<Tarefa> _obterTarefasFiltradas() {
    List<Tarefa> filtradas = _tarefas.where((tarefa) {
      switch (_filtroAtual) {
        case 'Pendentes':
          return !tarefa.concluida;
        case 'Concluídas':
          return tarefa.concluida;
        default:
          return true;
      }
    }).toList();

    switch (_ordenacaoAtual) {
      case 'Alfabética':
        filtradas.sort((a, b) => a.texto.toLowerCase().compareTo(b.texto.toLowerCase()));
        break;
      case 'Data':
      default:
        filtradas.sort((a, b) => a.dataCriacao.compareTo(b.dataCriacao));
        break;
    }

    return filtradas;
  }

  void _mostrarSnackbar(String mensagem, Color cor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefasFiltradas = _obterTarefasFiltradas();
    
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/Fundo_sem_mariposas.png'),
                fit: BoxFit.cover,
                opacity: 0.85,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ========== APPBAR ==========
                  AppBar(
                    title: Text(
                      isMobile ? '🦋 Tarefas' : '🦋 Minhas Tarefas',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AutumnColors.mellowGold,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: AutumnColors.toastedRed.withOpacity(0.85),
                    foregroundColor: AutumnColors.mellowGold,
                    elevation: 4,
                    toolbarHeight: isMobile ? 56 : 70,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.delete_sweep, color: AutumnColors.mellowGold),
                        tooltip: 'Limpar todas as tarefas',
                        onPressed: _limparTodasTarefas,
                        iconSize: isMobile ? 24 : 28,
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.filter_list, color: AutumnColors.mellowGold),
                        tooltip: 'Filtrar tarefas',
                        onSelected: (String valor) {
                          if (!mounted) return;
                          setState(() {
                            _filtroAtual = valor;
                          });
                          _mostrarSnackbar('Filtro: $valor', AutumnColors.goldenBrown);
                        },
                        color: AutumnColors.mellowGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Todas',
                            child: Row(
                              children: [
                                Icon(Icons.list, size: 20, color: AutumnColors.darkBrown),
                                SizedBox(width: 8),
                                Text('📋 Todas', style: TextStyle(color: AutumnColors.darkBrown)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Pendentes',
                            child: Row(
                              children: [
                                Icon(Icons.pending, size: 20, color: AutumnColors.darkBrown),
                                SizedBox(width: 8),
                                Text('⏳ Pendentes', style: TextStyle(color: AutumnColors.darkBrown)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Concluídas',
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, size: 20, color: AutumnColors.darkBrown),
                                SizedBox(width: 8),
                                Text('✅ Concluídas', style: TextStyle(color: AutumnColors.darkBrown)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.sort, color: AutumnColors.mellowGold),
                        tooltip: 'Ordenar tarefas',
                        onSelected: (String valor) {
                          if (!mounted) return;
                          setState(() {
                            _ordenacaoAtual = valor;
                          });
                          _mostrarSnackbar('Ordenação: $valor', AutumnColors.goldenBrown);
                        },
                        color: AutumnColors.mellowGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Data',
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 20, color: AutumnColors.darkBrown),
                                SizedBox(width: 8),
                                Text('📅 Data de criação', style: TextStyle(color: AutumnColors.darkBrown)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Alfabética',
                            child: Row(
                              children: [
                                Icon(Icons.sort_by_alpha, size: 20, color: AutumnColors.darkBrown),
                                SizedBox(width: 8),
                                Text('🔤 Ordem alfabética', style: TextStyle(color: AutumnColors.darkBrown)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // ========== CONTEÚDO PRINCIPAL ==========
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 12 : 24),
                      child: Column(
                        children: [
                          // ===== CAMPO DE ADIÇÃO =====
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controlador,
                                  decoration: InputDecoration(
                                    labelText: isMobile ? '🦋 Digite uma tarefa' : '🦋 Digite uma tarefa...',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.note_add, color: AutumnColors.mediumBrown),
                                    filled: true,
                                    fillColor: AutumnColors.mellowGold,
                                    labelStyle: TextStyle(
                                      color: AutumnColors.darkBrown,
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                    hintStyle: TextStyle(
                                      color: AutumnColors.mediumBrown,
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 12 : 16,
                                      vertical: isMobile ? 12 : 16,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: AutumnColors.darkBrown,
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                                  onSubmitted: (texto) => _adicionarTarefa(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _adicionarTarefa,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AutumnColors.goldenBrown,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(isMobile ? 50 : 60, isMobile ? 50 : 60),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: isMobile ? 28 : 32,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // ===== INFORMAÇÕES =====
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 20,
                              vertical: isMobile ? 10 : 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AutumnColors.goldenBrown.withOpacity(0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: AutumnColors.goldenBrown.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.format_list_bulleted,
                                      size: isMobile ? 18 : 22,
                                      color: AutumnColors.mediumBrown,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '🦋 Total: ${_tarefas.length}',
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: AutumnColors.darkBrown,
                                      ),
                                    ),
                                  ],
                                ),
                                // ===== REMOVIDO O ÍCONE "OLHO" DUPLICADO =====
                                // Agora mostra apenas o texto "Exibindo: X"
                                Text(
                                  '👁️ Exibindo: ${tarefasFiltradas.length}',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: AutumnColors.mediumBrown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // ===== LISTA DE TAREFAS =====
                          Expanded(
                            child: tarefasFiltradas.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // ===== ÍCONE CENTRAL PRETO =====
                                        Icon(
                                          _tarefas.isEmpty 
                                              ? Icons.assignment_outlined
                                              : Icons.filter_alt_off,
                                          size: isMobile ? 70 : 100,
                                          color: Colors.black, // <-- AGORA É PRETO
                                        ),
                                        const SizedBox(height: 20),
                                        
                                        Text(
                                          _tarefas.isEmpty 
                                              ? '🦋 Nenhuma tarefa cadastrada' 
                                              : '🦋 Nenhuma tarefa neste filtro',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isMobile ? 20 : 28,
                                            fontWeight: FontWeight.bold,
                                            color: AutumnColors.darkBrown,
                                            letterSpacing: 0.5,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(0.9),
                                                blurRadius: 12,
                                                offset: const Offset(0, 2),
                                              ),
                                              Shadow(
                                                color: Colors.white.withOpacity(0.5),
                                                blurRadius: 4,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 12),
                                        
                                        if (_tarefas.isEmpty) ...[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isMobile ? 20 : 32,
                                              vertical: isMobile ? 10 : 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.85),
                                              borderRadius: BorderRadius.circular(25),
                                              border: Border.all(
                                                color: AutumnColors.goldenBrown.withOpacity(0.4),
                                                width: 1.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AutumnColors.goldenBrown.withOpacity(0.15),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'Adicione sua primeira tarefa! 🦋',
                                              style: TextStyle(
                                                fontSize: isMobile ? 14 : 18,
                                                fontWeight: FontWeight.w600,
                                                color: AutumnColors.mediumBrown,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: tarefasFiltradas.length,
                                    itemBuilder: (context, indice) {
                                      final tarefa = tarefasFiltradas[indice];
                                      final indiceOriginal = _tarefas.indexOf(tarefa);
                                      
                                      return Card(
                                        margin: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
                                        elevation: tarefa.concluida ? 2 : 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(
                                            color: tarefa.concluida 
                                                ? AutumnColors.goldenBrown.withOpacity(0.5)
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        color: tarefa.concluida 
                                            ? AutumnColors.mellowGold.withOpacity(0.85)
                                            : Colors.white.withOpacity(0.9),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 6 : 12,
                                            vertical: isMobile ? 2 : 4,
                                          ),
                                          leading: Checkbox(
                                            value: tarefa.concluida,
                                            onChanged: (_) => _alternarConcluida(indiceOriginal),
                                            activeColor: AutumnColors.goldenBrown,
                                            checkColor: Colors.white,
                                          ),
                                          title: Text(
                                            tarefa.texto,
                                            style: TextStyle(
                                              fontSize: isMobile ? 14 : 16,
                                              fontWeight: FontWeight.w500,
                                              decoration: tarefa.concluida 
                                                  ? TextDecoration.lineThrough 
                                                  : null,
                                              color: tarefa.concluida 
                                                  ? AutumnColors.mediumBrown
                                                  : AutumnColors.darkBrown,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: isMobile ? 12 : 14,
                                                  color: AutumnColors.mediumBrown,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _formatarData(tarefa.dataCriacao),
                                                  style: TextStyle(
                                                    fontSize: isMobile ? 10 : 12,
                                                    color: AutumnColors.mediumBrown,
                                                  ),
                                                ),
                                                if (tarefa.concluida) ...[
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: isMobile ? 8 : 10,
                                                      vertical: isMobile ? 2 : 3,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AutumnColors.goldenBrown,
                                                          AutumnColors.goldenBrown.withOpacity(0.7),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      '✅ Concluída',
                                                      style: TextStyle(
                                                        fontSize: isMobile ? 8 : 10,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: AutumnColors.goldenBrown,
                                                ),
                                                onPressed: () => _editarTarefa(indiceOriginal),
                                                tooltip: 'Editar tarefa',
                                                iconSize: isMobile ? 20 : 24,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: AutumnColors.toastedRed,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text(
                                                        '🦋 Excluir Tarefa',
                                                        style: TextStyle(color: AutumnColors.darkBrown),
                                                      ),
                                                      content: Text(
                                                        'Deseja realmente excluir a tarefa:\n\n"${tarefa.texto}"?',
                                                        style: TextStyle(
                                                          fontSize: isMobile ? 14 : 16,
                                                          color: AutumnColors.darkBrown,
                                                        ),
                                                      ),
                                                      backgroundColor: AutumnColors.mellowGold.withOpacity(0.95),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: AutumnColors.mediumBrown,
                                                          ),
                                                          child: const Text('Cancelar'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            _removerTarefa(indiceOriginal);
                                                            Navigator.pop(context);
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: AutumnColors.toastedRed,
                                                            foregroundColor: AutumnColors.mellowGold,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          child: const Text('Excluir'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                tooltip: 'Excluir tarefa',
                                                iconSize: isMobile ? 20 : 24,
                                              ),
                                            ],
                                          ),
                                          onTap: () => _alternarConcluida(indiceOriginal),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}