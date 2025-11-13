/*================== TRIGGER PARA VALIDACION EDAD Y SEXO ==================*/

CREATE OR REPLACE TRIGGER TRG_PACIENTE_VALIDAR_CONSISTENCIA
BEFORE INSERT OR UPDATE ON PACIENTE
FOR EACH ROW
DECLARE
    V_SEXO_UPPER VARCHAR2(20);
BEGIN
    IF :NEW.EDAD IS NOT NULL AND :NEW.EDAD < 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 
            'ERROR de Datos: La edad (' || :NEW.EDAD || ') no puede ser negativa. Operación cancelada.');
    END IF;
    
    IF :NEW.EDAD > 120 THEN
            RAISE_APPLICATION_ERROR(-20021, 
                'ADVERTENCIA: Edad (' || :NEW.EDAD || ') excede el límite superior de 120 años. Operación cancelada.');
        END IF;
    
    IF :NEW.SEXO_NOMBRE IS NOT NULL THEN
        V_SEXO_UPPER := UPPER(:NEW.SEXO_NOMBRE);
        
        IF V_SEXO_UPPER NOT IN ('HOMBRE', 'MUJER', 'INDETERMINADO') THEN
             RAISE_APPLICATION_ERROR(-20022, 
                'ERROR de Consistencia: El valor ingresado para SEXO (' || :NEW.SEXO_NOMBRE || ') no es válido (solo se permiten Hombre, Mujer o Indeterminado). Operación cancelada.');
        END IF;
        
        :NEW.SEXO_NOMBRE := INITCAP(:NEW.SEXO_NOMBRE);
    END IF;

END;

/*================== TRIGGER PARA VALIDACION DE CAPITULO DIAGNOSTICO 1 INGRESADO ==================*/

CREATE OR REPLACE TRIGGER TRG_PACIENTE_DIAG_INTEGRIDAD
BEFORE INSERT OR UPDATE OF CAPITULO_DIAG1 ON PACIENTE
FOR EACH ROW
DECLARE
    V_CAPITULO_EXISTE NUMBER;
BEGIN
    IF :NEW.CAPITULO_DIAG1 IS NOT NULL THEN
        SELECT COUNT(*)
        INTO V_CAPITULO_EXISTE
        FROM DIAG1_CAPITULO
        WHERE CAPITULO_DIAG1 = :NEW.CAPITULO_DIAG1;
        
        IF V_CAPITULO_EXISTE = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 
                'ERROR de Referencia: El código de diagnóstico (' || :NEW.CAPITULO_DIAG1 || ') no existe en la tabla DIAG1_CAPITULO. Operación cancelada.');
        END IF;
    END IF;
END;

/*================== TRIGGER PARA KPI VALIDACION DE LUGAR DE DEFUNCION ==================*/

CREATE OR REPLACE TRIGGER TRG_PACIENTE_VALIDAR_LUGAR
BEFORE INSERT OR UPDATE OF LUGAR_DEFUNCION ON PACIENTE
FOR EACH ROW
DECLARE
    V_LUGAR_UPPER VARCHAR2(100);
BEGIN
    IF :NEW.LUGAR_DEFUNCION IS NOT NULL THEN
        V_LUGAR_UPPER := UPPER(TRIM(:NEW.LUGAR_DEFUNCION));

        IF V_LUGAR_UPPER NOT IN ('HOSPITAL O CLÍNICA', 'CASA O HABITACIÓN', 'OTRO') THEN
             RAISE_APPLICATION_ERROR(-20040, 
                'ERROR de Validación: El valor para LUGAR_DEFUNCION (' || :NEW.LUGAR_DEFUNCION || ') no es válido. Solo se permiten "Hospital o Clínica", "Casa o Habitación" u "Otro".');
        END IF;

    ELSE
        -- Si la columna es NOT NULL (como indica su definición), este chequeo asegura que tenga valor
        RAISE_APPLICATION_ERROR(-20041, 
            'ERROR de Validación: LUGAR_DEFUNCION no puede ser nulo.');
    END IF;
END;

/*================== TRIGGER PARA KPI VALIDACION DE TIPO DE EDAD ==================*/

CREATE OR REPLACE TRIGGER TRG_PACIENTE_VALIDAR_EDAD_TIPO
BEFORE INSERT OR UPDATE OF EDAD_TIPO ON PACIENTE
FOR EACH ROW
BEGIN

    IF :NEW.EDAD_TIPO IS NOT NULL THEN
        IF :NEW.EDAD_TIPO NOT IN (0, 1, 2, 3, 4, 9) THEN
             RAISE_APPLICATION_ERROR(-20103, 
                'ERROR de Validación: El valor para EDAD_TIPO (' || :NEW.EDAD_TIPO || ') no es válido. Solo se permiten los números 0, 1, 2, 3, 4 o 9.');
        END IF;
        
    ELSE 
        RAISE_APPLICATION_ERROR(-20104, 
            'ERROR de Validación: EDAD_TIPO no puede ser nulo.');
    END IF;

END;
/
