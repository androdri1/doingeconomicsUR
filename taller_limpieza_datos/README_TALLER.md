# Taller: GitHub y limpieza básica de datos con dplyr

## Objetivo

Cada estudiante trabajará en su propio *fork* del repositorio del curso. Recibirá una base pequeña con errores frecuentes y deberá corregirlos usando `mutate()` y `recode()`.

No se deben construir funciones que detecten automáticamente los problemas. Cada reemplazo debe quedar escrito explícitamente en el código.

## Lo que aprenderá

Al finalizar el taller, el estudiante podrá:

1. Crear una cuenta en GitHub.
2. Hacer un *fork* de un repositorio.
3. Importar un archivo plano.
4. Examinar valores con `unique()`.
5. Modificar columnas con `mutate()`.
6. Reemplazar valores con `recode()`.
7. Convertir texto a fecha o número.
8. Exportar y publicar una base limpia.

## Parte 1. GitHub

1. Cree un usuario en GitHub.
2. Abra el repositorio de **Doing Economics** indicado por el profesor.
3. Presione **Fork**.
4. Cree una copia del repositorio en su cuenta.
5. Abra `scripts/limpieza_base_datos.R`.
6. Complete las secciones marcadas con `TODO`.

## Parte 2. Observar la base

No modifique directamente `datos/base_sucia_encuesta.txt`.

Use:

```r
unique(base$ciudad)
unique(base$fecha_encuesta)
unique(base$ingreso_mensual)
```

para observar los valores originales.

## Parte 3. Modificar una columna

`mutate()` permite modificar una columna de una base:

```r
base <- base %>%
  mutate(
    ciudad = recode(
      ciudad,
      " bogotá" = "Bogotá"
    )
  )
```

En este ejemplo:

- `base %>%` toma la base;
- `mutate()` modifica la columna `ciudad`;
- `recode()` reemplaza el valor exacto `" bogotá"` por `"Bogotá"`;
- el resultado se vuelve a guardar en `base`.

## Parte 4. Fechas

Primero reemplace manualmente cada formato:

```r
base <- base %>%
  mutate(
    fecha_encuesta = recode(
      fecha_encuesta,
      "03/08/2026" = "2026-08-03"
    )
  )
```

Después convierta la columna al tipo fecha:

```r
base <- base %>%
  mutate(
    fecha_encuesta = as.Date(
      fecha_encuesta,
      format = "%Y-%m-%d"
    )
  )
```

## Parte 5. Números

Corrija manualmente los separadores:

```r
base <- base %>%
  mutate(
    ingreso_mensual = recode(
      ingreso_mensual,
      "1.250.000,50" = "1250000.50"
    )
  )
```

Después convierta la columna a número:

```r
base <- base %>%
  mutate(
    ingreso_mensual = as.numeric(ingreso_mensual)
  )
```

## Resultado esperado

La base limpia debe:

- tener 7 filas;
- conservar un identificador diferente para cada persona;
- tener fechas en formato `AAAA-MM-DD`;
- tener ingreso y nota como variables numéricas;
- usar solamente `Sí` y `No` en `trabaja`;
- reconocer `N/D`, `-` y celdas vacías como datos faltantes;
- guardarse en `resultados/base_limpia.csv`.

## Entrega

1. Ejecute todo el script.
2. Compruebe que no aparezcan errores.
3. Guarde el archivo.
4. Haga un *commit* con el mensaje:

```text
Completa taller de limpieza de datos
```

5. Publique los cambios en su *fork*.
6. Entregue el enlace a `scripts/limpieza_base_datos.R`.
