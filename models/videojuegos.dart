class Videojuego {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String genero;
  final String plataforma;
  final int anio;

  // Categorías que agrega el usuario
  final Map<String, String> categorias;

  Videojuego({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.genero,
    required this.plataforma,
    required this.anio,
    this.categorias = const {},
  });

  // FIREBASE → VIDEOJUEGO
  factory Videojuego.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Videojuego(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      genero: map['genero'] ?? '',
      plataforma: map['plataforma'] ?? '',
      anio: map['anio'] ?? 0,

      categorias: Map<String, String>.from(
        map['categorias'] ?? {},
      ),
    );
  }

  // VIDEOJUEGO → FIREBASE
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl,
      'genero': genero,
      'plataforma': plataforma,
      'anio': anio,
      'categorias': categorias,
    };
  }

  Videojuego copyWith({
    String? nombre,
    String? descripcion,
    String? imagenUrl,
    String? genero,
    String? plataforma,
    int? anio,
    Map<String, String>? categorias,
  }) {
    return Videojuego(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      genero: genero ?? this.genero,
      plataforma: plataforma ?? this.plataforma,
      anio: anio ?? this.anio,
      categorias: categorias ?? this.categorias,
    );
  }
}
