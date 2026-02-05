#include <stdbool.h>
#include "rars-runtime.h"

#define MAX_LEN_NOMBRE 34
#define MAX_ACTORES_PELICULA 5
#define MAX_ACTORES 50
#define MAX_PELICULAS 50
#define MAX_PROYECCIONES 10
#define MAX_CINES 10

struct FechaRep {
  int ano;
  int mes;
  int dia;
};
typedef struct FechaRep Fecha;

typedef struct {
  char nombre[MAX_LEN_NOMBRE];
  Fecha nacimiento;
} Actor;

typedef struct {
  char nombre[MAX_LEN_NOMBRE];
  int ano;
  int num_actores;
  Actor *actores[MAX_ACTORES_PELICULA];
} Pelicula;

typedef struct {
  Fecha fecha;
  Pelicula* pelicula;
  int recaudacion;
} Proyeccion;

typedef struct {
  char nombre[MAX_LEN_NOMBRE];
  int num_proyecciones;
  Proyeccion proyecciones[MAX_PROYECCIONES];
} Cine;

Actor actores[MAX_ACTORES] = {
  { "Sigourney Weaver", { 1949, 10, 8 } },
  { "Tom Skerritt", { 1933, 8, 25 } },
  { "John Hurt", { 1940, 1, 22 } },
  { "Keir Dullea", { 1936, 5, 30 } },
  { "Gary Lockwood", { 1937, 2, 21 } },
  { "Mel Brooks", { 1926, 6, 28 } },
  { "John Candy", { 1950, 10, 31 } },
  { "Rick Moranis", { 1953, 4, 18 } },
  { "Harrison Ford", { 1942, 7, 13 } },
  { "Carrie Fisher", { 1956, 10, 21 } },
  { "Mark Hamill", { 1951, 9, 25 } },
  { "Linda Hamilton", { 1956, 9, 26 } },
  { "Arnold Schwarzenegger", { 1947, 7, 30 } },
  { "Natalie Portman", { 1981, 6, 9 } },
  { "Ewan McGregor", { 1971, 3, 31 } },
  { "Jodie Foster", { 1962, 11, 19 } },
  { "Matthew McConaughey", { 1969, 11, 4 } },
  { "Michelle Rodriguez", { 1978, 7, 12 } },
};
int num_actores = 18;

Pelicula peliculas[MAX_PELICULAS] = {
  { "2001: A Space Odyssey", 1968, 2, {
      &actores[3], // Keir Dullea
      &actores[4]  // Gary Lockwood
    } },
  { "Star Wars: A New Hope", 1977, 3, {
      &actores[8],  // Harrison Ford
      &actores[9],  // Carrie Fisher
      &actores[10]  // Mark Hamill
    } },
  { "Alien", 1979, 3, {
      &actores[0], // Sigourney Weaver
      &actores[1], // Tom Skerritt
      &actores[2]  // John Hurt
    } },
  { "Blade Runner", 1982, 1, {
      &actores[8] // Harrison Ford
    } },
  { "The Terminator", 1984, 2, {
      &actores[11], // Linda Hamilton
      &actores[12]  // Arnold Schwarzenegger
    } },
  { "Aliens", 1986, 1, {
      &actores[0] // Sigourney Weaver
    } },
  { "Spaceballs", 1987, 3, {
      &actores[5], // Mel Brooks
      &actores[6], // John Candy
      &actores[7]  // Rick Moranis
    } },
  { "Terminator 2: Judgment Day", 1991, 2, {
      &actores[11], // Linda Hamilton
      &actores[12]  // Arnold Schwarzenegger
    } },
  { "Contact", 1997, 2, {
      &actores[15], // Jodie Foster
      &actores[16]  // Matthew McConaughey
    } },
  { "Star Wars: Attack of the Clones", 2002, 2, {
      &actores[13], // Natalie Portman
      &actores[14]  // Ewan McGregor
    } },
  { "Avatar", 2009, 2, {
      &actores[0],  // Sigourney Weaver
      &actores[17]  // Michelle Rodriguez
    } }
};

int num_peliculas = 11;

Cine cines[MAX_CINES] = {
  { "Cine Aurora", 5, {
      { {1969,  1, 10}, &peliculas[0], 12000 }, // 2001: A Space Odyssey
      { {1978,  6, 15}, &peliculas[1], 25000 }, // Star Wars: A New Hope
      { {1980,  3, 20}, &peliculas[2], 18000 }, // Alien
      { {1983, 11,  5}, &peliculas[3], 16000 }, // Blade Runner
      { {1985,  2, 14}, &peliculas[4], 20000 }  // The Terminator
    } },
  { "Cine Coliseo", 5, {
      { {1986, 10,  3}, &peliculas[5], 21000 }, // Aliens
      { {1987, 12, 18}, &peliculas[6], 23000 }, // Spaceballs
      { {1988,  5, 25}, &peliculas[7], 19000 }, // Terminator 2: Judgment Day
      { {1990,  6, 30}, &peliculas[8], 26000 }, // Contact
      { {1992,  9, 12}, &peliculas[1], 24000 }  // Star Wars: A New Hope
    } },
  { "Cine Órbita", 4, {
      { {2000,  4, 21}, &peliculas[9], 30000 },  // Star Wars: Attack of the Clones
      { {2001,  7,  6}, &peliculas[2], 22000 },  // Alien
      { {2010, 12, 17}, &peliculas[10], 45000 }, // Avatar
      { {2011,  3,  4}, &peliculas[6], 28000 }   // Spaceballs
    }
  }
};
int num_cines = 3;

/* Funciones varias de utilidad */

int longitud_integer(int i) {
  int l = i <= 0 ? 1 : 0;
  while (i != 0) {
    l = l + 1;
    i = i / 10;
  }
  return l;
}

int longitud_cadena(const char* c) {
  int n = 0;
  while (*c) {
    ++n;
    ++c;
  }
  return n;
}

void repite_caracter(char c, int veces) {
  for (int i = 0; i < veces; ++i) {
    print_character(c);
  }
}

void mostrar_fecha(Fecha* f) {
  repite_caracter('0', 4 - longitud_integer(f->ano));
  print_integer(f->ano);
  print_character('-');
  repite_caracter('0', 2 - longitud_integer(f->mes));
  print_integer(f->mes);
  print_character('-');
  repite_caracter('0', 2 - longitud_integer(f->dia));
  print_integer(f->dia);
}

void listar_peliculas_y_actores(int ano_desde, int ano_hasta) {
  for(int i = 0; i < num_peliculas; i++) {
    if (peliculas[i].ano >= ano_desde && peliculas[i].ano <= ano_hasta) {
      print_string("- Año: ");
      print_integer(peliculas[i].ano);
      print_string(", Título: ");
      print_string(peliculas[i].nombre);
      print_character('\n');
      print_string("  Reparto: ");
      for (int j = 0; j < peliculas[i].num_actores; ++j) {
        print_string(peliculas[i].actores[j]->nombre);
        print_string(" (");
        mostrar_fecha(&peliculas[i].actores[j]->nacimiento);
        if (j + 1 < peliculas[i].num_actores) {
          print_string("), ");
        } else {
          print_string(")\n");
        }
      }
    }
  }
}

/* Función auxiliar para comparar dos fechas */
/* Devuelve: <0 si f1 < f2, 0 si f1 == f2, >0 si f1 > f2 */
int comparar_fechas(Fecha *f1, Fecha *f2) {
  if (f1->ano != f2->ano) {
    return f1->ano - f2->ano;
  } else if (f1->mes != f2->mes) {
    return f1->mes - f2->mes;
  } else {
    return f1->dia - f2->dia;
  }
}

/* EJERCICIO 1 */
int listar_recaudacion_peliculas() {
  int recaudacion_global = 0;
  for (int i = 0; i < num_peliculas; ++i) {
    int recaudacion_pelicula = 0;
    for (int j = 0; j < num_cines; ++j) {
      for (int k = 0; k < cines[j].num_proyecciones; ++k) {
        if (cines[j].proyecciones[k].pelicula == &peliculas[i]) {
          recaudacion_pelicula = recaudacion_pelicula + cines[j].proyecciones[k].recaudacion;
        }
      }
    }
    print_string(peliculas[i].nombre);
    print_string(": ");
    print_integer(recaudacion_pelicula);
    print_string("\n");
    recaudacion_global = recaudacion_global + recaudacion_pelicula;
  }
  return recaudacion_global;
}

/* EJERCICIO 2 */
/* Ordenar los actores de la película por edad (fecha de nacimiento) */
void ordenar_actores_pelicula(Pelicula *p) {
  for (int i = 1; i < p->num_actores; i++) {
    Actor *a = p->actores[i];
    int j = i - 1;
    while (j >= 0 && comparar_fechas(&p->actores[j]->nacimiento, &a->nacimiento) > 0) {
      p->actores[j + 1] = p->actores[j];
      j = j - 1;
    }    
    p->actores[j + 1] = a;
  }
}

void ordenar_actores_todas_peliculas(Pelicula *p) {
  for (int i = 0; i < num_peliculas; ++i) {
    ordenar_actores_pelicula(&peliculas[i]);
  }
}

/* EJERCICIO 3 */
int contar_peliculas_actor(Actor *actor) {
  int npeliculas = 0;
  for (int i = 0; i < num_peliculas; ++i) {
    for (int j = 0; j < peliculas[i].num_actores; ++j) {
      if (peliculas[i].actores[j] == actor) {
        npeliculas = npeliculas + 1;
      }
    }
  }
  return npeliculas;
}


int main(int argc, char* argv[]) {
  clear_screen();
  while (true) {
    print_string("\n\nExamen de ETC de ensamblador\n\n");
    print_string("Listado de películas:\n\n");
    listar_peliculas_y_actores(1900, 2030);
    
    print_string("\n\n"
                 " 1. Recaudación de películas\n"
                 " 2. Ordenar por edad los actores de todas las películas\n"
                 " 3. Contar películas de cada actor\n"
                 " 0. Salir\n\n"
                 "Elige una opción: ");
    char opc = read_character();
    print_string("\n\n");
    if (opc == '1') {
      int total = listar_recaudacion_peliculas();
      print_string("\nTotal: ");
      print_integer(total);
      print_string("\nPulse cualquier tecla para continuar.\n");
      read_character();
    } else if (opc == '2') {
      print_string("Ordenando actores de todas las películas...\n");
      ordenar_actores_todas_peliculas(peliculas);
      print_string("¡Actores ordenados!\n");
      print_string("\nPulse cualquier tecla para continuar.\n");
      read_character();
    } else if (opc == '3') {
      print_string("\nActor");
      repite_caracter(' ', MAX_LEN_NOMBRE - 5);
      print_string("Películas\n");
      for (int i = 0; i < num_actores; i++) {
        print_string(actores[i].nombre);
        int cuenta = contar_peliculas_actor(&actores[i]);
        repite_caracter(' ', MAX_LEN_NOMBRE - longitud_cadena(actores[i].nombre + 5 - longitud_integer(cuenta)));
        print_integer(cuenta);
        print_character('\n');
      }
      print_string("\nPulse cualquier tecla para continuar.\n");
      read_character();
    } else if (opc == '0') {
      print_string("¡Adiós!\n");
      exit(0);
    } else {
      print_string("Opción incorrecta. Pulse cualquier tecla para seguir.\n");
      read_character();
    }
  }
}
