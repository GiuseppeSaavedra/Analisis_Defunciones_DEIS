/*Creación de tabla general con columnas definidas*/

CREATE TABLE DEFUNCIONES (
    id_paciente NUMBER(10) GENERATED ALWAYS AS IDENTITY MINVALUE 1 START WITH 1,
    a�o VARCHAR2 (10),
    fecha_def DATE,
    sexo_nombre VARCHAR2 (30),
    edad_tipo NUMBER(3),
    edad_cant NUMBER(3),
    cod_comuna NUMBER(7),
    comuna VARCHAR2 (50),
    nombre_region VARCHAR2 (500),
    diag1 VARCHAR2 (6),
    capitulo_diag1 VARCHAR2(10),
    glosa_capitulo_diag1 VARCHAR2(500),
    codigo_grupo_diag1 VARCHAR2(10),
    glosa_grupo_diag1 VARCHAR2(500),
    codigo_categoria_diag1 VARCHAR2 (6),
    glosa_categoria_diag1 VARCHAR2(500),
    codigo_subcategoria_diag1 VARCHAR2(6),
    glosa_subcategoria_diag1 VARCHAR2 (500),
    diag2 VARCHAR2 (6),
    capitulo_diag2 VARCHAR2 (10),
    glosa_capitulo_diag2 VARCHAR2(500),
    codigo_grupo_diag2 VARCHAR2 (10),
    glosa_grupo_diag2 VARCHAR2(500),
    codigo_categoria_diag2 VARCHAR2(6),
    glosa_categoria_diag2 VARCHAR2(500),
    codigo_subcategoria_diag2 VARCHAR2(6),
    glosa_subcategoria_diag2 VARCHAR2(500),
    lugar_defuncion VARCHAR2 (500),
    cod_region NUMBER(7)
    );


