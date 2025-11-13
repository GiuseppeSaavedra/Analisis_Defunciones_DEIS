/*CREATE OR REPLACE PROCEDURE SP_DEFUNCIONES_SEXO_ANIO_MES
AS
    -- Cursor para obtener el conteo de defunciones agrupado por Sexo, Año y Mes
    CURSOR C_DEFUNCIONES_POR_SEXO IS
        SELECT 
            SEXO_NOMBRE, 
            COUNT(*) AS TOTAL_DEFUNCIONES,
            EXTRACT(YEAR FROM TO_DATE(FECHA_DEFUNCION, 'DD/MM/YY')) AS AÑO,
            EXTRACT(MONTH FROM TO_DATE(FECHA_DEFUNCION, 'DD/MM/YY')) AS MES
        FROM PACIENTE
        WHERE SEXO_NOMBRE IN ('Hombre','Mujer')
        GROUP BY 
            SEXO_NOMBRE,
            EXTRACT(YEAR FROM TO_DATE(FECHA_DEFUNCION, 'DD/MM/YY')),
            EXTRACT(MONTH FROM TO_DATE(FECHA_DEFUNCION, 'DD/MM/YY'))
        ORDER BY AÑO, MES, SEXO_NOMBRE;
        
    V_DEFUNCIONES C_DEFUNCIONES_POR_SEXO%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===================KPI 1: CALCULO DE DEFUNCIONES POR SEXO, AÑO Y MES=========================================');
    
    OPEN C_DEFUNCIONES_POR_SEXO;
    
    LOOP
        FETCH C_DEFUNCIONES_POR_SEXO INTO V_DEFUNCIONES;
        EXIT WHEN C_DEFUNCIONES_POR_SEXO%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            '[' || V_DEFUNCIONES.AÑO || '-' || LPAD(V_DEFUNCIONES.MES, 2, '0') || 
            '] | Sexo: ' || RPAD(V_DEFUNCIONES.SEXO_NOMBRE, 10, ' ') || 
            ' | Total Defunciones: ' || TO_CHAR(V_DEFUNCIONES.TOTAL_DEFUNCIONES, '999G999G999'));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------');
    END LOOP;
    
    CLOSE C_DEFUNCIONES_POR_SEXO;
END;


/*EXEC SP_DEFUNCIONES_SEXO_ANIO_MES;*/

/*===============KPI 2===================*/

/*CREATE OR REPLACE PROCEDURE SP_KPI_EDAD_PROMEDIO_REGION AS

    CURSOR C_EDAD_PROMEDIO_REGION IS
        SELECT 
            R.REGION,
            TRUNC(AVG(P.EDAD)) AS EDAD_PROMEDIO,
            COUNT(*) AS TOTAL_PACIENTES
        FROM PACIENTE P
        JOIN 
            COMUNA C ON P.COD_COMUNA = C.COD_COMUNA
        JOIN 
            REGION R ON C.COD_REGION = R.COD_REGION
        WHERE 
            P.EDAD_TIPO = 1 AND P.EDAD IS NOT NULL
        GROUP BY R.REGION
        ORDER BY EDAD_PROMEDIO DESC;
        
    V_EDAD_PROMEDIO C_EDAD_PROMEDIO_REGION%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(=================== KPI 2: EDAD PROMEDIO POR REGION ===================');
    DBMS_OUTPUT.PUT_LINE('Región' || RPAD(' ', 20) || ' | Edad Promedio | Total Pacientes');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    
    OPEN C_EDAD_PROMEDIO_REGION;
    LOOP
        FETCH C_EDAD_PROMEDIO_REGION INTO V_EDAD_PROMEDIO;
        EXIT WHEN C_EDAD_PROMEDIO_REGION%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(V_EDAD_PROMEDIO.REGION, 25) || ' | ' ||
            RPAD(V_EDAD_PROMEDIO.EDAD_PROMEDIO, 13) || ' | ' ||
            V_EDAD_PROMEDIO.TOTAL_PACIENTES);
    END LOOP;
    CLOSE C_EDAD_PROMEDIO_REGION;
END;*/

/*EXEC SP_KPI_EDAD_PROMEDIO_REGION;*/

/*===============KPI 3===================*/


/*CREATE OR REPLACE PROCEDURE SP_DESVIACION_EDAD_POR_CAUSA
AS
    CURSOR C_DESVIACION_EDAD IS
        SELECT
            DC1.GLOSA_CAPITULO_DIAG1 AS GLOSA_CAPITULO,
            TRUNC(STDDEV(P.EDAD)) AS DESVIACION_ESTANDAR
        FROM
            PACIENTE P
        JOIN
            DIAG1_CAPITULO DC1 ON P.CAPITULO_DIAG1 = DC1.CAPITULO_DIAG1
        JOIN 
            TIPO_EDAD TE ON TE.EDAD_TIPO = P.EDAD_TIPO 
        WHERE
            P.EDAD IS NOT NULL AND P.EDAD_TIPO = 1 
        GROUP BY
            DC1.GLOSA_CAPITULO_DIAG1
        ORDER BY
            DC1.GLOSA_CAPITULO_DIAG1;
            
    V_DESVIACION_EDAD C_DESVIACION_EDAD%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('==================== KPI 3: DESVIACION ESTANDAR DE LA EDAD POR CAUSA PRINCIPAL DE DEFUNCION ============================================');
    
    OPEN C_DESVIACION_EDAD;
    
    LOOP
        FETCH C_DESVIACION_EDAD INTO V_DESVIACION_EDAD;
        EXIT WHEN C_DESVIACION_EDAD%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Causa Principal: ' || RPAD(V_DESVIACION_EDAD.GLOSA_CAPITULO,60) || ' -> Desviación Estándar: ' || V_DESVIACION_EDAD.DESVIACION_ESTANDAR || ' Años');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
    END LOOP;
    CLOSE C_DESVIACION_EDAD;
END;*/

/*EXEC SP_DESVIACION_EDAD_POR_CAUSA;*/

/*===============KPI 4===================*/


/*CREATE OR REPLACE PROCEDURE SP_MES_MAYOR_DEFUNCIONES_ANIO 
AS
    CURSOR C_MAX_DEFUNCIONES_MES IS
        WITH DEFUNCIONES_POR_MES AS (
            SELECT
                EXTRACT(YEAR FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')) AS ANO_DEFUNCION,
                EXTRACT(MONTH FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')) AS MES_DEFUNCION,
                COUNT(*) AS TOTAL_DEFUNCIONES
            FROM
                DEFUNCIONES
            WHERE
                EXTRACT(YEAR FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')) IN (2023, 2024)
            GROUP BY
                EXTRACT(YEAR FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')),
                EXTRACT(MONTH FROM TO_DATE(FECHA_DEF, 'DD/MM/YY'))
        ),
        RANKING_POR_ANIO AS (
            SELECT
                ANO_DEFUNCION,
                MES_DEFUNCION,
                TOTAL_DEFUNCIONES,
                RANK() OVER (PARTITION BY ANO_DEFUNCION ORDER BY TOTAL_DEFUNCIONES DESC) AS RANKING
            FROM
                DEFUNCIONES_POR_MES
        )
        SELECT
            ANO_DEFUNCION,
            MES_DEFUNCION,
            TOTAL_DEFUNCIONES
        FROM
            RANKING_POR_ANIO
        WHERE
            RANKING = 1 
        ORDER BY
            ANO_DEFUNCION;
            
    V_DEFUNCION C_MAX_DEFUNCIONES_MES%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('==================== KPI 4: MES CON MÁS DEFUNCIONES POR AÑO (2023 - 2024) ============================================');
    
    OPEN C_MAX_DEFUNCIONES_MES;

    LOOP
        FETCH C_MAX_DEFUNCIONES_MES INTO V_DEFUNCION;
        EXIT WHEN C_MAX_DEFUNCIONES_MES%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Año: ' || V_DEFUNCION.ANO_DEFUNCION || ' | Mes: ' || V_DEFUNCION.MES_DEFUNCION || ' | Total de defunciones: ' || V_DEFUNCION.TOTAL_DEFUNCIONES);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
    CLOSE C_MAX_DEFUNCIONES_MES; 
END;*/

/*EXEC SP_MES_MAYOR_DEFUNCIONES_ANIO;*/ 

/*===============KPI 5===================*/

/*CREATE OR REPLACE PROCEDURE SP_TOP3_CAUSAS_REGION
AS
    -- Cursor que utiliza CTEs para calcular el ranking de causas por región
    CURSOR C_TOP3_CAUSAS_REGION IS
        WITH CAUSASPORREGION AS ( 
            SELECT
                R.REGION,
                D.GLOSA_CAPITULO_DIAG1 AS CAUSA_PRINCIPAL,
                COUNT(*) AS TOTAL_DEFUNCIONES
            FROM
                PACIENTE P
            JOIN
                COMUNA C ON P.COD_COMUNA = C.COD_COMUNA
            JOIN
                REGION R ON C.COD_REGION = R.COD_REGION
            JOIN
                DIAG1_CAPITULO D ON P.CAPITULO_DIAG1 = D.CAPITULO_DIAG1
            GROUP BY
                R.REGION,
                D.GLOSA_CAPITULO_DIAG1
        ),
        RANKINGCAUSAS AS (
            SELECT
                REGION,
                CAUSA_PRINCIPAL,
                TOTAL_DEFUNCIONES,
                RANK() OVER (PARTITION BY REGION ORDER BY TOTAL_DEFUNCIONES DESC) AS RANKING
            FROM
                CAUSASPORREGION
        )
        SELECT
            REGION,
            CAUSA_PRINCIPAL,
            TOTAL_DEFUNCIONES
        FROM
            RANKINGCAUSAS
        WHERE
            RANKING <= 3
        ORDER BY
            REGION,
            TOTAL_DEFUNCIONES DESC;
            
    R_TOP3_CAUSAS C_TOP3_CAUSAS_REGION%ROWTYPE;
    V_REGION_ACTUAL VARCHAR2(255) := NULL;

BEGIN
    DBMS_OUTPUT.PUT_LINE('====================KPI 5: TOP 3 DE CAUSAS DE DEFUNCION POR REGION ============================================');
    
    OPEN C_TOP3_CAUSAS_REGION;
    
    LOOP
        FETCH C_TOP3_CAUSAS_REGION INTO R_TOP3_CAUSAS;
        EXIT WHEN C_TOP3_CAUSAS_REGION%NOTFOUND;
        
        -- Separador visual para cada nueva región
        IF V_REGION_ACTUAL IS NULL OR V_REGION_ACTUAL != R_TOP3_CAUSAS.REGION THEN
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------');
            V_REGION_ACTUAL := R_TOP3_CAUSAS.REGION;
        END IF;

        -- Mostrar el resultado
        DBMS_OUTPUT.PUT_LINE('Región: ' || R_TOP3_CAUSAS.REGION || ' | Causa: ' || RPAD(R_TOP3_CAUSAS.CAUSA_PRINCIPAL,50) || ' | Total: ' || R_TOP3_CAUSAS.TOTAL_DEFUNCIONES);
    END LOOP;
    
    CLOSE C_TOP3_CAUSAS_REGION;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------');
END;*/

/*EXEC SP_TOP3_CAUSAS_REGION;*/

/*===============KPI 6===================*/

/*CREATE OR REPLACE PROCEDURE SP_VARIACION_MENSUAL_DEFUNCIONES
AS
    CURSOR C_VARIACION_MENSUAL IS
        WITH DEFUNCIONES_POR_MES AS (
            SELECT
                EXTRACT(YEAR FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')) AS ANO_DEFUNCION,
                EXTRACT(MONTH FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')) AS MES_DEFUNCION,
                COUNT(*) AS TOTAL_DEFUNCIONES
            FROM
                DEFUNCIONES
            GROUP BY
                EXTRACT(YEAR FROM TO_DATE(FECHA_DEF, 'DD/MM/YY')),
                EXTRACT(MONTH FROM TO_DATE(FECHA_DEF, 'DD/MM/YY'))
            ORDER BY
                ANO_DEFUNCION,
                MES_DEFUNCION
        ),
        VARIACION AS (
            SELECT
                ANO_DEFUNCION,
                MES_DEFUNCION,
                TOTAL_DEFUNCIONES,
                LAG(TOTAL_DEFUNCIONES, 1, 0) OVER (ORDER BY ANO_DEFUNCION, MES_DEFUNCION) AS DEFUNCIONES_MES_ANTERIOR,
                CASE
                    WHEN LAG(TOTAL_DEFUNCIONES, 1, 0) OVER (ORDER BY ANO_DEFUNCION, MES_DEFUNCION) = 0 THEN 0
                    ELSE ROUND(((TOTAL_DEFUNCIONES - LAG(TOTAL_DEFUNCIONES, 1, 0) OVER (ORDER BY ANO_DEFUNCION, MES_DEFUNCION)) / LAG(TOTAL_DEFUNCIONES, 1, 0) OVER (ORDER BY ANO_DEFUNCION, MES_DEFUNCION)) * 100, 2)
                END AS PORCENTAJE_VARIACION
            FROM
                DEFUNCIONES_POR_MES
        )
        SELECT
            ANO_DEFUNCION,
            MES_DEFUNCION,
            TOTAL_DEFUNCIONES,
            PORCENTAJE_VARIACION
        FROM
            VARIACION
        ORDER BY
            ANO_DEFUNCION,
            MES_DEFUNCION;
            
    V_VARIACION C_VARIACION_MENSUAL%ROWTYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('===================KPI 6: Variación Porcentual Mensual de Defunciones ===================');
    
    OPEN C_VARIACION_MENSUAL;
    LOOP
        FETCH C_VARIACION_MENSUAL INTO V_VARIACION;
        EXIT WHEN C_VARIACION_MENSUAL%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Año: ' || V_VARIACION.ANO_DEFUNCION || ' | Mes: ' || V_VARIACION.MES_DEFUNCION || ' | Total: ' || V_VARIACION.TOTAL_DEFUNCIONES || ' | Variación: ' || TO_CHAR(V_VARIACION.PORCENTAJE_VARIACION, '990D99') || '%');
    END LOOP;
    
    CLOSE C_VARIACION_MENSUAL;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
END;*/

/*EXEC SP_VARIACION_MENSUAL_DEFUNCIONES;*/

/*===============KPI 7===================*/

/*CREATE OR REPLACE PROCEDURE SP_PROPORCION_LUGAR_CAUSA_REGION (
    P_FILTRO_CAUSA IN VARCHAR2 -- Parámetro de entrada para la palabra clave del filtro
)
AS
    CURSOR C_PROPORCION IS
        WITH DEFUNCIONES_POR_LUGAR AS (
            SELECT
                R.REGION,
                D1.GLOSA_CAPITULO_DIAG1,
                P.LUGAR_DEFUNCION,
                COUNT(*) AS TOTAL_DEFUNCIONES
            FROM
                PACIENTE P
            JOIN
                COMUNA C ON P.COD_COMUNA = C.COD_COMUNA
            JOIN
                REGION R ON C.COD_REGION = R.COD_REGION
            JOIN
                DIAG1_CAPITULO D1 ON P.CAPITULO_DIAG1 = D1.CAPITULO_DIAG1
            -- APLICACIÓN DE UPPER() A AMBOS LADOS PARA HACER LA BÚSQUEDA INSENSIBLE A MAYÚSCULAS/MINÚSCULAS
            WHERE UPPER(D1.GLOSA_CAPITULO_DIAG1) LIKE ('%' || UPPER(P_FILTRO_CAUSA) || '%') 
            GROUP BY
                R.REGION,
                D1.GLOSA_CAPITULO_DIAG1,
                P.LUGAR_DEFUNCION
        ),
        TOTAL_POR_CAPITULO_REGION AS (
            SELECT
                REGION,
                GLOSA_CAPITULO_DIAG1,
                LUGAR_DEFUNCION,
                TOTAL_DEFUNCIONES,
                SUM(TOTAL_DEFUNCIONES) OVER (PARTITION BY REGION, GLOSA_CAPITULO_DIAG1) AS TOTAL_DEFUNCIONES_CAUSA_REGION
            FROM
                DEFUNCIONES_POR_LUGAR
        )
        SELECT
            REGION,
            GLOSA_CAPITULO_DIAG1,
            LUGAR_DEFUNCION,
            ROUND((TOTAL_DEFUNCIONES / TOTAL_DEFUNCIONES_CAUSA_REGION) * 100, 2) AS PORCENTAJE
        FROM
            TOTAL_POR_CAPITULO_REGION
        ORDER BY
            REGION,
            GLOSA_CAPITULO_DIAG1,
            PORCENTAJE DESC;
            
    V_PROPORCION C_PROPORCION%ROWTYPE;
    V_CAUSA_REGION_ACTUAL VARCHAR2(500) := NULL;

BEGIN
    DBMS_OUTPUT.PUT_LINE('===================KPI: Proporción de Defunciones por Lugar, Causa y Región (Filtro: ' || P_FILTRO_CAUSA || ') ===================');
    
    OPEN C_PROPORCION;
    
    LOOP
        FETCH C_PROPORCION INTO V_PROPORCION;
        EXIT WHEN C_PROPORCION%NOTFOUND;
        
        IF V_CAUSA_REGION_ACTUAL IS NULL OR V_CAUSA_REGION_ACTUAL != V_PROPORCION.REGION || V_PROPORCION.GLOSA_CAPITULO_DIAG1 THEN
            DBMS_OUTPUT.PUT_LINE('========================================================================================================');
            V_CAUSA_REGION_ACTUAL := V_PROPORCION.REGION || V_PROPORCION.GLOSA_CAPITULO_DIAG1;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Región: ' || V_PROPORCION.REGION || ' | Causa: ' || V_PROPORCION.GLOSA_CAPITULO_DIAG1 || ' | Lugar: ' || V_PROPORCION.LUGAR_DEFUNCION || ' | Porcentaje: ' || V_PROPORCION.PORCENTAJE || '%');
    END LOOP;
    
    CLOSE C_PROPORCION;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
END;
*/

/*EXEC SP_PROPORCION_LUGAR_CAUSA_REGION('sistema');*/