import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/videojuegos_provider.dart';
import 'detalle_screen.dart';
import 'form_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videojuegos = ref.watch(videojuegosProvider);
    final usuario = ref.watch(usuarioActualProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario == null ? 'Videojuegos' : 'Hola, ${usuario.nombre}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              ref.read(authControllerProvider.notifier).cerrarSesion();
            },
          ),
        ],
      ),
      body: videojuegos.isEmpty
          ? const Center(child: Text('No hay videojuegos cargados.'))
          : ListView.builder(
              itemCount: videojuegos.length,
              itemBuilder: (context, index) {
                final videojuego = videojuegos[index];
                return ListTile(
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: videojuego.imagenUrl.isEmpty
                        ? const Icon(Icons.videogame_asset)
                        : Image.network(
                            videojuego.imagenUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                  ),
                  title: Text(videojuego.nombre),
                  subtitle:
                      Text('${videojuego.genero} · ${videojuego.plataforma}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetalleScreen(videojuego: videojuego),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
