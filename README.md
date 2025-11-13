# Analisis_Defunciones_DEIS
Repositorio dedicado al análisis de datos de defunciones ocurridas en chile entre el años 2022 y 2025 (octubre)

El conjunto de datos lo puedes descargar aquí: https://drive.google.com/file/d/1qyD8Uc6QmCcAYfBD3iPKKJCSz2FOVAwr/view?usp=sharing

🔬 Proyecto de Análisis de Defunciones Infantiles (2022-2025)
🎯 1. Introducción y Objetivo del Proyecto
Este proyecto se enfoca en el análisis exhaustivo del comportamiento de las defunciones en niños de 0 a 14 años en Chile, utilizando datos oficiales para generar inteligencia demográfica y epidemiológica.

Los datos base provienen de la Dirección de Estadísticas de Información de Salud (DEIS), regida por el Ministerio de Salud, y cubren el período desde Enero de 2022 hasta Octubre de 2025.

El objetivo principal es transformar grandes volúmenes de datos en bruto en Indicadores Clave de Rendimiento (KPIs) que permitan hacer preguntas específicas y obtener insights accionables, como la correlación entre las causas de defunción y las variables demográficas.

🛠️ 2. Arquitectura de la Solución (Flujo de Datos)
La solución implementa un flujo de trabajo estructurado para garantizar la limpieza, centralización y el rendimiento del análisis.

Datos Fuente (DEIS): Archivo Excel de 150 MB (gestionado externamente, ver Sección 6).

Transformación y Cálculo (Python): El script en Python realiza la lectura del archivo fuente, aplica limpieza inicial y prepara la estructura de datos. Además, ejecuta el cálculo de tasas de mortandad utilizando los datos de defunciones obtenidos vía SQL junto a datos de población del Censo 2024.

Centralización y Procesamiento (Oracle SQL): La base de datos Oracle centraliza la información para permitir consultas complejas a gran escala. Aquí reside la lógica PL/SQL (PROCEDURES y TRIGGERS).

Visualización (Power BI): La herramienta se conecta a Oracle para consumir los datos limpios y los KPIs calculados, presentando el análisis final en un dashboard interactivo.

💻 3. Desarrollo y Programación en Base de Datos (PL/SQL)
La programación en PL/SQL fue esencial para garantizar el rendimiento en el procesamiento de la información y la calidad de los datos de entrada.

3.1. Procedimientos Almacenados (Facilitadores de Consulta)
Los procedimientos (SP_...) encapsulan la lógica de consulta compleja, facilitando la extracción de tendencias demográficas, estacionales y geográficas. Se diseñaron para facilitar la consulta y mejorar el rendimiento en comparación con la ejecución de consultas dinámicas extensas.

Ejemplo de Rol: Un procedimiento clave calcula la variación mensual de defunciones, mientras que otro permite la consulta filtrada de cualquier causa principal, sin la necesidad de reescribir la lógica SQL subyacente.

3.2. Triggers (Control de Calidad de Datos)
Los triggers fueron creados para actuar como guardianes de los datos en la tabla PACIENTE. Su propósito es eliminar el ingreso de datos erróneos al momento de una nueva inserción.

Ejemplo de Rol:

Integridad y Validación: Un trigger verifica que la EDAD no sea negativa, y que campos como SEXO_NOMBRE y LUGAR_DEFUNCION solo contengan valores válidos y estandarizados (ej., normalizando la capitalización de "hombre" a "Hombre").

Referencialidad: Se asegura que códigos clave (COD_COMUNA, CAPITULO_DIAG1) existan en sus tablas de referencia antes de ser guardados.

📈 4. Resultados Clave y Visualización (Power BI)
El dashboard en Power BI, alojado en la pestaña "Analisis defunciones 0-14 años", consolida la información demográfica y clínica.

Pregunta Hipótesis Central:

¿Existe una correlación entre las defunciones por accidentes (Códigos CIE10: S99 - T98) y el sexo de los niños de entre 0 y 14 años?

Conclusión Confirmada por Datos:
Mediante la visualización y los cálculos de tasas de mortandad ejecutados en Python, se determinó que existe una probabilidad del 87% más alta de morir por accidente en niños varones en comparación con las niñas hembras de la misma edad.

Ejemplo de Visualización de Tendencia:
El siguiente gráfico, fundamental en el análisis de tendencias, muestra la estacionalidad de las defunciones:

🚀 5. Ejecución e Instalación
Descargar Datos: Descargar el archivo Excel de 150 MB desde el [Enlace de Descarga del Excel] (Necesario porque el archivo es demasiado grande para GitHub).

Configurar DB: Ejecutar los scripts SQL para crear las tablas y los objetos PL/SQL (.sql).

Carga Inicial: Ejecutar el script Python para la lectura, limpieza y carga de los datos a la base de datos Oracle.

Análisis: Abrir el archivo de Power BI (.pbix) y refrescar la conexión a la base de datos Oracle para cargar los datos procesados y visualizarlos.
