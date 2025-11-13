DROP TABLE REGION CASCADE CONSTRAINT;
DROP TABLE COMUNA CASCADE CONSTRAINT;
DROP TABLE TIPO_EDAD CASCADE CONSTRAINT;
DROP TABLE DIAG1_CAPITULO CASCADE CONSTRAINT;
DROP TABLE DIAG1_GRUPO CASCADE CONSTRAINT;
DROP TABLE DIAG1_CATEGORIA CASCADE CONSTRAINT;
DROP TABLE DIAG1_SUBCATEGORIA CASCADE CONSTRAINT;
DROP TABLE DIAG2_CAPITULO CASCADE CONSTRAINT;
DROP TABLE DIAG2_GRUPO CASCADE CONSTRAINT;
DROP TABLE DIAG2_CATEGORIA CASCADE CONSTRAINT;
DROP TABLE DIAG2_SUBCATEGORIA CASCADE CONSTRAINT;
DROP TABLE PACIENTE CASCADE CONSTRAINT;

-- Tabla de regiones
CREATE TABLE REGION (
    cod_region NUMBER(10),
    region VARCHAR(500) NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY (cod_region)
);

-- Tabla de comunas 
CREATE TABLE COMUNA (
    cod_comuna NUMBER(7),
    comuna VARCHAR2(50) NOT NULL,
    cod_region NUMBER(10), -- Clave for�nea para REGION
    CONSTRAINT PK_COMUNA PRIMARY KEY (cod_comuna)
);

-- Tabla para tipo de edad
CREATE TABLE TIPO_EDAD (
    edad_tipo NUMBER(3),
    descripcion_tipo_edad VARCHAR(20) NOT NULL,
    CONSTRAINT PK_TIPO_EDAD PRIMARY KEY (edad_tipo)
);

-- Tablas para diagnóstico 1
CREATE TABLE DIAG1_CAPITULO (
    capitulo_diag1 VARCHAR2(10),
    glosa_capitulo_diag1 VARCHAR2(500) NOT NULL,
    CONSTRAINT PK_DIAG1_CAPITULO PRIMARY KEY (capitulo_diag1)
);

CREATE TABLE DIAG1_GRUPO (
    codigo_grupo_diag1 VARCHAR2(10),
    glosa_grupo_diag1 VARCHAR2(500) NOT NULL,
    capitulo_diag1 VARCHAR2(10), -- Clave for�nea para DIAG1_CAPITULO
    CONSTRAINT PK_DIAG1_GRUPO PRIMARY KEY (codigo_grupo_diag1)
);

CREATE TABLE DIAG1_CATEGORIA (
    codigo_categoria_diag1 VARCHAR2(6),
    glosa_categoria_diag1 VARCHAR2(500) NOT NULL,
    codigo_grupo_diag1 VARCHAR2(10), -- Clave for�nea para DIAG1_GRUPO
    CONSTRAINT PK_DIAG1_CATEGORIA PRIMARY KEY (codigo_categoria_diag1)
);

CREATE TABLE DIAG1_SUBCATEGORIA (
    codigo_subcategoria_diag1 VARCHAR2(6),
    glosa_subcategoria_diag1 VARCHAR2(500) NOT NULL,
    codigo_categoria_diag1 VARCHAR2(6), -- Clave for�nea para DIAG1_CATEGORIA
    CONSTRAINT PK_DIAG1_SUBCATEROGIA PRIMARY KEY (codigo_subcategoria_diag1)
);

-- Tablas para diagnóstico 2
CREATE TABLE DIAG2_CAPITULO (
    capitulo_diag2 VARCHAR2(10),
    glosa_capitulo_diag2 VARCHAR2(500),
    CONSTRAINT PK_DIAG2_CAPITULO PRIMARY KEY (capitulo_diag2)
);

CREATE TABLE DIAG2_GRUPO (
    codigo_grupo_diag2 VARCHAR2(10),
    glosa_grupo_diag2 VARCHAR2(500),
    capitulo_diag2 VARCHAR2(10), -- Clave for�nea para DIAG2_CAPITULO
    CONSTRAINT PK_DIAG2_GRUPO PRIMARY KEY (codigo_grupo_diag2)
);

CREATE TABLE DIAG2_CATEGORIA (
    codigo_categoria_diag2 VARCHAR2(6),
    glosa_categoria_diag2 VARCHAR2(500),
    codigo_grupo_diag2 VARCHAR2(10), -- Clave for�nea para DIAG2_GRUPO
    CONSTRAINT PK_DIAG2_CATEGORIA PRIMARY KEY (codigo_categoria_diag2)
);

CREATE TABLE DIAG2_SUBCATEGORIA (
    codigo_subcategoria_diag2 VARCHAR2(6),
    glosa_subcategoria_diag2 VARCHAR2(500),
    codigo_categoria_diag2 VARCHAR2(6), -- Clave for�nea para DIAG2_CATEGORIA
    CONSTRAINT PK_DIAG2_SUBCATEROGIA PRIMARY KEY (codigo_subcategoria_diag2)
);

-- Tabla de pacientes
CREATE TABLE PACIENTE (
    id_paciente NUMBER(10) GENERATED ALWAYS AS IDENTITY MINVALUE 1 START WITH 1,
    sexo_nombre VARCHAR2(30) NOT NULL,
    edad NUMBER(3) NOT NULL,
    lugar_defuncion VARCHAR2(500) NOT NULL,
    fecha_defuncion DATE NOT NULL,
    cod_comuna NUMBER(7),                      -- FK a COMUNA
    edad_tipo NUMBER(3),                       -- FK a TIPO_EDAD
    capitulo_diag1 VARCHAR2(10),     -- FK a DIAG1_CAPITULO
    capitulo_diag2 VARCHAR2(10),     -- FK a DIAG2_CAPITULO
    CONSTRAINT PK_PACIENTE PRIMARY KEY (id_paciente)
);

-- Relaciones de la tabla COMUNA
ALTER TABLE COMUNA
    ADD CONSTRAINT fk_comuna_region FOREIGN KEY (cod_region)
        REFERENCES REGION(cod_region);

-- Relaciones de la tabla PACIENTE
ALTER TABLE PACIENTE
    ADD CONSTRAINT fk_paciente_comuna FOREIGN KEY (cod_comuna)
        REFERENCES COMUNA(cod_comuna);

ALTER TABLE PACIENTE
    ADD CONSTRAINT fk_paciente_tipo_edad FOREIGN KEY (edad_tipo)
        REFERENCES TIPO_EDAD(edad_tipo);

ALTER TABLE PACIENTE
    ADD CONSTRAINT fk_paciente_diag1 FOREIGN KEY (capitulo_diag1)
        REFERENCES DIAG1_CAPITULO(capitulo_diag1);

ALTER TABLE PACIENTE
    ADD CONSTRAINT fk_paciente_diag2 FOREIGN KEY (capitulo_diag2)
        REFERENCES DIAG2_CAPITULO(capitulo_diag2);

-- Relaciones para el primer diagnóstico (DIAG1)
ALTER TABLE DIAG1_GRUPO
    ADD CONSTRAINT fk_diag1grupo_capitulo FOREIGN KEY (capitulo_diag1)
        REFERENCES DIAG1_CAPITULO(capitulo_diag1);

ALTER TABLE DIAG1_CATEGORIA
    ADD CONSTRAINT fk_diag1categoria_grupo FOREIGN KEY (codigo_grupo_diag1)
        REFERENCES DIAG1_GRUPO(codigo_grupo_diag1);

ALTER TABLE DIAG1_SUBCATEGORIA
    ADD CONSTRAINT fk_diag1subcategoria_categoria FOREIGN KEY (codigo_categoria_diag1)
        REFERENCES DIAG1_CATEGORIA(codigo_categoria_diag1);

-- Relaciones para el segundo diagnóstico (DIAG2)
ALTER TABLE DIAG2_GRUPO
    ADD CONSTRAINT fk_diag2grupo_capitulo FOREIGN KEY (capitulo_diag2)
        REFERENCES DIAG2_CAPITULO(capitulo_diag2);

ALTER TABLE DIAG2_CATEGORIA
    ADD CONSTRAINT fk_diag2categoria_grupo FOREIGN KEY (codigo_grupo_diag2)
        REFERENCES DIAG2_GRUPO(codigo_grupo_diag2);

ALTER TABLE DIAG2_SUBCATEGORIA
    ADD CONSTRAINT fk_diag2subcategoria_categoria FOREIGN KEY (codigo_categoria_diag2)
        REFERENCES DIAG2_CATEGORIA(codigo_categoria_diag2);
        
/* INSERCION DE VALORES EN LAS TABLAS CREADAS */

INSERT INTO REGION (cod_region, region)
SELECT DISTINCT cod_region, nombre_region
FROM DEFUNCIONES
WHERE nombre_region IS NOT NULL;


INSERT INTO COMUNA (cod_comuna, comuna, cod_region)
SELECT DISTINCT cod_comuna, comuna, cod_region
FROM DEFUNCIONES
WHERE comuna IS NOT NULL
ORDER BY cod_region;

INSERT INTO TIPO_EDAD (edad_tipo, descripcion_tipo_edad)
SELECT DISTINCT edad_tipo,
        CASE
            WHEN edad_tipo = 1 THEN 'EDAD EN A�OS'
            WHEN edad_tipo = 2 THEN 'EDAD EN MESES'
            WHEN edad_tipo = 3 THEN 'EDAD EN DIAS'
            WHEN edad_tipo = 4 THEN 'EDAD EN HORAS'
            WHEN edad_tipo = 9 THEN 'EDAD NO INFORMADA'
            WHEN edad_tipo = 0 THEN 'IGNORADO'
        END AS descripcion_tipo_edad
FROM DEFUNCIONES
WHERE edad_tipo IS NOT NULL;

--Inserción de datos en tablas de diagnóstico 1--

INSERT INTO DIAG1_CAPITULO (capitulo_diag1, glosa_capitulo_diag1)
SELECT DISTINCT capitulo_diag1, glosa_capitulo_diag1
FROM DEFUNCIONES
WHERE capitulo_diag1 IS NOT NULL;

INSERT INTO DIAG1_GRUPO (codigo_grupo_diag1, glosa_grupo_diag1, capitulo_diag1)
SELECT DISTINCT codigo_grupo_diag1, glosa_grupo_diag1, capitulo_diag1
FROM DEFUNCIONES
WHERE codigo_grupo_diag1 IS NOT NULL;

INSERT INTO DIAG1_CATEGORIA (codigo_categoria_diag1, glosa_categoria_diag1, codigo_grupo_diag1)
SELECT codigo_categoria_diag1, glosa_categoria_diag1, codigo_grupo_diag1
FROM (
    SELECT codigo_categoria_diag1,
           glosa_categoria_diag1,
           codigo_grupo_diag1,
           ROW_NUMBER() OVER (PARTITION BY codigo_categoria_diag1 ORDER BY glosa_categoria_diag1) AS rn
    FROM DEFUNCIONES
    WHERE codigo_categoria_diag1 IS NOT NULL
)
WHERE rn = 1;

INSERT INTO DIAG1_SUBCATEGORIA (codigo_subcategoria_diag1, glosa_subcategoria_diag1, codigo_categoria_diag1)
SELECT DISTINCT codigo_subcategoria_diag1, glosa_subcategoria_diag1, codigo_categoria_diag1
FROM DEFUNCIONES
WHERE codigo_subcategoria_diag1 IS NOT NULL;

SELECT * FROM DIAG1_SUBCATEGORIA ORDER BY CODIGO_SUBCATEGORIA_DIAG1;

--Inserción de datos en tablas de diagnóstico 2 --

INSERT INTO DIAG2_CAPITULO (capitulo_diag2, glosa_capitulo_diag2)
SELECT DISTINCT capitulo_diag2, glosa_capitulo_diag2
FROM DEFUNCIONES
WHERE capitulo_diag2 IS NOT NULL;

INSERT INTO DIAG2_GRUPO (codigo_grupo_diag2, glosa_grupo_diag2, capitulo_diag2)
SELECT DISTINCT codigo_grupo_diag2, glosa_grupo_diag2, capitulo_diag2
FROM DEFUNCIONES
WHERE codigo_grupo_diag2 IS NOT NULL;

INSERT INTO DIAG2_CATEGORIA (codigo_categoria_diag2, glosa_categoria_diag2, codigo_grupo_diag2)
SELECT codigo_categoria_diag2, glosa_categoria_diag2, codigo_grupo_diag2
FROM (
    SELECT codigo_categoria_diag2,
           glosa_categoria_diag2,
           codigo_grupo_diag2,
           ROW_NUMBER() OVER (PARTITION BY codigo_categoria_diag2 ORDER BY glosa_categoria_diag2) AS rn
    FROM DEFUNCIONES
    WHERE codigo_categoria_diag2 IS NOT NULL
)
WHERE rn = 1;

INSERT INTO DIAG2_SUBCATEGORIA (codigo_subcategoria_diag2, glosa_subcategoria_diag2, codigo_categoria_diag2)
SELECT DISTINCT codigo_subcategoria_diag2, glosa_subcategoria_diag2, codigo_categoria_diag2
FROM DEFUNCIONES
WHERE codigo_subcategoria_diag2 IS NOT NULL;

-- Inserción de datos en tabla paciente--

INSERT INTO PACIENTE (sexo_nombre, edad, lugar_defuncion, fecha_defuncion, cod_comuna, edad_tipo, capitulo_diag1, capitulo_diag2)
SELECT
    sexo_nombre,
    edad_cant,
    lugar_defuncion,
    TO_DATE(fecha_def, 'DD/MM/YYYY'),
    cod_comuna,
    edad_tipo,
    capitulo_diag1,
    capitulo_diag2
FROM DEFUNCIONES
WHERE id_paciente IS NOT NULL;

SELECT * FROM PACIENTE;