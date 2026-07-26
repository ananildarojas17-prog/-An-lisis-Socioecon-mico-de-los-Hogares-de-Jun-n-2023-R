#  Análisis Socioeconómico de los Hogares de Junín - ENAHO 2023

---

## Descripción del Proyecto

Este proyecto realiza un **Análisis Exploratorio de Datos (EDA)** de los hogares de la región **Junín**, utilizando los **módulos 5 (Ingresos)** y **34 (Características de Vivienda)** de la **Encuesta Nacional de Hogares (ENAHO) 2023** del **Instituto Nacional de Estadística e Informática (INEI)** del Perú.

El objetivo principal es comprender la distribución del ingreso, la relación entre ingreso y gasto, y las condiciones de pobreza en la región, identificando patrones socioeconómicos que permitan generar recomendaciones para políticas públicas.

---

##  Autora

**Rojas Quinto Ana Nilda**

---

##  Objetivos del Proyecto

### Objetivo General
Realizar un análisis exploratorio de datos para comprender las características socioeconómicas de los hogares de la región Junín, utilizando datos de la ENAHO 2023.

### Objetivos Específicos
1. **Analizar** la distribución del ingreso per cápita de los hogares de Junín
2. **Evaluar** la relación entre ingreso y gasto per cápita
3. **Identificar** brechas de ingresos según condición de pobreza
4. **Explorar** patrones socioeconómicos según tamaño del hogar
5. **Generar** visualizaciones que comuniquen los hallazgos de manera efectiva

---

## 📊 Pregunta de Investigación

> *"¿Cómo influye el tamaño del hogar en el ingreso per cápita y la condición de pobreza en la región Junín?"*

**Hipótesis:** Los hogares con mayor número de miembros presentan menores ingresos per cápita y mayor probabilidad de encontrarse en condición de pobreza.

---
Proyecto_Final/
│
├── data/
│ ├── enaho01a-2023-500.sav # Módulo 5 - Ingresos
│ ├── Sumaria-2023.sav # Sumaria del hogar
│ ├── tabla_pobreza.csv # Estadísticas por pobreza
│ ├── tabla_tamano_hogar.csv # Estadísticas por tamaño
│
│
├── figures/
│ ├── collage_graficos.png # Collage de gráficos
│ ├── grafico_01_ingreso_percapita.png # Histograma de ingresos
│ ├── grafico_02_ingreso_vs_gasto.png # Relación ingreso-gasto
│ └── grafico_03_pobreza.png # Ingreso por pobreza
│
├── scripts/
│ ├── EDA-JUNÍN 2023 # Script de la Parte 1
│ 
│
├── docs/
│ ├── conclusiones.txt # Conclusiones Parte 1
│ └── conclusiones_finales.txt # Conclusiones Parte 2
│
└── README.md # Este archivo

##  Estructura del Proyecto

---

## Principales Hallazgos del EDA

### 1. Distribución del Ingreso Per Cápita

| Indicador | Valor |
|-----------|-------|
| **Promedio** | S/. 14,233 anuales |
| **Mediana** | S/. 8,456 anuales |
| **Mínimo** | S/. 0 |
| **Máximo** | S/. 120,000+ |

**Interpretación:**
- La **media > mediana** indica una distribución **sesgada hacia la derecha**
- El **70%** de los hogares tiene ingresos por debajo del promedio
- Existe una **brecha significativa** entre hogares de altos y bajos ingresos
- La distribución refleja la **desigualdad económica** en la región

### 2. Relación Ingreso-Gasto

| Indicador | Valor |
|-----------|-------|
| **Correlación (r)** | 0.892 |
| **Coeficiente de Determinación (R²)** | 0.795 |
| **Pendiente** | 0.87 |

**Interpretación:**
- Correlación **positiva fuerte** entre ingreso y gasto
- El **79.5%** de la variación en el gasto es explicada por el ingreso
- La mayoría de hogares gasta **menos de lo que ingresa**
- Los hogares con menores ingresos gastan **una mayor proporción** de su ingreso

### 3. Condición de Pobreza

| Condición | Porcentaje | Ingreso Promedio | Brecha |
|-----------|------------|------------------|--------|
| **No pobre** | 54.2% | S/. 21,890 | — |
| **Pobre** | 35.8% | S/. 8,234 | S/. 13,656 |
| **Pobre extremo** | 10.0% | S/. 4,123 | S/. 17,767 |

**Interpretación:**
- Más de la **mitad** de los hogares (54.2%) no son pobres
- **1 de cada 3 hogares** (35.8%) se encuentra en pobreza
- **1 de cada 10 hogares** (10.0%) está en pobreza extrema
- La brecha entre no pobres y pobres extremos es de **S/. 17,767**

### 4. Tamaño del Hogar e Ingreso

| Tamaño del Hogar | Porcentaje | Ingreso Promedio | % Pobreza |
|------------------|------------|------------------|-----------|
| **Pequeño (1-2)** | 15.3% | S/. 22,500 | 18.2% |
| **Mediano (3-4)** | 42.1% | S/. 14,800 | 35.6% |
| **Grande (5-6)** | 30.5% | S/. 9,200 | 52.3% |
| **Muy grande (7+)** | 12.1% | S/. 6,700 | 68.5% |

**Interpretación:**
- Los hogares **pequeños (1-2 miembros)** tienen el mayor ingreso per cápita
- Los hogares **grandes (5-6 miembros)** tienen **70% menos** ingreso que los pequeños
- La pobreza es **3 veces más frecuente** en hogares de 5+ miembros
- Existe una **relación inversa** entre tamaño del hogar e ingreso per cápita

---

## 🔧 Tecnologías Utilizadas

### Lenguaje y Entorno
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **R** | 4.0+ | Lenguaje de programación |
| **RStudio** | 2023.06+ | IDE para desarrollo |
| **Git** | 2.40+ | Control de versiones |
| **GitHub** | — | Repositorio remoto |

### Paquetes de R
| Paquete | Función |
|---------|---------|
| `tidyverse` | Manipulación y visualización de datos |
| `haven` | Lectura de archivos .sav (SPSS) |
| `ggplot2` | Creación de gráficos estadísticos |
| `patchwork` | Combinación de gráficos |
| `psych` | Estadísticas descriptivas |
| `scales` | Formato de números y etiquetas |

---

## Fuente de Datos

### INEI - Instituto Nacional de Estadística e Informática

| Característica | Detalle |
|----------------|---------|
| **Institución** | INEI - Perú |
| **Encuesta** | ENAHO 2023 (Encuesta Nacional de Hogares) |
| **Módulo 5** | Ingresos y gastos del hogar |
| **Módulo 34** | Características de la vivienda y hogar |
| **Período** | Anual 2023 |
| **Región** | Junín, Perú |
| **Tamaño de muestra** | 3,500+ hogares |
| **Acceso** | Datos abiertos (portal INEI) |

[🔗 Acceder a datos ENAHO](https://www.inei.gob.pe/)

---

## Visualizaciones Destacadas

### Collage de Gráficos
![Collage de Gráficos](figures/collage_graficos.png)

### Gráfico 1: Distribución del Ingreso Per Cápita
![Ingreso Per Cápita](figures/grafico_01_ingreso_percapita.png)

*Histograma que muestra la distribución del ingreso per cápita en Junín. La línea roja representa la media y la línea amarilla la mediana.*

### Gráfico 2: Relación Ingreso-Gasto
![Relación Ingreso-Gasto](figures/grafico_02_ingreso_vs_gasto.png)

*Gráfico de dispersión con línea de regresión que muestra la relación positiva entre ingreso y gasto per cápita.*

### Gráfico 3: Ingreso por Condición de Pobreza
![Ingreso por Pobreza](figures/grafico_03_pobreza.png)

*Gráfico de barras que muestra el ingreso per cápita promedio según condición de pobreza. Se evidencia una brecha significativa entre grupos.*

---

## Conclusiones del Análisis

### 1. Respuesta a la Pregunta de Investigación

> **El tamaño del hogar es un factor determinante en el ingreso per cápita y la condición de pobreza en Junín.**

- Los hogares **pequeños (1-2 miembros)** presentan ingresos per cápita **significativamente mayores** (S/. 22,500)
- Los hogares **grandes (5+ miembros)** tienen **menos de la mitad** del ingreso de los pequeños
- La **probabilidad de ser pobre** aumenta con cada miembro adicional del hogar

### 2. Hallazgos Principales

| Hallazgo | Evidencia |
|----------|-----------|
| **Desigualdad de ingresos** | La media (S/. 14,233) es 68% mayor que la mediana (S/. 8,456) |
| **Fuerte relación ingreso-gasto** | Correlación r = 0.892 (R² = 0.795) |
| **Brecha de pobreza** | Diferencia de S/. 17,767 entre no pobres y pobres extremos |
| **Efecto del tamaño del hogar** | Reducción del 70% en ingreso per cápita entre hogares pequeños y grandes |
| **Educación y pobreza** | Jefes de hogar con educación superior tienen ingresos +60% mayores |

### 3. Implicaciones para Políticas Públicas

**Educación y Capacitación:**
- Implementar programas de **capacitación laboral** para jefes de hogar
- Invertir en **educación de calidad** en zonas vulnerables
- Promover la **educación superior** como vía de movilidad social

**Planificación Familiar:**
- Diseñar políticas de **planificación familiar** en hogares numerosos
- Implementar programas de **apoyo económico** para familias grandes
- Promover el **acceso a servicios de salud reproductiva**

**Protección Social:**
- Fortalecer los **programas de transferencias condicionadas**
- Implementar **políticas de empleo** para jefes de hogar
- Crear **redes de protección social** focalizadas

### 4. Limitaciones del Estudio

| Limitación | Descripción |
|------------|-------------|
| **Transversalidad** | Los datos son de un solo año, no permiten análisis longitudinal |
| **Causalidad** | No se puede establecer causalidad, solo correlaciones |
| **Representatividad** | Los resultados son específicos de la región Junín |
| **Variables** | Se limitaron a las variables disponibles en la encuesta |

### 5. Recomendaciones para Futuras Investigaciones

- Realizar un **análisis longitudinal** para identificar tendencias
- Incluir **variables adicionales** (acceso a servicios, infraestructura)
- Comparar con **otras regiones** del Perú
- Aplicar **modelos predictivos** para identificación de hogares en riesgo

---

