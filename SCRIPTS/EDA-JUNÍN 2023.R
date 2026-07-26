# ============================================================
# PROYECTO FINAL - ANÁLISIS EXPLORATORIO DE DATOS (EDA)
# Base de datos: ENAHO 2023 - Módulos 5 y 34 - INEI
# Autora: Rojas Quinto Ana Nilda
# Título: Análisis Socioeconómico de los Hogares de Junín, 2023
# ============================================================

# ============================================================
# 1. CONFIGURACIÓN INICIAL
# ============================================================

# 1.1 LIMPIAR EL ENTORNO
rm(list = ls())  # Eliminar todos los objetos del entorno
gc()             # Liberar memoria

# 1.2 CONFIGURAR DIRECTORIO DE TRABAJO
setwd("D:/R-STUDIO/Proyecto-Final/data")

# 1.3 CARGAR PAQUETES
library(haven)      # Para leer archivos .sav
library(tidyverse)  # Para manipulación de datos
library(patchwork)  # Para combinar gráficos
library(psych)      # Para estadísticas descriptivas
library(scales)     # Para formato de números

# 1.4 VERIFICAR ARCHIVOS DISPONIBLES
print("=== ARCHIVOS DISPONIBLES ===")
list.files()

# ============================================================
# 2. IMPORTAR DATOS DE ENAHO 2023 - MÓDULOS 5 Y 34
# ============================================================

# 2.1 IMPORTAR MÓDULO 5 (INGRESOS)
modulo5 <- read_sav("enaho01a-2023-500.sav")

# 2.2 IMPORTAR SUMARIA (RESUMEN DEL HOGAR)
sumaria <- read_sav("Sumaria-2023.sav")

# 2.3 VERIFICAR IMPORTACIÓN
print("=== MÓDULO 5 (INGRESOS) ===")
glimpse(modulo5)

print("=== SUMARIA (RESUMEN) ===")
glimpse(sumaria)

# Ver dimensiones
print(paste("Módulo 5:", dim(modulo5)[1], "filas y", dim(modulo5)[2], "columnas"))
print(paste("Sumaria:", dim(sumaria)[1], "filas y", dim(sumaria)[2], "columnas"))

# ============================================================
# 3. IDENTIFICACIÓN DE VARIABLES CLAVE
# ============================================================

# 3.1 VER NOMBRES DE VARIABLES
print("=== NOMBRES DE VARIABLES - MÓDULO 5 ===")
names(modulo5)[1:30]

print("=== NOMBRES DE VARIABLES - SUMARIA ===")
names(sumaria)[1:30]

# 3.2 BUSCAR VARIABLES DE IDENTIFICACIÓN (claves para unir)
print("=== BUSCANDO VARIABLES DE IDENTIFICACIÓN EN MÓDULO 5 ===")
grep("conglome|vivienda|hogar|año|anio", names(modulo5), value = TRUE, ignore.case = TRUE)

print("=== BUSCANDO VARIABLES DE IDENTIFICACIÓN EN SUMARIA ===")
grep("conglome|vivienda|hogar|año|anio", names(sumaria), value = TRUE, ignore.case = TRUE)

# 3.3 VER VALORES DE VARIABLES CLAVE
print("=== PRIMEROS VALORES - MÓDULO 5 ===")
head(modulo5[, c("CONGLOME", "VIVIENDA", "HOGAR")])

print("=== PRIMEROS VALORES - SUMARIA ===")
head(sumaria[, c("CONGLOME", "VIVIENDA", "HOGAR")])

# 3.4 BUSCAR VARIABLES DEMOGRÁFICAS
print("=== VARIABLES DEMOGRÁFICAS - MÓDULO 5 ===")
grep("p204|p205|p207|p208|sexo|edad|educ|nivel", names(modulo5), value = TRUE, ignore.case = TRUE)

# 3.5 BUSCAR VARIABLES DE INGRESO
print("=== VARIABLES DE INGRESO - MÓDULO 5 ===")
grep("p510|p513|ingreso|ingres|p500|p550", names(modulo5), value = TRUE, ignore.case = TRUE)

# 3.6 BUSCAR VARIABLES GEOGRÁFICAS
print("=== VARIABLES GEOGRÁFICAS - SUMARIA ===")
grep("ubigeo|depart|provincia|distrito|region", names(sumaria), value = TRUE, ignore.case = TRUE)

# 3.7 BUSCAR VARIABLES DE POBREZA
print("=== VARIABLES DE POBREZA - SUMARIA ===")
grep("pobreza|pobre|linea", names(sumaria), value = TRUE, ignore.case = TRUE)

# 3.8 BUSCAR VARIABLES DE GASTO
print("=== VARIABLES DE GASTO - SUMARIA ===")
grep("gasto|gashog", names(sumaria), value = TRUE, ignore.case = TRUE)

# 3.9 BUSCAR FACTORES DE EXPANSIÓN
print("=== FACTORES DE EXPANSIÓN ===")
grep("factor|pond|peso", names(sumaria), value = TRUE, ignore.case = TRUE)

# ============================================================
# 4. CREAR IDENTIFICADOR ÚNICO PARA CADA HOGAR
# ============================================================

# 4.1 CREAR ID_HOGAR EN MÓDULO 5
modulo5 <- modulo5 %>%
  mutate(ID_HOGAR = paste(CONGLOME, VIVIENDA, HOGAR, sep = "_"))

# 4.2 CREAR ID_HOGAR EN SUMARIA
sumaria <- sumaria %>%
  mutate(ID_HOGAR = paste(CONGLOME, VIVIENDA, HOGAR, sep = "_"))

# 4.3 VERIFICAR
print("=== ID_HOGAR EN MÓDULO 5 ===")
head(modulo5$ID_HOGAR, 10)

print("=== ID_HOGAR EN SUMARIA ===")
head(sumaria$ID_HOGAR, 10)

# 4.4 CONTAR IDs ÚNICOS
print(paste("IDs únicos en módulo 5:", length(unique(modulo5$ID_HOGAR))))
print(paste("IDs únicos en sumaria:", length(unique(sumaria$ID_HOGAR))))

# 4.5 VERIFICAR COINCIDENCIAS
ids_modulo5 <- unique(modulo5$ID_HOGAR)
ids_sumaria <- unique(sumaria$ID_HOGAR)
coincidencias <- intersect(ids_modulo5, ids_sumaria)
print(paste("IDs que coinciden entre bases:", length(coincidencias)))

# ============================================================
# 5. UNIR BASES DE DATOS
# ============================================================

# 5.1 UNIR MÓDULO 5 CON SUMARIA
datos_completos <- modulo5 %>%
  left_join(sumaria, by = "ID_HOGAR")

# 5.2 VERIFICAR LA UNIÓN
print(paste("Datos completos:", dim(datos_completos)[1], "filas y", 
            dim(datos_completos)[2], "columnas"))

# 5.3 VER NOMBRES DE VARIABLES
print("=== PRIMERAS VARIABLES EN DATOS COMPLETOS ===")
names(datos_completos)[1:20]

# 5.4 CONTAR VALORES FALTANTES
print("=== VALORES FALTANTES POR VARIABLE (primeras 10) ===")
colSums(is.na(datos_completos))[1:10]

# ============================================================
# 6. IDENTIFICAR VARIABLES ESPECÍFICAS PARA ANÁLISIS
# ============================================================

# 6.1 VER TODAS LAS VARIABLES DISPONIBLES
print("=== TODAS LAS VARIABLES EN DATOS COMPLETOS ===")
names(datos_completos)[1:50]

# 6.2 BUSCAR VARIABLES DE INTERÉS

# Variables del hogar (miembros, perceptores)
print("=== VARIABLES DEL HOGAR ===")
grep("mieperho|percepho|nmiem|miembro|perceptor", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# Variables de ingreso del hogar
print("=== VARIABLES DE INGRESO DEL HOGAR ===")
grep("inghog|ingresohog|total_ing|ing_tot", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# Variables de gasto del hogar
print("=== VARIABLES DE GASTO DEL HOGAR ===")
grep("gashog|gastohog|total_gas|gas_tot", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# Variables de ubicación geográfica
print("=== VARIABLES DE UBICACIÓN ===")
grep("ubigeo|depart|provinci|distrit|region", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# Variables de pobreza
print("=== VARIABLES DE POBREZA ===")
grep("pobreza|pobre|linea|lp", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# Variables de vivienda
print("=== VARIABLES DE VIVIENDA ===")
grep("p301|p302|p303|p304|p305|p306|p307|p310|vivienda|agua|sanitario|material", 
     names(datos_completos), value = TRUE, ignore.case = TRUE)

# Variables demográficas
print("=== VARIABLES DEMOGRÁFICAS ===")
grep("p204|p205|p207|p208|p209|sexo|edad|educ|nivel", names(datos_completos), 
     value = TRUE, ignore.case = TRUE)

# ============================================================
# 7. FILTRAR DATOS DE LA REGIÓN JUNÍN
# ============================================================

# 7.1 CREAR VARIABLE DE DEPARTAMENTO USANDO UBIGEO.x
datos_completos <- datos_completos %>%
  mutate(DEPARTAMENTO = substr(as.character(UBIGEO.x), 1, 2))

# 7.2 VER CÓDIGOS DE DEPARTAMENTO
print("=== CÓDIGOS DE DEPARTAMENTO (UBIGEO) ===")
print(sort(unique(datos_completos$DEPARTAMENTO)))

# 7.3 VER OBSERVACIONES POR DEPARTAMENTO
print("=== OBSERVACIONES POR DEPARTAMENTO ===")
table(datos_completos$DEPARTAMENTO)

# 7.4 FILTRAR JUNÍN (CÓDIGO 12)
junin <- datos_completos %>%
  filter(DEPARTAMENTO == "12")

# 7.5 VERIFICAR
print(paste("Observaciones de Junín:", dim(junin)[1], "filas"))
print("=== PRIMERAS OBSERVACIONES DE JUNÍN ===")
head(junin[, c("ID_HOGAR", "UBIGEO.x", "DEPARTAMENTO")])

# ============================================================
# 8. SELECCIÓN DE VARIABLES PARA ANÁLISIS
# ============================================================

# 8.1 SELECCIONAR VARIABLES DE INTERÉS
eda_junin <- junin %>%
  select(
    # Identificación
    ID_HOGAR,
    CONGLOME.x,
    VIVIENDA.x,
    HOGAR.x,
    UBIGEO.x,
    DEPARTAMENTO,
    
    # Variables del hogar (de sumaria)
    MIEPERHO,      # Miembros del hogar
    PERCEPHO,      # Perceptores de ingreso
    INGHOG1D,      # Ingreso del hogar (anual)
    GASHOG1D,      # Gasto del hogar (anual)
    
    # Variables de pobreza
    POBREZA,       # Condición de pobreza
    LINEA,         # Línea de pobreza
    LINEAV,        # Línea de pobreza extendida
    POBREZAV,      # Pobreza extendida
    
    # Factor de expansión
    FACTOR07,      # Factor de ponderación
    
    # Variables demográficas (del módulo 5)
    P204,          # Sexo
    P205,          # Edad
    P207,          # Relación de parentesco
    P208A,         # Nivel educativo (años)
    P209,          # Nivel educativo (categoría)
    
    # Variables de vivienda
    P301A,         # Tipo de vivienda
    
    # Variables de ingreso (para desagregar)
    INGMO1HD,      # Ingreso monetario
    INGMO2HD,      # Ingreso no monetario
    INGHOG2D       # Ingreso total alternativo
  )

# 8.2 VERIFICAR LA BASE SELECCIONADA
print("=== ESTRUCTURA DE LA BASE DE ANÁLISIS (Junín) ===")
glimpse(eda_junin)

print("=== DIMENSIONES DE LA BASE DE ANÁLISIS ===")
print(dim(eda_junin))

print("=== RESUMEN DE LA BASE DE ANÁLISIS ===")
summary(eda_junin)

# 8.3 VERIFICAR VALORES FALTANTES
print("=== VALORES FALTANTES POR VARIABLE ===")
colSums(is.na(eda_junin))

# ============================================================
# 9. CREACIÓN DE NUEVAS VARIABLES DERIVADAS
# ============================================================

eda_junin <- eda_junin %>%
  mutate(
    # Ingreso y gasto per cápita
    INGRESO_PCAPITA = INGHOG1D / MIEPERHO,
    GASTO_PCAPITA = GASHOG1D / MIEPERHO,
    
    # Logaritmo de ingreso per cápita (para normalizar)
    LOG_INGRESO = log(INGRESO_PCAPITA + 1),
    
    # Clasificación de pobreza
    POBREZA_CATEGORIA = case_when(
      POBREZA == 0 ~ "No pobre",
      POBREZA == 1 ~ "Pobre",
      POBREZA == 2 ~ "Pobre extremo",
      TRUE ~ "Sin información"
    ),
    
    # Clasificación de sexo
    SEXO_CATEGORIA = case_when(
      P204 == 1 ~ "Hombre",
      P204 == 2 ~ "Mujer",
      TRUE ~ "Sin información"
    ),
    
    # Categoría de edad
    CATEGORIA_EDAD = case_when(
      P205 < 18 ~ "Niño/Adolescente (0-17)",
      P205 >= 18 & P205 < 30 ~ "Joven (18-29)",
      P205 >= 30 & P205 < 45 ~ "Adulto Joven (30-44)",
      P205 >= 45 & P205 < 60 ~ "Adulto (45-59)",
      P205 >= 60 ~ "Adulto Mayor (60+)",
      TRUE ~ "Sin información"
    ),
    
    # Tamaño del hogar categorizado
    TAMANO_HOGAR = case_when(
      MIEPERHO <= 2 ~ "Pequeño (1-2)",
      MIEPERHO <= 4 ~ "Mediano (3-4)",
      MIEPERHO <= 6 ~ "Grande (5-6)",
      MIEPERHO > 6 ~ "Muy grande (7+)"
    ),
    
    # Quintiles de ingreso per cápita
    QUINTIL_INGRESO = ntile(INGRESO_PCAPITA, 5),
    
    # Deciles de ingreso per cápita
    DECIL_INGRESO = ntile(INGRESO_PCAPITA, 10),
    
    # Ratio gasto/ingreso
    RATIO_GASTO_INGRESO = GASTO_PCAPITA / INGRESO_PCAPITA,
    
    # Ingreso per cápita en soles mensuales
    INGRESO_PCAPITA_MENSUAL = INGRESO_PCAPITA / 12,
    GASTO_PCAPITA_MENSUAL = GASTO_PCAPITA / 12
  )

# 9.1 VERIFICAR NUEVAS VARIABLES
print("=== NUEVAS VARIABLES CREADAS ===")
eda_junin %>%
  select(ID_HOGAR, MIEPERHO, INGHOG1D, INGRESO_PCAPITA, 
         GASHOG1D, GASTO_PCAPITA, POBREZA_CATEGORIA, 
         SEXO_CATEGORIA, CATEGORIA_EDAD, TAMANO_HOGAR) %>%
  head(10)

# 9.2 VERIFICAR VALORES INFINITOS O EXTRAÑOS
print("=== VALORES INFINITOS ===")
sum(is.infinite(eda_junin$INGRESO_PCAPITA))
sum(is.infinite(eda_junin$GASTO_PCAPITA))
sum(is.infinite(eda_junin$RATIO_GASTO_INGRESO))

print("=== VALORES NA EN VARIABLES CLAVE ===")
colSums(is.na(eda_junin[, c("INGRESO_PCAPITA", "GASTO_PCAPITA", "POBREZA")]))

# 9.3 FILTRAR DATOS PARA ANÁLISIS (eliminar NAs)
eda_analisis <- eda_junin %>%
  filter(!is.na(INGRESO_PCAPITA), !is.na(POBREZA))

print(paste("Observaciones después de filtrar NAs:", dim(eda_analisis)[1]))

# ============================================================
# 10. ESTADÍSTICAS DESCRIPTIVAS
# ============================================================

# 10.1 ESTADÍSTICAS BÁSICAS
print("=== ESTADÍSTICAS DESCRIPTIVAS BÁSICAS ===")
summary(eda_analisis[, c("MIEPERHO", "PERCEPHO", "INGHOG1D", 
                         "GASHOG1D", "INGRESO_PCAPITA", "GASTO_PCAPITA")])

# 10.2 ESTADÍSTICAS POR POBREZA
print("=== ESTADÍSTICAS POR CONDICIÓN DE POBREZA ===")
tabla_pobreza <- eda_analisis %>%
  group_by(POBREZA_CATEGORIA) %>%
  summarise(
    N = n(),
    Porcentaje = round(n() / nrow(eda_analisis) * 100, 2),
    Ingreso_pc_promedio = mean(INGRESO_PCAPITA, na.rm = TRUE),
    Ingreso_pc_mediana = median(INGRESO_PCAPITA, na.rm = TRUE),
    Gasto_pc_promedio = mean(GASTO_PCAPITA, na.rm = TRUE),
    Miembros_promedio = mean(MIEPERHO, na.rm = TRUE)
  )
print(tabla_pobreza)

# 10.3 ESTADÍSTICAS POR TAMAÑO DE HOGAR
print("=== ESTADÍSTICAS POR TAMAÑO DE HOGAR ===")
tabla_tamano <- eda_analisis %>%
  group_by(TAMANO_HOGAR) %>%
  summarise(
    N = n(),
    Porcentaje = round(n() / nrow(eda_analisis) * 100, 2),
    Ingreso_pc_promedio = mean(INGRESO_PCAPITA, na.rm = TRUE),
    Pobreza_porcentaje = mean(POBREZA %in% c(1, 2), na.rm = TRUE) * 100
  )
print(tabla_tamano)

# 10.4 ESTADÍSTICAS POR SEXO
print("=== ESTADÍSTICAS POR SEXO ===")
eda_analisis %>%
  group_by(SEXO_CATEGORIA) %>%
  summarise(
    N = n(),
    Ingreso_pc_promedio = mean(INGRESO_PCAPITA, na.rm = TRUE),
    Ingreso_pc_mediana = median(INGRESO_PCAPITA, na.rm = TRUE)
  )


# 10.5 GUARDAR ESTADÍSTICAS
write.csv(tabla_pobreza, "D:/R-STUDIO/Proyecto-Final/data/tabla_pobreza.csv", row.names = FALSE)
write.csv(tabla_tamano, "D:/R-STUDIO/Proyecto-Final/data/tabla_tamano_hogar.csv", row.names = FALSE)
# Verificar archivos guardados
print("=== ARCHIVOS GUARDADOS EN data ===")
list.files("D:/R-STUDIO/Proyecto-Final/data")
# ============================================================
# 11. VISUALIZACIÓN DE DATOS CON GGPLOT2
# ============================================================
# ============================================================
# 11.1 GRÁFICO 1: DISTRIBUCIÓN DEL INGRESO PER CÁPITA
# ============================================================

# Calcular estadísticas
media_ingreso <- mean(eda_analisis$INGRESO_PCAPITA, na.rm = TRUE)
mediana_ingreso <- median(eda_analisis$INGRESO_PCAPITA, na.rm = TRUE)
limite_ingreso <- quantile(eda_analisis$INGRESO_PCAPITA, 0.95, na.rm = TRUE)

grafico1 <- ggplot(eda_analisis, aes(x = INGRESO_PCAPITA)) +
  geom_histogram(
    bins = 40,
    fill = "#2E86AB",
    color = "white",
    alpha = 0.8,
    na.rm = TRUE
  ) +
  geom_vline(aes(xintercept = media_ingreso),
             color = "#A23B72", linetype = "dashed", size = 1.2) +
  geom_vline(aes(xintercept = mediana_ingreso),
             color = "#F18F01", linetype = "dotted", size = 1.2) +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(0, limite_ingreso)
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Distribución del Ingreso Per Cápita de Hogares de Junín",
    subtitle = paste0("Media: S/. ", round(media_ingreso, 0), 
                      " | Mediana: S/. ", round(mediana_ingreso, 0)),
    x = "Ingreso per cápita (S/.)",
    y = "Número de hogares",
    caption = "Fuente: INEI - ENAHO 2023 | Elaboración propia"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5, color = "#1B4965"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#4A4A4A"),
    plot.caption = element_text(size = 9, hjust = 1, color = "#6C6C6C", face = "italic"),
    axis.title = element_text(size = 12, face = "bold", color = "#2C3E50"),
    axis.text = element_text(size = 10, color = "#34495E"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#ECF0F1", linetype = "dotted"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

print(grafico1)

# ============================================================
# 11.2 GRÁFICO 2: RELACIÓN INGRESO-GASTO PER CÁPITA
# ============================================================

# Calcular estadísticas
correlacion <- cor(eda_analisis$INGRESO_PCAPITA, eda_analisis$GASTO_PCAPITA, 
                   use = "complete.obs")
limite_x <- quantile(eda_analisis$INGRESO_PCAPITA, 0.95, na.rm = TRUE)
limite_y <- quantile(eda_analisis$GASTO_PCAPITA, 0.95, na.rm = TRUE)

grafico2 <- ggplot(eda_analisis, 
                   aes(x = INGRESO_PCAPITA, y = GASTO_PCAPITA)) +
  geom_point(alpha = 0.3, color = "#2E86AB", size = 1.5, na.rm = TRUE) +
  geom_smooth(method = "lm", color = "#A23B72", se = TRUE, 
              fill = "#A23B72", alpha = 0.2, na.rm = TRUE) +
  geom_abline(intercept = 0, slope = 1, 
              linetype = "dashed", color = "gray50", alpha = 0.5) +
  scale_x_continuous(labels = scales::comma, limits = c(0, limite_x)) +
  scale_y_continuous(labels = scales::comma, limits = c(0, limite_y)) +
  labs(
    title = "Relación entre Ingreso y Gasto Per Cápita",
    subtitle = paste0("Correlación: r = ", round(correlacion, 3), 
                      " | R² = ", round(correlacion^2, 3)),
    x = "Ingreso per cápita (S/.)",
    y = "Gasto per cápita (S/.)",
    caption = "Fuente: INEI - ENAHO 2023 | Elaboración propia"
  ) +
  annotate("text",
           x = limite_x * 0.7,
           y = limite_y * 0.1,
           label = "Línea de igualdad\n(ingreso = gasto)",
           color = "gray50", size = 3.5, fontface = "italic") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5, color = "#1B4965"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#4A4A4A"),
    plot.caption = element_text(size = 9, hjust = 1, color = "#6C6C6C", face = "italic"),
    axis.title = element_text(size = 12, face = "bold", color = "#2C3E50"),
    axis.text = element_text(size = 10, color = "#34495E"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#ECF0F1", linetype = "dotted"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

print(grafico2)


# ============================================================
# 11.3 GRÁFICO 3: INGRESO PER CÁPITA PROMEDIO SEGÚN POBREZA
# ============================================================

# Calcular estadísticas por pobreza
estadisticas_pobreza <- eda_analisis %>%
  filter(!is.na(POBREZA_CATEGORIA)) %>%
  group_by(POBREZA_CATEGORIA) %>%
  summarise(
    N = n(),
    Media = mean(INGRESO_PCAPITA, na.rm = TRUE),
    Mediana = median(INGRESO_PCAPITA, na.rm = TRUE),
    Min = min(INGRESO_PCAPITA, na.rm = TRUE),
    Max = max(INGRESO_PCAPITA, na.rm = TRUE),
    .groups = 'drop'
  )

# Ordenar categorías
estadisticas_pobreza <- estadisticas_pobreza %>%
  mutate(POBREZA_CATEGORIA = factor(POBREZA_CATEGORIA, 
                                    levels = c("No pobre", "Pobre", "Pobre extremo")))

grafico4 <- ggplot(estadisticas_pobreza, 
                   aes(x = POBREZA_CATEGORIA, y = Media, 
                       fill = POBREZA_CATEGORIA)) +
  geom_col(alpha = 0.8, width = 0.7) +
  geom_errorbar(aes(ymin = Media - 200, ymax = Media + 200), 
                width = 0.2, color = "#2C3E50") +
  geom_text(aes(label = paste0("S/.", format(round(Media, 0), big.mark = ","))),
            vjust = -0.5, size = 4.5, fontface = "bold") +
  geom_text(aes(label = paste0("n = ", N)),
            vjust = 1.5, size = 3.5, color = "white") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(
    values = c("No pobre" = "#1B4965", 
               "Pobre" = "#2E86AB", 
               "Pobre extremo" = "#A23B72")
  ) +
  labs(
    title = "Ingreso Per Cápita Promedio según Condición de Pobreza",
    subtitle = "Brecha significativa entre hogares no pobres y pobres extremos",
    x = "Condición de Pobreza",
    y = "Ingreso per cápita promedio (S/.)",
    caption = "Fuente: INEI - ENAHO 2023 | Elaboración propia"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5, color = "#1B4965"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#4A4A4A"),
    plot.caption = element_text(size = 9, hjust = 1, color = "#6C6C6C", face = "italic"),
    axis.title = element_text(size = 12, face = "bold", color = "#2C3E50"),
    axis.text = element_text(size = 10, color = "#34495E"),
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#ECF0F1", linetype = "dotted"),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = )
  )

print(grafico4)

# ============================================================
# GUARDAR TODOS LOS GRÁFICOS
# ============================================================

# Guardar gráficos individuales
ggsave("D:/R-STUDIO/Proyecto-Final/figures/grafico_01_ingreso_percapita.png",
       plot = grafico1, width = 10, height = 7, dpi = 300)

ggsave("D:/R-STUDIO/Proyecto-Final/figures/grafico_02_ingreso_vs_gasto.png",
       plot = grafico2, width = 10, height = 7, dpi = 300)

ggsave("D:/R-STUDIO/Proyecto-Final/figures/grafico_03_pobreza.png",
       plot = grafico4, width = 10, height = 7, dpi = 300)

# ============================================================
# CREAR COLLAGE CON LOS 3 GRÁFICOS
# ============================================================

# Cargar patchwork si no está cargado
library(patchwork)

# Collage con 3 gráficos (arriba 2, abajo 1)
collage_3 <- (grafico1 + grafico2) / grafico4 +
  plot_annotation(
    title = "Análisis Exploratorio de Hogares de Junín - ENAHO 2023",
    subtitle = "Distribución de ingresos, relación ingreso-gasto y condiciones de pobreza",
    caption = "Elaboración propia con datos del INEI",
    theme = theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, color = "#1B4965"),
      plot.subtitle = element_text(size = 14, hjust = 0.5, color = "#4A4A4A"),
      plot.caption = element_text(size = 10, hjust = 1, color = "#6C6C6C", face = "italic")
    )
  )

# Mostrar collage
print(collage_3)

# Guardar collage
ggsave("D:/R-STUDIO/Proyecto-Final/figures/collage_3_graficos.png",
       plot = collage_3, width = 14, height = 12, dpi = 300)

# ============================================================
# VERIFICAR GRÁFICOS GUARDADOS
# ============================================================

print("=== GRÁFICOS GUARDADOS ===")
list.files("D:/R-STUDIO/Proyecto-Final/figures")

print("=== RUTA DE LOS GRÁFICOS ===")
print("D:/R-STUDIO/Proyecto-Final/figures/")

print("¡Todos los gráficos guardados exitosamente!")























































