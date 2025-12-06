# Proyecto Final

# https://github.com/benthecoder/JohnHopkinsDataScience/blob/main/3_Getting%26CleaningData/tidy_data/run_analysis.R
# Consigna:
# 1. Fusionar los conjuntos de entrenamiento y prueba para crear un solo conjunto de datos.
# 2. Extraer solo las mediciones de la media y la desviación estándar de cada medición.
# 3. Utilizar nombres descriptivos de las actividades para nombrar las actividades en el conjunto de datos.
# 4. Etiquetar adecuadamente el conjunto de datos con nombres descriptivos de las variables.
# 5. A partir del conjunto de datos del paso 4, crear un segundo conjunto de datos independiente y ordenado con el promedio de cada variable para cada actividad y cada sujeto.

# Cargar librerías necesarias
library(dplyr)

# Origen de los datos
#url_archivo <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Destino de los datos
#archivo_destino <- "HumanActivityRecognitionUsingSmartphones.zip"

# Definir rutas de datos
ruta_datos <- "./data"

# Obtener los datos
#if (!file.exists(file.path(ruta_datos, archivo_destino))) {
#  download.file(url_archivo, destfile = file.path(ruta_datos, archivo_destino))
#}


# Descomprimir los archivos
#unzip(zipfile = file.path(ruta_datos, archivo_destino), exdir = ruta_datos)


#ruta_datos <- paste(ruta_datos,"/UCI HAR Dataset",sep="")

# ============================================================================
# PASO 1: Fusionar los conjuntos de entrenamiento y prueba
# ============================================================================

# Leer datos de entrenamiento
X_entren <- read.table(file.path(ruta_datos, "train", "X_train.txt"))
y_entren <- read.table(file.path(ruta_datos, "train", "y_train.txt"))
sujeto_entren <- read.table(file.path(ruta_datos, "train", "subject_train.txt"))

# Leer datos de prueba
X_prueba <- read.table(file.path(ruta_datos, "test", "X_test.txt"))
y_prueba <- read.table(file.path(ruta_datos, "test", "y_test.txt"))
sujeto_prueba <- read.table(file.path(ruta_datos, "test", "subject_test.txt"))

# Leer etiquetas de características y actividades
caracteristicas <- read.table(file.path(ruta_datos, "features.txt"))
actrividades <- read.table(file.path(ruta_datos, "activity_labels.txt"))

# Fusionar datos de entrenamiento y prueba
X_fusionado <- rbind(X_entren, X_prueba)
y_fusionado <- rbind(y_entren, y_prueba)
sujeto_fusionado <- rbind(sujeto_entren, sujeto_prueba)

# Asignar nombres a las columnas
names(X_fusionado) <- caracteristicas$V2
names(y_fusionado) <- "actividad"
names(sujeto_fusionado) <- "sujeto"

# Crear el conjunto de datos completo
datos_completos <- cbind(sujeto_fusionado, y_fusionado, X_fusionado)

cat("Paso 1 completado: Datos fusionados\n")
cat("Dimensiones del conjunto de datos:", dim(datos_completos), "\n\n")

# ============================================================================
# PASO 2: Extraer solo las mediciones de media y desviación estándar
# ============================================================================

# Identificar columnas con mean() y std()
columnas_mean_std <- grep("mean\\(\\)|std\\(\\)", caracteristicas$V2, value = TRUE)

# Seleccionar solo las columnas relevantes (sujeto, actividad, mean y std)
datos_filtrados <- datos_completos %>%
  select(sujeto, actividad, all_of(columnas_mean_std))

cat("Paso 2 completado: Mediciones de media y desviación estándar extraídas\n")
cat("Número de variables seleccionadas:", length(columnas_mean_std), "\n\n")

# ============================================================================
# PASO 3: Usar nombres descriptivos para las actividades
# ============================================================================

# Asignar nombres descriptivos a las actividades
datos_filtrados$actividad <- factor(datos_filtrados$actividad,
                                     levels = actrividades$V1,
                                     labels = actrividades$V2)

cat("Paso 3 completado: Nombres descriptivos de actividades asignados\n")
cat("Actividades:", levels(datos_filtrados$actividad), "\n\n")

# ============================================================================
# PASO 4: Etiquetar el conjunto de datos con nombres descriptivos
# ============================================================================

# Crear nombres más descriptivos para las variables
nombres_descriptivos <- names(datos_filtrados)
nombres_descriptivos <- gsub("^t", "tiempo", nombres_descriptivos)
nombres_descriptivos <- gsub("^f", "frecuencia", nombres_descriptivos)
nombres_descriptivos <- gsub("Acc", "Acelerometro", nombres_descriptivos)
nombres_descriptivos <- gsub("Gyro", "Giroscopio", nombres_descriptivos)
nombres_descriptivos <- gsub("Mag", "Magnitud", nombres_descriptivos)
nombres_descriptivos <- gsub("Body", "Cuerpo", nombres_descriptivos)
nombres_descriptivos <- gsub("Gravity", "Gravedad", nombres_descriptivos)
nombres_descriptivos <- gsub("mean\\(\\)", "Media", nombres_descriptivos)
nombres_descriptivos <- gsub("std\\(\\)", "DesviacionEstandar", nombres_descriptivos)
nombres_descriptivos <- gsub("-", "", nombres_descriptivos)

# Asignar los nombres descriptivos
names(datos_filtrados) <- nombres_descriptivos

cat("Paso 4 completado: Nombres descriptivos de variables asignados\n")
cat("Primeras 5 variables:", head(names(datos_filtrados), 5), "\n\n")

# ============================================================================
# PASO 5: Crear conjunto de datos con el promedio por actividad y sujeto
# ============================================================================

# Calcular el promedio de cada variable para cada actividad y sujeto
datos_resumen <- datos_filtrados %>%
  group_by(sujeto, actividad) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  arrange(sujeto, actividad)

cat("Paso 5 completado: Conjunto de datos resumen creado\n")
cat("Dimensiones del resumen:", dim(datos_resumen), "\n")
cat("Registros por sujeto:", nrow(datos_resumen) / length(unique(datos_resumen$sujeto)), "\n\n")

# ============================================================================
# EXPORTAR RESULTADOS
# ============================================================================

# Guardar el conjunto de datos ordenado
write.table(datos_resumen, 
            file = "datos_resumen_tidy.txt", 
            row.names = FALSE,
            quote = FALSE)

cat("Archivo 'datos_resumen_tidy.txt' creado exitosamente\n")

# Mostrar vista previa de los datos
cat("\nVista previa de los primeros registros:\n")
print(head(datos_resumen[, 1:6], 10))


