import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/videojuego.dart';
import '../../providers/videojuegos_provider.dart';
import '../screens/form_screen.dart';

class DetalleScreen extends ConsumerWidget {
  final Videojuego videojuego;

  const DetalleScreen({super.key, required this.videojuego});

  Future<void> _confirmarEliminar(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar videojuego'),
        content: Text('¿Seguro que querés eliminar "${videojuego.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      ref.read(videojuegosProvider.notifier).eliminar(videojuego.id);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(videojuego.nombre),
        actions: [
          // BOTÓN PARA AGREGAR UN NUEVO VIDEOJUEGO
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar videojuego',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FormScreen(),
                ),
              );
            },
          ),

          // BOTÓN EDITAR
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FormScreen(videojuego: videojuego),
                ),
              );
            },
          ),

          // BOTÓN ELIMINAR
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminar(context, ref),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (videojuego.imagenUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                videojuego.imagenUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),

          const SizedBox(height: 16),

          Text(
            videojuego.nombre,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(videojuego.descripcion),

          const SizedBox(height: 16),

          _Dato(
            etiqueta: 'Género',
            valor: videojuego.genero,
          ),

          _Dato(
            etiqueta: 'Plataforma',
            valor: videojuego.plataforma,
          ),

          _Dato(
            etiqueta: 'Año',
            valor: videojuego.anio.toString(),
          ),

          if (videojuego.categorias.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Información adicional',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...videojuego.categorias.entries.map(
              (entry) => _Dato(etiqueta: entry.key, valor: entry.value),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _Dato({
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$etiqueta: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(valor),
        ],
      ),
    );
  }
}
