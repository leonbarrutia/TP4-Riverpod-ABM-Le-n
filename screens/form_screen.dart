import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/videojuego.dart';
import '../../providers/videojuegos_provider.dart';

class FormScreen extends ConsumerStatefulWidget {
  final Videojuego? videojuego;

  const FormScreen({super.key, this.videojuego});

  bool get esEdicion => videojuego != null;

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _imagenController;
  late final TextEditingController _generoController;
  late final TextEditingController _plataformaController;
  late final TextEditingController _anioController;

  // Lista de categorías personalizadas
  final List<Map<String, TextEditingController>> _categorias = [];

  @override
  void initState() {
    super.initState();

    final vj = widget.videojuego;

    _nombreController = TextEditingController(text: vj?.nombre ?? '');

    _descripcionController =
        TextEditingController(text: vj?.descripcion ?? '');

    _imagenController =
        TextEditingController(text: vj?.imagenUrl ?? '');

    _generoController =
        TextEditingController(text: vj?.genero ?? '');

    _plataformaController =
        TextEditingController(text: vj?.plataforma ?? '');

    _anioController =
        TextEditingController(text: vj?.anio.toString() ?? '');

    // Si estamos editando, cargamos las categorías existentes
    if (vj != null) {
      for (final categoria in vj.categorias.entries) {
        _categorias.add({
          'nombre': TextEditingController(
            text: categoria.key,
          ),
          'valor': TextEditingController(
            text: categoria.value,
          ),
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    _generoController.dispose();
    _plataformaController.dispose();
    _anioController.dispose();

    // Liberamos los controllers de las categorías
    for (final categoria in _categorias) {
      categoria['nombre']!.dispose();
      categoria['valor']!.dispose();
    }

    super.dispose();
  }

  // Agregar una nueva categoría
  void _agregarCategoria() {
    setState(() {
      _categorias.add({
        'nombre': TextEditingController(),
        'valor': TextEditingController(),
      });
    });
  }

  // Eliminar una categoría
  void _eliminarCategoria(int index) {
    _categorias[index]['nombre']!.dispose();
    _categorias[index]['valor']!.dispose();

    setState(() {
      _categorias.removeAt(index);
    });
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    // Convertimos las categorías en un Map
    final Map<String, String> categoriasFinales = {};

    for (final categoria in _categorias) {
      final nombre = categoria['nombre']!.text.trim();
      final valor = categoria['valor']!.text.trim();

      if (nombre.isNotEmpty && valor.isNotEmpty) {
        categoriasFinales[nombre] = valor;
      }
    }

    final nuevoVideojuego = Videojuego(
      id: widget.videojuego?.id ?? '',
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      imagenUrl: _imagenController.text.trim(),
      genero: _generoController.text.trim(),
      plataforma: _plataformaController.text.trim(),
      anio: int.tryParse(_anioController.text.trim()) ?? 0,

      // Categorías creadas por el usuario
      categorias: categoriasFinales,
    );

    final controller = ref.read(videojuegosProvider.notifier);

    if (widget.esEdicion) {
      controller.actualizar(nuevoVideojuego);
    } else {
      controller.agregar(nuevoVideojuego);
    }

    Navigator.of(context).pop();
  }

  String? _validarObligatorio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.esEdicion
              ? 'Editar videojuego'
              : 'Nuevo videojuego',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              // NOMBRE
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: _validarObligatorio,
              ),

              const SizedBox(height: 12),

              // DESCRIPCIÓN
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
                validator: _validarObligatorio,
              ),

              const SizedBox(height: 12),

              // IMAGEN
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen',
                ),
                validator: _validarObligatorio,
              ),

              const SizedBox(height: 12),

              // GÉNERO
              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                ),
                validator: _validarObligatorio,
              ),

              const SizedBox(height: 12),

              // PLATAFORMA
              TextFormField(
                controller: _plataformaController,
                decoration: const InputDecoration(
                  labelText: 'Plataforma',
                ),
                validator: _validarObligatorio,
              ),

              const SizedBox(height: 12),

              // AÑO
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(
                  labelText: 'Año',
                ),
                keyboardType: TextInputType.number,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return 'Ingresá un año válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // TÍTULO DE CATEGORÍAS
              const Text(
                'Categorías adicionales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // LISTA DE CATEGORÍAS
              // LISTA DE DATOS ADICIONALES
              ...List.generate(
                _categorias.length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dato adicional ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _eliminarCategoria(index),
                              icon: const Icon(Icons.delete, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _categorias[index]['nombre'],
                          decoration: const InputDecoration(
                            labelText: 'Característica',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _categorias[index]['valor'],
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // AGREGAR DATO ADICIONAL
              OutlinedButton.icon(
                onPressed: _agregarCategoria,
                icon: const Icon(Icons.add),
                label: const Text('Agregar dato adicional'),
              ),
          
              const SizedBox(height: 24),

              // GUARDAR
              ElevatedButton(
                onPressed: _guardar,

                child: Text(
                  widget.esEdicion
                      ? 'Guardar cambios'
                      : 'Agregar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
