-- Script para cargar Objetos como Vistas, Secuenciales, Procedimientos almacenados o Funciones

-- ==========================================================================================================================
-- Modulo 1
-- ==========================================================================================================================

-- Triggers para generar códigos secuenciales
-- 1. Crear secuencias para cada tipo de evento
CREATE SEQUENCE codigo_dosificado_seq START 1;
CREATE SEQUENCE codigo_mezclado_seq START 1;
CREATE SEQUENCE codigo_moldeado_seq START 1;
CREATE SEQUENCE codigo_secado_seq START 1;
CREATE SEQUENCE codigo_envasado_seq START 1;

-- 2. Crear funciones generadoras de código
CREATE OR REPLACE FUNCTION generar_codigo_dosificado() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_dosificado_seq');
    RETURN 'DS' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_mezclado() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_mezclado_seq');
    RETURN 'MZ' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_moldeado() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_moldeado_seq');
    RETURN 'MD' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_secado() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_secado_seq');
    RETURN 'SC' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_envasado() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_envasado_seq');
    RETURN 'EV' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

-- 3. Crear funciones de trigger para cada evento
CREATE OR REPLACE FUNCTION asignar_codigo_dosificado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_dosificado();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_mezclado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_mezclado();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_moldeado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_moldeado();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_secado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_secado();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_envasado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_envasado();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Crear triggers en las tablas correspondientes
CREATE TRIGGER trg_insert_dosificado
BEFORE INSERT ON Dosificados
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_dosificado();

CREATE TRIGGER trg_insert_mezclado
BEFORE INSERT ON Mezclados
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_mezclado();

CREATE TRIGGER trg_insert_moldeado
BEFORE INSERT ON Moldeados
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_moldeado();

CREATE TRIGGER trg_insert_secado
BEFORE INSERT ON Secados
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_secado();

CREATE TRIGGER trg_insert_envasado
BEFORE INSERT ON Envasados
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_envasado();

-- Sincronizar las secuencias con los datos existentes
-- Sincronización de códigos
SELECT setval('codigo_dosificado_seq', (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM Dosificados));
SELECT setval('codigo_mezclado_seq',   (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM Mezclados));
SELECT setval('codigo_moldeado_seq',   (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM Moldeados));
SELECT setval('codigo_secado_seq',     (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM Secados));
SELECT setval('codigo_envasado_seq',   (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM Envasados));

-- Sincronización de ids
SELECT setval('dosificados_id_dosificado_seq', (SELECT MAX(id_dosificado) FROM Dosificados));
SELECT setval('envasados_id_envasado_seq', (SELECT MAX(id_envasado) FROM Envasados));

-- Funciones para obtener encontrar eventos de un lote, los insumos dosificados en ese lote y los eventos habilitados para un lote
CREATE OR REPLACE FUNCTION encontrar_eventos_lote(codigo_lote TEXT)
RETURNS TABLE (
    "N° Batch" TEXT,
    "Etapa de Producción" TEXT,
    "Estado" TEXT,
    "Fecha y hora de inicio" TIMESTAMP,
    "Tiempo de proceso" NUMERIC,
    "Responsable" TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH LoteSeleccionado AS (
        SELECT id_lote_producto 
        FROM LotesProducto 
        WHERE codigo = codigo_lote
    ),
    EtapasRecurrentes AS (
        SELECT 
            pr.numero_batch::TEXT,
            CASE 
                WHEN mz.id_proceso_recurrente IS NOT NULL THEN 'MEZCLADO'
                WHEN md.id_proceso_recurrente IS NOT NULL THEN 'MOLDEADO'
                WHEN s.id_proceso_recurrente IS NOT NULL THEN 'SECADO'
            END AS etapa,
            pr.estado::TEXT,
            pr.fecha_proceso,
            pr.tiempo_proceso::NUMERIC,
            COALESCE(mz.id_empleado, md.id_empleado, s.id_empleado) AS id_empleado
        FROM ProcesosRecurrente pr
        LEFT JOIN Mezclados mz ON pr.id_proceso_recurrente = mz.id_proceso_recurrente
        LEFT JOIN Moldeados md ON pr.id_proceso_recurrente = md.id_proceso_recurrente
        LEFT JOIN Secados s ON pr.id_proceso_recurrente = s.id_proceso_recurrente
        JOIN LoteSeleccionado l ON pr.id_lote_producto = l.id_lote_producto
    )

    -- DOSIFICADO
    SELECT 
        d.numero_batch::TEXT,
        'DOSIFICADO',
        d.estado::TEXT,
        d.fecha_proceso,
        (d.tiempo_proceso / 60)::NUMERIC,
        p.nombre::TEXT
    FROM Dosificados d
    JOIN Empleados e ON d.id_empleado = e.id_empleado
    JOIN Personas p ON e.id_empleado = p.id_persona
    JOIN LoteSeleccionado l ON d.id_lote_producto = l.id_lote_producto

    UNION ALL

    -- MEZCLADO, MOLDEADO, SECADO
    SELECT 
        er.numero_batch,
        er.etapa,
        er.estado,
        er.fecha_proceso,
        er.tiempo_proceso,
        p.nombre::TEXT
    FROM EtapasRecurrentes er
    JOIN Empleados e ON er.id_empleado = e.id_empleado
    JOIN Personas p ON e.id_empleado = p.id_persona

    UNION ALL

    -- ENVASADO
    SELECT 
        en.numero_batch::TEXT,
        'ENVASADO',
        en.estado::TEXT,
        en.fecha_proceso,
        (en.tiempo_proceso / 60)::NUMERIC,
        p.nombre::TEXT
    FROM Envasados en
    JOIN Empleados e ON en.id_empleado = e.id_empleado
    JOIN Personas p ON e.id_empleado = p.id_persona
    JOIN LoteSeleccionado l ON en.id_lote_producto = l.id_lote_producto;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insumos_dosificados_lote(codigo_lote TEXT)
RETURNS TABLE (
    "Tipo de Insumo" TEXT,
    "Nombre de Insumo" TEXT,
    "Lote" TEXT,
    "Cantidad Dosificada" NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.tipo_insumo::TEXT AS "Tipo de Insumo",
        i.nombre_insumo::TEXT AS "Nombre de Insumo",
        li.codigo::TEXT AS "Lote",
        dxli.cantidad_dosificada AS "Cantidad Dosificada"
    FROM Dosificados d
    JOIN LotesProducto lp ON d.id_lote_producto = lp.id_lote_producto
    JOIN OrdenesProduccion op ON lp.id_orden_produccion = op.id_orden_produccion
    JOIN SolicitudesProduccion sp ON op.id_solicitud_produccion = sp.id_solicitud_produccion
    JOIN Formulaciones f ON sp.id_producto = f.id_producto
    JOIN DetallesFormulacion df ON f.id_formulacion = df.id_formulacion
    JOIN Insumos i ON df.id_insumo = i.id_insumo
    JOIN LotesInsumo li ON li.id_insumo = i.id_insumo
        AND li.fecha_vencimiento >= d.fecha_proceso::DATE
    JOIN DosificadosXLotesInsumo dxli ON dxli.id_dosificado = d.id_dosificado
        AND dxli.id_lote_insumo = li.id_lote_insumo
    WHERE lp.codigo = codigo_lote;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eventos_habilitados_lote(codigo_lote VARCHAR)
RETURNS TABLE(
  dosificado BOOLEAN,
  mezclado BOOLEAN,
  moldeado BOOLEAN,
  secado BOOLEAN,
  envasado BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
    etapa TEXT;
    estado TEXT;
BEGIN
    SELECT etapa_produccion, estado_lote_producto
      INTO etapa, estado
    FROM LotesProducto
    WHERE codigo = codigo_lote
    LIMIT 1;

    dosificado := (etapa = 'Dosificado' AND estado = 'En proceso');
    mezclado := (etapa = 'Dosificado' AND estado = 'Completado');
    moldeado := (etapa = 'Mezclado' AND estado = 'Completado');
    secado := (etapa = 'Moldeado' AND estado = 'Completado');
    envasado := (etapa = 'Secado' AND estado = 'Completado');

    RETURN NEXT;
END;
$$;

-- ==========================================================================================================================
-- Modulo 2
-- ==========================================================================================================================

CREATE OR REPLACE FUNCTION obtener_cantidad_asignada_ord_prod(
	id_orden_prod  ordenesproduccion.id_orden_produccion%TYPE
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
	cantidad_resultado INT;
BEGIN
	SELECT s.cantidad_requerida 
	INTO cantidad_resultado
	FROM solicitudesproduccion s
	JOIN ordenesproduccion o
		ON o.id_solicitud_produccion = s.id_solicitud_produccion 
	WHERE o.id_orden_produccion = id_orden_prod;

	RETURN cantidad_resultado;
END;
$$;

CREATE OR REPLACE FUNCTION obtener_cantidad_total_prod(
	id_orden_prod  ordenesproduccion.id_orden_produccion%TYPE
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
	cantidad_total INT;
BEGIN
	SELECT d.cantidad_asignada INTO cantidad_total
	FROM solicitudesproduccion s
	JOIN ordenesproduccion o ON o.id_solicitud_produccion = s.id_solicitud_produccion 
	JOIN productos p ON s.id_producto = p.id_producto 
	JOIN formulaciones f ON f.id_producto = p.id_producto 
	JOIN detallesformulacion d ON d.id_formulacion = f.id_formulacion 
	WHERE o.id_orden_produccion = id_orden_prod 
	  AND d.id_insumo IN (12, 13);

	RETURN cantidad_total;
END;
$$;

CREATE OR REPLACE FUNCTION obtener_fecha_venc_ant(
	id_insU  insumos.id_insumo%type
)
RETURNS Date
LANGUAGE plpgsql
AS $$
DECLARE
	fecha_vencimiento DATE;
BEGIN
	select min(l.fecha_vencimiento) INTO fecha_vencimiento 
	from lotesinsumo l 
        join insumos i
        on l.id_insumo = i.id_insumo
        where l.cantidad_disponible > 0
        group by i.id_insumo	
        having i.id_insumo = id_insu;

	RETURN fecha_vencimiento;
END;
$$;

CREATE OR REPLACE FUNCTION obtener_cantidad_insumo_necesitada(
	id_insU  insumos.id_insumo%type,
	id_orden_prod  ordenesproduccion.id_orden_produccion%TYPE
)
RETURNS NUMERIC 
LANGUAGE plpgsql
AS $$
DECLARE
	cantidad_necesitado NUMERIC;
BEGIN
	select  
    	trunc(d.cantidad_asignada * obtener_cantidad_asignada_ord_prod(id_orden_prod)/obtener_cantidad_total_prod(id_orden_prod), 2) as Cantidad
	INTO cantidad_necesitado
	from ordenesproduccion o 
	join solicitudesproduccion s
	on o.id_solicitud_produccion = s.id_solicitud_produccion 
	join  productos p
	on p.id_producto = s.id_producto 
	join formulaciones f 
	on f.id_producto = p.id_producto 
	join detallesformulacion d 
	on f.id_formulacion = d.id_formulacion 
	join insumos i 
	on i.id_insumo = d.id_insumo 
	where o.id_orden_produccion = id_orden_prod and i.id_insumo = id_insU ;

	RETURN cantidad_necesitado;
END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_estado_recepciones()
LANGUAGE plpgsql
AS $$
DECLARE
    recep RECORD;
BEGIN
    FOR recep IN
		select id_recepcion 
		from recepciones  
		where not(estado = 'Recepcionado')
    LOOP
        IF EXISTS (select 1 from recepciones r join lotesinsumo l on l.id_recepcion = r.id_recepcion 
				where 
				l.fecha_hora_ingreso_lab is not null and 
				r.id_recepcion = recep.id_recepcion and
				r.estado = 'En entrega') 
		THEN
			UPDATE Recepciones
	       	SET estado = 'Proceso de Calidad'
	     	WHERE id_recepcion = recep.id_recepcion;

		ELSIF NOT EXISTS (select 1 from recepciones r join lotesinsumo l on l.id_recepcion = r.id_recepcion 
					where 
					l.estado_lote_insumo is null and 
					r.id_recepcion = recep.id_recepcion and 
					r.estado = 'Proceso de Calidad')
		THEN 
			UPDATE Recepciones
	       	SET estado = 'A recepcionar'
	     	WHERE id_recepcion = recep.id_recepcion;
		END IF;
    END LOOP;
END;
$$;

----------------------------------------------

create or replace view vista_producto_cantidad_max_unitario as 
select p.id_producto ,p.codigo, p.nombre, d.cantidad_asignada as Cantidad_max_unitaro from productos p 
join formulaciones f 
on f.id_producto = p.id_producto 
join detallesformulacion d 
on d.id_formulacion = f.id_formulacion 
join insumos i 
on i.id_insumo = d.id_insumo 
where i.id_insumo in (11,12);

--Recepcion de Insumos
--Creacion de la secuencia
DROP SEQUENCE IF EXISTS codigo_recepcion_insumos_seq;
CREATE SEQUENCE codigo_recepcion_insumos_seq START 1;

--Funcion que genera codigos de recepciones
CREATE OR REPLACE FUNCTION generar_codigo_recepcion_insumos()
RETURNS CHAR(10) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('codigo_recepcion_insumos_seq');
RETURN 'RX' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

--Sincronizacion con los codigos actuales
SELECT setval('codigo_recepcion_insumos_seq', (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM recepciones ));

--Abastecimiento de Insumos
--Creacion de la secuencia
DROP SEQUENCE IF EXISTS codigo_abastecimiento_insumos_seq;
CREATE SEQUENCE codigo_abastecimiento_insumos_seq START 1;

--Funcion que genera codigos de abastecimientos 
CREATE OR REPLACE FUNCTION generar_codigo_abastecimiento_insumos()
RETURNS CHAR(10) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('codigo_abastecimiento_insumos_seq');
RETURN 'AB' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

--Sincronizacion con los codigos actuales
SELECT setval('codigo_abastecimiento_insumos_seq', (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM abastecimientos));

--Solicitud de Abastecimiento
--Creacion de la secuencia
DROP SEQUENCE IF EXISTS codigo_solicitud_insumos_seq;
CREATE SEQUENCE codigo_solicitud_insumos_seq START 1;

--Funcion que genera codigos de solicitudes
CREATE OR REPLACE FUNCTION generar_codigo_solicitud_insumos()
RETURNS CHAR(10) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('codigo_solicitud_insumos_seq');
RETURN 'SA' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

--Sincronizacion con los codigos actuales
SELECT setval('codigo_solicitud_insumos_seq', (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM solicitudesabastecimiento ));

--Abastecimientos de Insumos
CREATE OR REPLACE FUNCTION crear_abastecimiento_automatico()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO abastecimientos (codigo, id_orden_produccion)
    VALUES (
        generar_codigo_abastecimiento_insumos(),
        NEW.id_orden_produccion
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_crear_abastecimiento
AFTER INSERT ON ordenesproduccion
FOR EACH ROW
EXECUTE FUNCTION crear_abastecimiento_automatico();

--Recepcion de Insumos
CREATE OR REPLACE FUNCTION crear_recepciones_automatico()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO recepciones (codigo, id_compra)
    VALUES (
        generar_codigo_recepcion_insumos(),
        NEW.id_compra
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_crear_recepciones
AFTER INSERT ON compras
FOR EACH ROW
EXECUTE FUNCTION crear_recepciones_automatico();


--Desactivamos trigger 
ALTER TABLE ordenesproduccion DISABLE TRIGGER trg_crear_abastecimiento;
ALTER TABLE compras DISABLE TRIGGER trg_crear_recepciones;

-- ==========================================================================================================================
-- Modulo 3
-- ==========================================================================================================================

-- ----------------------------------------------------
-- Secuencia y función para el código de inspección
-- (Usada en R-302, R-303, R-304 y R-305)
-- ----------------------------------------------------
CREATE SEQUENCE IF NOT EXISTS seq_codigo_inspeccion START 1;

CREATE OR REPLACE FUNCTION generar_codigo_inspeccion()
RETURNS CHAR(8) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('seq_codigo_inspeccion');
    RETURN 'IG' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_inspeccion()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_inspeccion();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_generar_codigo_inspeccion
BEFORE INSERT ON InspeccionesGenerales
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_inspeccion();

-- ----------------------------------------------------
-- Trigger para crear inspección pendiente al registrar un lote
-- ----------------------------------------------------
CREATE OR REPLACE FUNCTION crear_inspeccion_pendiente_lote()
RETURNS TRIGGER AS $$
DECLARE
    v_id_inspeccion INT;
BEGIN
    -- Solo crear si aún no existe una inspección asociada
    IF EXISTS (
        SELECT 1 FROM InspeccionesLoteInsumo
        WHERE id_lote_insumo = NEW.id_lote_insumo
    ) THEN
        RETURN NEW;
    END IF;

    -- Crear inspección general
    INSERT INTO InspeccionesGenerales (
        codigo, tipo_inspeccion, estado_revision
    ) VALUES (
        generar_codigo_inspeccion(), 'Lote de Insumo', 'Pendiente'
    ) RETURNING id_inspeccion INTO v_id_inspeccion;

    -- Asociar lote a inspección
    INSERT INTO InspeccionesLoteInsumo (
        id_inspeccion, id_lote_insumo
    ) VALUES (
        v_id_inspeccion, NEW.id_lote_insumo
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_crear_inspeccion_en_registro_calidad
AFTER UPDATE OF fecha_hora_ingreso_lab ON LotesInsumo
FOR EACH ROW
WHEN (OLD.fecha_hora_ingreso_lab IS NULL AND NEW.fecha_hora_ingreso_lab IS NOT NULL)
EXECUTE FUNCTION crear_inspeccion_pendiente_lote();

-- ----------------------------------------------------
-- Procedimiento para actualizar una inspección pendiente
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE actualizar_inspeccion_pendiente(
    p_codigo_inspeccion CHAR(8),
    p_nombre_empleado   VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_empleado INT;
BEGIN
    SELECT e.id_empleado
    INTO v_id_empleado
    FROM Empleados e
    JOIN Personas p ON e.id_empleado = p.id_persona
    WHERE CONCAT(p.nombre, ' ', p.ap_paterno, ' ', p.ap_materno) = p_nombre_empleado;

    UPDATE InspeccionesGenerales
       SET id_empleado = v_id_empleado,
           estado_revision = 'Revisado'
     WHERE codigo = p_codigo_inspeccion
       AND estado_revision = 'Pendiente';
END;
$$;

-- ----------------------------------------------------
-- Procedimiento para registrar el ingreso del lote
-- (Funcionalidad R-301)
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_ingreso_lote_calidad(
    p_id_lote_insumo INT,
    p_fecha TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE LotesInsumo
       SET fecha_hora_ingreso_lab = p_fecha,
           estado_lote_insumo = 'Pendiente'
     WHERE id_lote_insumo = p_id_lote_insumo;
END;
$$;

-- ----------------------------------------------------
-- Función auxiliar: cantidad de lotes pendientes por compra
-- ----------------------------------------------------
CREATE OR REPLACE FUNCTION cantidad_lotes_pendientes(p_id_compra INT)
RETURNS INT AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM LotesInsumo
    WHERE id_compra = p_id_compra
      AND estado_lote_insumo = 'Pendiente';

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------
-- Procedimiento para registrar inspección de Lote de Insumo
-- (Funcionalidad R-302)
-- ----------------------------------------------------

CREATE SEQUENCE IF NOT EXISTS notificacion_reclamo_seq START 1;


CREATE OR REPLACE PROCEDURE completar_inspeccion_lote_insumo(
    p_id_lote_insumo INT,
    p_estado         VARCHAR(10),
    p_comentario     VARCHAR,
    p_evidencia      VARCHAR,
    p_id_empleado    INT,
    p_motivo         VARCHAR(30) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_inspeccion INT;
    v_id_compra     INT;
    v_pendientes    INT;
    v_todos_aprobados BOOLEAN;
BEGIN
    -- Buscar inspección pendiente existente
    SELECT ig.id_inspeccion
    INTO v_id_inspeccion
    FROM InspeccionesGenerales ig
    JOIN InspeccionesLoteInsumo ili ON ig.id_inspeccion = ili.id_inspeccion
    WHERE ili.id_lote_insumo = p_id_lote_insumo AND ig.estado_revision = 'Pendiente';

    -- Si no se encontró, salir
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró inspección pendiente para el lote %', p_id_lote_insumo;
    END IF;

    -- Actualizar inspección
    UPDATE InspeccionesGenerales
       SET fecha_hora_inspeccion = NOW(),
           comentario = p_comentario,
           evidencia = p_evidencia,
           id_empleado = p_id_empleado,
           estado_revision = 'Revisado'
     WHERE id_inspeccion = v_id_inspeccion;

    -- Actualizar motivo en tabla hija
    UPDATE InspeccionesLoteInsumo
       SET motivo_rechazo = NULLIF(TRIM(p_motivo), '')
     WHERE id_inspeccion = v_id_inspeccion;

    -- Actualizar estado del lote
    UPDATE LotesInsumo
       SET estado_lote_insumo = p_estado
     WHERE id_lote_insumo = p_id_lote_insumo;

    -- Si el estado es RECHAZADO, registrar notificación de reclamo
    IF LOWER(TRIM(p_estado)) = 'rechazado' THEN
        INSERT INTO NotificacionesReclamo (
            id_notificacion_reclamo,
            codigo,
            id_lote_insumo,
            id_empleado,
            estado
        ) VALUES (
            nextval('notificacionesreclamo_id_notificacion_reclamo_seq'),
            CONCAT('NR', LPAD(nextval('notificacion_reclamo_seq')::text, 6, '0')),
            p_id_lote_insumo,
            p_id_empleado,
            'Pendiente'
        );
    END IF;

    -- Obtener id_compra para ese lote
    SELECT id_compra INTO v_id_compra
    FROM LotesInsumo
    WHERE id_lote_insumo = p_id_lote_insumo;

    -- Verificar si quedan lotes pendientes por inspeccionar en esa compra
    SELECT cantidad_lotes_pendientes(v_id_compra) INTO v_pendientes;

    IF v_pendientes = 0 THEN
        -- Verificar si todos los lotes de esa compra han sido aprobados
        SELECT bool_and(estado_lote_insumo = 'Aprobado')
        INTO v_todos_aprobados
        FROM LotesInsumo
        WHERE id_compra = v_id_compra
          AND estado_lote_insumo != 'Pendiente';  -- ignorar los que aún no han sido inspeccionados

        -- Actualizar estado de la compra
        UPDATE Compras
           SET estado = CASE
                            WHEN v_todos_aprobados THEN 'Aceptado'::estado_compra_enum
                            ELSE 'Rechazado'::estado_compra_enum
                        END
         WHERE id_compra = v_id_compra;
    END IF;
END;
$$;


-- ----------------------------------------------------
-- Procedimiento para registrar inspección de Proceso
-- (Funcionalidad R-303)
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_inspeccion_proceso(
    p_id_proceso INT,
    p_tipo VARCHAR(10),
    p_fallo VARCHAR(10),
    p_detalle VARCHAR,
    p_perdida NUMERIC,
    p_estado VARCHAR(10),
    p_comentario VARCHAR,
    p_evidencia VARCHAR,
    p_id_empleado INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_inspeccion INT;
    v_id_maquina INT;
    v_id_lote INT;
BEGIN
    -- Obtener el lote asociado
    SELECT id_lote_producto INTO v_id_lote
    FROM ProcesosRecurrente
    WHERE id_proceso_recurrente = p_id_proceso;

    -- Obtener la inspección pendiente correspondiente
    SELECT ig.id_inspeccion INTO v_id_inspeccion
    FROM InspeccionesGenerales ig
    JOIN InspeccionesProceso ip ON ip.id_inspeccion = ig.id_inspeccion
    WHERE ip.id_proceso_recurrente = p_id_proceso
      AND ig.estado_revision = 'Pendiente'
    LIMIT 1;

    IF v_id_inspeccion IS NULL THEN
        RAISE EXCEPTION 'No hay inspección pendiente para este proceso.';
    END IF;

    -- Actualizar datos generales de la inspección
    UPDATE InspeccionesGenerales
    SET fecha_hora_inspeccion = NOW(),
        estado_revision = 'Revisado',
        comentario = p_comentario,
        evidencia = p_evidencia,
        id_empleado = p_id_empleado
    WHERE id_inspeccion = v_id_inspeccion;

    -- Actualizar datos específicos de inspección de proceso
    UPDATE InspeccionesProceso
    SET tipo_proceso = p_tipo,
        tipo_fallo = p_fallo,
        detalle_fallo_proceso = p_detalle,
        cantidad_perdida = p_perdida
    WHERE id_inspeccion = v_id_inspeccion;

    -- Actualizar estado del proceso
    UPDATE ProcesosRecurrente
    SET estado_calidad = p_estado,
        estado = CASE
                    WHEN p_estado = 'Rechazado' THEN 'Retirado'
                    ELSE 'Completado'
                 END
    WHERE id_proceso_recurrente = p_id_proceso;

    -- Si el fallo fue por máquina, registrar solicitud de mantenimiento
    IF p_fallo = 'Maquina' THEN
        CASE p_tipo
            WHEN 'Mezclado' THEN
                SELECT id_ejemplar_maquina INTO v_id_maquina
                FROM Mezclados
                WHERE id_proceso_recurrente = p_id_proceso;
            WHEN 'Moldeado' THEN
                SELECT id_ejemplar_maquina INTO v_id_maquina
                FROM Moldeados
                WHERE id_proceso_recurrente = p_id_proceso;
            WHEN 'Secado' THEN
                SELECT id_ejemplar_maquina INTO v_id_maquina
                FROM Secados
                WHERE id_proceso_recurrente = p_id_proceso;
        END CASE;

        INSERT INTO SolicitudesMantenimiento(
            codigo, fecha_solicitud, tipo_mantenimiento,
            estado, id_ejemplar_maquina, id_inspeccion_proceso
        ) VALUES (
            NULL, NOW(), 'Correctivo', 'Pendiente',
            v_id_maquina,
            v_id_inspeccion
        );
    END IF;

    -- Actualizar la etapa del lote si corresponde
    CALL actualizar_etapa_lote(v_id_lote);
END;
$$;

-- ----------------------------------------------------
-- Procedimiento para registrar inspección de Envasado
-- (Funcionalidad R-304)
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_inspeccion_envasado(
    p_id_envasado INT,
    p_defecto VARCHAR(10),
    p_cantidad NUMERIC,
    p_estado VARCHAR(10),
    p_comentario VARCHAR,
    p_evidencia VARCHAR,
    p_id_empleado INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_inspeccion INT;
BEGIN
    INSERT INTO InspeccionesGenerales(
        codigo, tipo_inspeccion, fecha_hora_inspeccion,
        estado_revision, comentario, evidencia, id_empleado
    ) VALUES (
        generar_codigo_inspeccion(), 'Envasado', NOW(),
        'Revisado', p_comentario, p_evidencia, p_id_empleado
    ) RETURNING id_inspeccion INTO v_id_inspeccion;

    INSERT INTO InspeccionesEnvasado(
        id_inspeccion, id_envasado,
        tipo_defecto_empaque, cantidad_envases_defectuosos
    ) VALUES (
        v_id_inspeccion, p_id_envasado, p_defecto, p_cantidad
    );

    UPDATE Envasados
    SET estado_calidad = p_estado,
       estado = CASE
                   WHEN p_estado = 'Rechazado' THEN 'Retirado'
                   ELSE 'Completado'
                END
    WHERE id_envasado = p_id_envasado;
	
	CALL actualizar_etapa_lote(v_id_lote);
END;
$$;

-- ----------------------------------------------------
-- Procedimiento para registrar inspección de Lote en Picking
-- (Funcionalidad R-305)
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_inspeccion_picking(
    p_id_picking INT,
    p_id_lote_producto INT,
    p_cantidad NUMERIC,
    p_motivo VARCHAR(30),
    p_estado VARCHAR(10),
    p_comentario VARCHAR,
    p_evidencia VARCHAR,
    p_id_empleado INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_inspeccion INT;
BEGIN
    INSERT INTO InspeccionesGenerales(
        codigo, tipo_inspeccion, fecha_hora_inspeccion,
        estado_revision, comentario, evidencia, id_empleado
    ) VALUES (
        generar_codigo_inspeccion(), 'Picking', NOW(),
        'Revisado', p_comentario, p_evidencia, p_id_empleado
    ) RETURNING id_inspeccion INTO v_id_inspeccion;

    INSERT INTO InspeccionesPicking(
        id_inspeccion, id_picking, id_lote_producto,
        cantidad_observada, otro_motivo
    ) VALUES (
        v_id_inspeccion, p_id_picking, p_id_lote_producto,
        p_cantidad, p_motivo
    );

    UPDATE Pickings
       SET estado_picking = p_estado
     WHERE id_picking = p_id_picking;
END;
$$;

-- ----------------------------------------------------
-- Procedimiento para registrar inspección por lote en Picking
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE registrar_inspeccion_lote_picking(
    p_id_picking INT,
    p_id_lote_producto INT,
    p_cantidad NUMERIC,
    p_motivos TEXT,
    p_otro_motivo VARCHAR,
    p_comentario VARCHAR,
    p_evidencia VARCHAR,
    p_id_empleado INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_inspeccion INT;
    v_motivo TEXT;
BEGIN
    INSERT INTO InspeccionesGenerales(
        codigo, tipo_inspeccion, fecha_hora_inspeccion,
        estado_revision, comentario, evidencia, id_empleado
    ) VALUES (
        generar_codigo_inspeccion(), 'Picking', NOW(),
        'Revisado',
        p_comentario, p_evidencia, p_id_empleado
    ) RETURNING id_inspeccion INTO v_id_inspeccion;

    INSERT INTO InspeccionesPicking(
        id_inspeccion, id_picking, id_lote_producto,
        cantidad_observada, otro_motivo
    ) VALUES (
        v_id_inspeccion, p_id_picking, p_id_lote_producto,
        p_cantidad, p_otro_motivo
    );

    IF p_motivos IS NOT NULL THEN
        FOREACH v_motivo IN ARRAY string_to_array(p_motivos, ',') LOOP
            INSERT INTO MotivosXInspeccionPicking(id_inspeccion, id_motivo)
            VALUES (v_id_inspeccion, v_motivo::INT);
        END LOOP;
    END IF;
END;
$$;


-- ----------------------------------------------------
-- Procedimiento para actualizar la etapa de produccion del lote
-- ----------------------------------------------------
CREATE OR REPLACE PROCEDURE actualizar_etapa_lote(p_id_lote INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_etapa_actual VARCHAR(15);
    v_pendientes   INT := 0;
BEGIN
    -- Obtener la etapa actual del lote
    SELECT etapa_produccion INTO v_etapa_actual
    FROM LotesProducto
    WHERE id_lote_producto = p_id_lote;

    -- Verificar pendientes según etapa actual
    IF v_etapa_actual = 'Mezclado' THEN
        SELECT COUNT(*) INTO v_pendientes
        FROM Mezclados mz
        JOIN ProcesosRecurrente pr ON mz.id_proceso_recurrente = pr.id_proceso_recurrente
        LEFT JOIN InspeccionesProceso ip ON pr.id_proceso_recurrente = ip.id_proceso_recurrente
        LEFT JOIN InspeccionesGenerales ig ON ip.id_inspeccion = ig.id_inspeccion
        WHERE pr.id_lote_producto = p_id_lote
          AND (ig.estado_revision IS DISTINCT FROM 'Revisado');

        IF v_pendientes = 0 THEN
            UPDATE LotesProducto
               SET etapa_produccion = 'Moldeado'
             WHERE id_lote_producto = p_id_lote;
        END IF;

    ELSIF v_etapa_actual = 'Moldeado' THEN
        SELECT COUNT(*) INTO v_pendientes
        FROM Moldeados md
        JOIN ProcesosRecurrente pr ON md.id_proceso_recurrente = pr.id_proceso_recurrente
        LEFT JOIN InspeccionesProceso ip ON pr.id_proceso_recurrente = ip.id_proceso_recurrente
        LEFT JOIN InspeccionesGenerales ig ON ip.id_inspeccion = ig.id_inspeccion
        WHERE pr.id_lote_producto = p_id_lote
          AND (ig.estado_revision IS DISTINCT FROM 'Revisado');

        IF v_pendientes = 0 THEN
            UPDATE LotesProducto
               SET etapa_produccion = 'Secado'
             WHERE id_lote_producto = p_id_lote;
        END IF;

    ELSIF v_etapa_actual = 'Secado' THEN
        SELECT COUNT(*) INTO v_pendientes
        FROM Secados sc
        JOIN ProcesosRecurrente pr ON sc.id_proceso_recurrente = pr.id_proceso_recurrente
        LEFT JOIN InspeccionesProceso ip ON pr.id_proceso_recurrente = ip.id_proceso_recurrente
        LEFT JOIN InspeccionesGenerales ig ON ip.id_inspeccion = ig.id_inspeccion
        WHERE pr.id_lote_producto = p_id_lote
          AND (ig.estado_revision IS DISTINCT FROM 'Revisado');

        IF v_pendientes = 0 THEN
            UPDATE LotesProducto
               SET etapa_produccion = 'Envasado'
             WHERE id_lote_producto = p_id_lote;
        END IF;

    ELSIF v_etapa_actual = 'Secado' THEN
        SELECT COUNT(*) INTO v_pendientes
        FROM Secados sc
        JOIN ProcesosRecurrente pr ON sc.id_proceso_recurrente = pr.id_proceso_recurrente
        LEFT JOIN InspeccionesProceso ip ON pr.id_proceso_recurrente = ip.id_proceso_recurrente
        LEFT JOIN InspeccionesGenerales ig ON ip.id_inspeccion = ig.id_inspeccion
        WHERE pr.id_lote_producto = p_id_lote
          AND (ig.estado_revision IS DISTINCT FROM 'Revisado');

        IF v_pendientes = 0 THEN
            -- Verificar si ya existe registro de envasado para este lote
            IF EXISTS (
                SELECT 1 FROM Envasados WHERE id_lote_producto = p_id_lote
            ) THEN
                UPDATE LotesProducto
                   SET etapa_produccion = 'Envasado'
                 WHERE id_lote_producto = p_id_lote;
            END IF;
        END IF;
    END IF;
END;
$$;

-- ----------------------------------------------------
-- Vista general del historial de inspecciones
-- (Funcionalidad R-306)
-- ----------------------------------------------------
CREATE OR REPLACE VIEW vista_historial_inspecciones_general AS
SELECT
    ig.codigo,
    ig.tipo_inspeccion,
    ig.fecha_hora_inspeccion,
    e.codigo AS inspector
FROM InspeccionesGenerales ig
JOIN Empleados e ON ig.id_empleado = e.id_empleado;

-- Vista por lotes de insumo inspeccionados
CREATE OR REPLACE VIEW vista_inspecciones_lote_insumo AS
SELECT
    ig.codigo,
    li.codigo AS lote_insumo,
    ig.estado_revision,
    ig.fecha_hora_inspeccion
FROM InspeccionesGenerales ig
JOIN InspeccionesLoteInsumo ili ON ig.id_inspeccion = ili.id_inspeccion
JOIN LotesInsumo li ON ili.id_lote_insumo = li.id_lote_insumo;

-- Vista por envasado
CREATE OR REPLACE VIEW vista_inspecciones_envasado AS
SELECT
    ig.codigo,
    ev.codigo AS envasado,
    ie.cantidad_envases_defectuosos,
    ig.estado_revision,
    ig.fecha_hora_inspeccion
FROM InspeccionesGenerales ig
JOIN InspeccionesEnvasado ie ON ig.id_inspeccion = ie.id_inspeccion
JOIN Envasados ev ON ie.id_envasado = ev.id_envasado;

-- Vista por picking
CREATE OR REPLACE VIEW vista_inspecciones_picking AS
SELECT
    ig.codigo,
    pk.codigo AS picking,
    ip.cantidad_defectuosa,
    ig.estado_revision,
    ig.fecha_hora_inspeccion
FROM InspeccionesGenerales ig
JOIN InspeccionesPicking ip ON ig.id_inspeccion = ip.id_inspeccion
JOIN Pickings pk ON ip.id_picking = pk.id_picking;

-- ----------------------------------------------------
-- Vista materializada de resumen diario
-- (Apoya R-306, consultas de histórico)
-- ----------------------------------------------------
CREATE MATERIALIZED VIEW mv_inspecciones_por_dia AS
SELECT
    date(fecha_hora_inspeccion) AS dia,
    tipo_inspeccion,
    COUNT(*) AS total
FROM InspeccionesGenerales
GROUP BY dia, tipo_inspeccion
ORDER BY dia;

-- ----------------------------------------------------
-- Índices adicionales
-- ----------------------------------------------------
CREATE INDEX idx_inspecciones_generales_empleado
  ON InspeccionesGenerales(id_empleado);

CREATE INDEX idx_inspecciones_lote_insumo_lote
  ON InspeccionesLoteInsumo(id_lote_insumo);

CREATE INDEX idx_inspecciones_proceso_proceso
  ON InspeccionesProceso(id_proceso_recurrente);

CREATE INDEX idx_inspecciones_envasado_envasado
  ON InspeccionesEnvasado(id_envasado);

CREATE INDEX idx_inspecciones_picking_picking
  ON InspeccionesPicking(id_picking);
CREATE INDEX idx_inspecciones_picking_lote
  ON InspeccionesPicking(id_lote_producto);

-- ==========================================================================================================================
-- Modulo 4
-- ==========================================================================================================================

CREATE UNIQUE INDEX idx_notificacionesreclamo_codigo ON NotificacionesReclamo (codigo);
CREATE UNIQUE INDEX idx_lotesinsumo_codigo ON LotesInsumo (codigo);
CREATE UNIQUE INDEX idx_reclamos_codigo ON Reclamos (codigo);

-- Función para insertar un nuevo registro en PropuestasCompra:
CREATE OR REPLACE FUNCTION insertar_propuesta_compra(
    p_codigo VARCHAR(8),
    p_id_empleado INT,
    p_id_proveedor INT,
    p_id_solicitud_abastecimiento INT,
    p_fecha_propuesta_compra TIMESTAMP,
    p_fecha_acuerdo_entrega TIMESTAMP,
    p_descuento_compra NUMERIC(4,2),
    p_monto_total_compra NUMERIC(7,2)
) RETURNS VOID AS $$
BEGIN
    INSERT INTO PropuestasCompra (codigo, id_empleado, id_proveedor, id_solicitud_abastecimiento, fecha_propuesta_compra, fecha_acuerdo_entrega, estado, descuento_compra, monto_total_compra)
    VALUES (p_codigo, p_id_empleado, p_id_proveedor, p_id_solicitud_abastecimiento, p_fecha_propuesta_compra, p_fecha_acuerdo_entrega, 'Pendiente', p_descuento_compra, p_monto_total_compra);
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar el estado de las SolicitudesAbastecimiento:
CREATE OR REPLACE FUNCTION actualizar_estado_solicitudes(
    p_ids_solicitudes INT[]
) RETURNS VOID AS $$
BEGIN
    UPDATE SolicitudesAbastecimiento
    SET estado = 'Atendido'
    WHERE id_solicitud_abastecimiento = ANY(p_ids_solicitudes);
END;
$$ LANGUAGE plpgsql;

-- Función para calcular el total de insumos solicitados (si es necesario):
CREATE OR REPLACE FUNCTION calcular_total_insumos(
    p_tipo_insumo VARCHAR,
    p_id_proveedor INT
) RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(ds.cantidad_requeridos * ip.precio_referencial)
    INTO total
    FROM Insumos i
    JOIN InsumosXProveedores ip ON i.id_insumo = ip.id_insumo
    JOIN DetallesSolicitud ds ON i.id_insumo = ds.id_insumo
    JOIN SolicitudesAbastecimiento sa ON ds.id_solicitud_abastecimiento = sa.id_solicitud_abastecimiento
    WHERE sa.estado = 'Pendiente' AND i.tipo_insumo = p_tipo_insumo AND ip.id_proveedor = p_id_proveedor;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION register_provider(
    p_nombre_comercial VARCHAR,
    p_razon_social VARCHAR,
    p_ruc VARCHAR,
    p_direccion VARCHAR,
    p_telefonos TEXT[],  -- Array of phone numbers
    p_tipo_insumo VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_id_empresa INT;
    v_id_proveedor INT;
BEGIN
    -- Insert into Empresas table
    INSERT INTO Empresas (razon_social, codigo_ruc, direccion)
    VALUES (p_razon_social, p_ruc, p_direccion)
    RETURNING id_empresa INTO v_id_empresa;

    -- Insert into Proveedores table
    INSERT INTO Proveedores (nombre_comercial, id_empresa, tipo_insumo)
    VALUES (p_nombre_comercial, v_id_empresa, p_tipo_insumo)
    RETURNING id_proveedor INTO v_id_proveedor;

    -- Insert into Telefonos Empresa table
    INSERT INTO Telefonos_Empresa (id_empresa, telefono)
    SELECT v_id_empresa, telefono
    FROM unnest(p_telefonos) AS telefono;

    RAISE NOTICE 'Provider registered with ID: %', v_id_proveedor;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION register_provider(
    p_nombre_comercial VARCHAR,
    p_razon_social VARCHAR,
    p_ruc VARCHAR,
    p_direccion VARCHAR,
    p_telefonos TEXT[],  -- Array of phone numbers
    p_tipo_insumo VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_id_empresa INT;
    v_id_proveedor INT;
BEGIN
    -- Insert into Empresas table
    INSERT INTO Empresas (razon_social, codigo_ruc, direccion)
    VALUES (p_razon_social, p_ruc, p_direccion)
    RETURNING id_empresa INTO v_id_empresa;

    -- Insert into Proveedores table
    INSERT INTO Proveedores (nombre_comercial, id_empresa, tipo_insumo)
    VALUES (p_nombre_comercial, v_id_empresa, p_tipo_insumo)
    RETURNING id_proveedor INTO v_id_proveedor;

    -- Insert into Telefonos Empresa table
    INSERT INTO Telefonos_Empresa (id_empresa, telefono)
    SELECT v_id_empresa, telefono
    FROM unnest(p_telefonos) AS telefono;

    RAISE NOTICE 'Provider registered with ID: %', v_id_proveedor;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_provider(
    p_id_proveedor INT,
    p_nombre_comercial VARCHAR,
    p_razon_social VARCHAR,
    p_ruc VARCHAR,
    p_direccion VARCHAR,
    p_telefonos TEXT[],  -- Array of phone numbers
    p_tipo_insumo VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_id_empresa INT;
BEGIN
    -- Get the id_empresa associated with the provider
    SELECT id_empresa INTO v_id_empresa
    FROM Proveedores
    WHERE id_proveedor = p_id_proveedor;

    -- Update Empresas table
    UPDATE Empresas
    SET razon_social = p_razon_social,
        codigo_ruc = p_ruc,
        direccion = p_direccion
    WHERE id_empresa = v_id_empresa;

    -- Update Proveedores table
    UPDATE Proveedores
    SET nombre_comercial = p_nombre_comercial,
        tipo_insumo = p_tipo_insumo
    WHERE id_proveedor = p_id_proveedor;

    -- Clear existing phone numbers
    DELETE FROM Telefonos_Empresa
    WHERE id_empresa = v_id_empresa;

    -- Insert new phone numbers
    INSERT INTO Telefonos_Empresa (id_empresa, telefono)
    SELECT v_id_empresa, telefono
    FROM unnest(p_telefonos) AS telefono;

    RAISE NOTICE 'Provider updated with ID: %', p_id_proveedor;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION register_offered_supply(
    p_id_proveedor INT,
    p_id_insumo INT,
    p_precio_unitario NUMERIC,
    p_unidad VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO InsumosXProveedores (id_proveedor, id_insumo, precio_referencial, unidad_medida)
    VALUES (p_id_proveedor, p_id_insumo, p_precio_unitario, p_unidad);

    RAISE NOTICE 'Supply registered for provider ID: %', p_id_proveedor;
END;
$$ LANGUAGE plpgsql;


-- Índice para la tabla SolicitudesAbastecimiento (para optimizar búsquedas por estado)
CREATE INDEX idx_estado_solicitud ON SolicitudesAbastecimiento(estado);

-- Índice para la tabla DetallesSolicitud (para optimizar búsquedas por id_solicitud_abastecimiento)
CREATE INDEX idx_detalles_solicitud ON DetallesSolicitud(id_solicitud_abastecimiento);

-- Trigger para actualizar el estado de la solicitud de abastecimiento al ser atendida
CREATE OR REPLACE FUNCTION actualizar_estado_solicitud()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'Atendido' THEN
        UPDATE SolicitudesAbastecimiento
        SET estado = 'Atendido'
        WHERE id_solicitud_abastecimiento = NEW.id_solicitud_abastecimiento;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_estado_solicitud
AFTER UPDATE ON PropuestasCompra
FOR EACH ROW
WHEN (NEW.estado = 'Aprobado')
EXECUTE FUNCTION actualizar_estado_solicitud();

-- Vista para mostrar un resumen de las solicitudes de abastecimiento y sus detalles
CREATE VIEW vista_resumen_solicitudes AS
SELECT 
    sa.codigo AS codigo_solicitud,
    DATE(sa.Fecha_solicitud_abastecimiento) AS fecha,
    TO_CHAR(sa.Fecha_solicitud_abastecimiento, 'HH24:MI:SS') AS hora,
    sa.estado,
    ds.cantidad_requeridos,
    i.nombre_insumo,
    i.tipo_insumo
FROM 
    SolicitudesAbastecimiento sa
JOIN 
    DetallesSolicitud ds ON sa.id_solicitud_abastecimiento = ds.id_solicitud_abastecimiento
JOIN 
    Insumos i ON ds.id_insumo = i.id_insumo;

-- Función para registrar una nueva Propuesta de Compra

CREATE OR REPLACE FUNCTION registrar_propuesta_compra(
    p_codigo VARCHAR,
    p_id_empleado INT,
    p_id_proveedor INT,
    p_id_solicitud_abastecimiento INT,
    p_fecha_propuesta_compra TIMESTAMP,
    p_fecha_acuerdo_entrega TIMESTAMP,
    p_estado VARCHAR,
    p_descuento_compra NUMERIC,
    p_monto_total_compra NUMERIC
) RETURNS integer AS $$
DECLARE
    new_id integer;
BEGIN
    INSERT INTO PropuestasCompra (
        codigo, id_empleado, id_proveedor, id_solicitud_abastecimiento,
        fecha_propuesta_compra, fecha_acuerdo_entrega, estado, descuento_compra, monto_total_compra
    ) VALUES (
        p_codigo, p_id_empleado, p_id_proveedor, p_id_solicitud_abastecimiento,
        p_fecha_propuesta_compra, p_fecha_acuerdo_entrega, p_estado, p_descuento_compra, p_monto_total_compra
    ) RETURNING id_propuesta_compra INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar el estado de una Solicitud de Abastecimiento

CREATE OR REPLACE FUNCTION actualizar_estado_solicitud_abastecimiento(
    p_id_solicitud INT,
    p_estado VARCHAR(9)
) RETURNS VOID AS $$
BEGIN
    UPDATE SolicitudesAbastecimiento
    SET estado = p_estado
    WHERE id_solicitud_abastecimiento = p_id_solicitud;
END;
$$ LANGUAGE plpgsql;

-- Vista para simplificar queries de lectura

CREATE OR REPLACE VIEW vista_insumos_proveedor_solicitud AS
SELECT
    ds.id_solicitud_abastecimiento,
    p.id_proveedor,
    i.tipo_insumo,
    i.id_insumo,
    i.nombre_insumo,
    ixp.precio_referencial,
    i.unidad_medida,
    ds.cantidad_requeridos,
    (ixp.precio_referencial * ds.cantidad_requeridos) AS total
FROM
    DetallesSolicitud ds
    JOIN Insumos i ON ds.id_insumo = i.id_insumo
    JOIN InsumosXProveedores ixp ON i.id_insumo = ixp.id_insumo
    JOIN Proveedores p ON ixp.id_proveedor = p.id_proveedor;

-- Para búsquedas rápidas por estado
CREATE INDEX idx_solicitudes_estado ON SolicitudesAbastecimiento(estado);

-- Para búsquedas por tipo de insumo en insumos y proveedores
CREATE INDEX idx_insumos_tipo ON Insumos(tipo_insumo);
CREATE INDEX idx_proveedores_tipo ON Proveedores(tipo_insumo);

-- Para búsquedas frecuentes por proveedor e insumo en InsumosXProveedores
CREATE INDEX idx_ixp_proveedor_insumo ON InsumosXProveedores(id_proveedor, id_insumo);

-- Si necesitas obtener el siguiente código/correlativo)

CREATE OR REPLACE FUNCTION obtener_siguiente_codigo_propuesta() RETURNS VARCHAR AS $$
DECLARE
    ultimo_codigo VARCHAR;
    nuevo_codigo VARCHAR;
BEGIN
    SELECT codigo INTO ultimo_codigo FROM PropuestasCompra ORDER BY id_propuesta_compra DESC LIMIT 1;
    IF ultimo_codigo IS NULL THEN
        nuevo_codigo := 'PC00001';
    ELSE
        -- Asume formato 'PC00001', 'PC00002', etc.
        nuevo_codigo := 'PC' || LPAD((CAST(SUBSTRING(ultimo_codigo, 3) AS INTEGER) + 1)::text, 5, '0');
    END IF;
    RETURN nuevo_codigo;
END;
$$ LANGUAGE plpgsql;

-- ==========================================================================================================================
-- Modulo 5
-- ==========================================================================================================================

-- 1. Crear secuencias para cada tipo de evento
CREATE SEQUENCE codigo_solicitud_produccion_seq START 1;
CREATE SEQUENCE codigo_orden_produccion_seq START 1;
CREATE SEQUENCE codigo_lote_producto_seq START 1;

-- 2. Crear funciones generadoras de código
CREATE OR REPLACE FUNCTION generar_codigo_solicitud_produccion() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_solicitud_produccion_seq');
    RETURN 'SP' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_orden_produccion() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_orden_produccion_seq');
    RETURN 'OP' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generar_codigo_lote_producto() RETURNS CHAR(9) AS $$
DECLARE num INT;
BEGIN
    num := nextval('codigo_lote_producto_seq');
    RETURN 'LP' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

-- 3. Crear funciones de trigger para cada evento
CREATE OR REPLACE FUNCTION asignar_codigo_solicitud_produccion() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_solicitud_produccion();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_orden_produccion() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_orden_produccion();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION asignar_codigo_lote_producto() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_lote_producto();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Crear triggers en las tablas correspondientes
CREATE TRIGGER trg_insert_solicitud_produccion
BEFORE INSERT ON SolicitudesProduccion
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_solicitud_produccion();

CREATE TRIGGER trg_insert_orden_produccion
BEFORE INSERT ON OrdenesProduccion
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_orden_produccion();

CREATE TRIGGER trg_insert_lote_producto
BEFORE INSERT ON LotesProducto
FOR EACH ROW
EXECUTE FUNCTION asignar_codigo_lote_producto();

-- Sincronizar las secuencias con los datos existentes
-- Sincronización de códigos
SELECT setval('codigo_solicitud_produccion_seq', (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM SolicitudesProduccion));
SELECT setval('codigo_orden_produccion_seq',   (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM OrdenesProduccion));
SELECT setval('codigo_lote_producto_seq',   (SELECT MAX(SUBSTRING(codigo, 3)::INT) FROM LotesProducto));


-- Sincronización de ids
SELECT setval('solicitudesproduccion_id_solicitud_produccion_seq', (SELECT MAX(id_solicitud_produccion) FROM SolicitudesProduccion));
SELECT setval('ordenesproduccion_id_orden_produccion_seq', (SELECT MAX(id_orden_produccion ) FROM OrdenesProduccion));
SELECT setval('lotesproducto_id_lote_producto_seq', (SELECT MAX(id_lote_producto ) FROM LotesProducto));

-- ==========================================================================================================================
-- Modulo 6
-- ==========================================================================================================================

create or replace view Info_Lote_Producto as
select l.id_lote_producto, p.id_producto, l.cantidad_producida 
from productos p 
inner join solicitudesproduccion s on s.id_producto = p.id_producto 
inner join ordenesproduccion o on o.id_solicitud_produccion = s.id_solicitud_produccion 
inner join lotesproducto l on l.id_orden_produccion = o.id_orden_produccion 
group by l.id_lote_producto, p.id_producto  
order by l.id_lote_producto;

-- Programaciones de Despacho
CREATE SEQUENCE codigo_prog_desp_seq START 1;

CREATE OR REPLACE FUNCTION generar_codigo_prog_desp()
RETURNS CHAR(10) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('codigo_prog_desp_seq');
RETURN 'PRG' || LPAD(num::TEXT, 5, '0');
END;
$$ LANGUAGE plpgsql;

-- Órdenes de Carga
CREATE SEQUENCE codigo_ord_carga_seq START 1;

CREATE OR REPLACE FUNCTION generar_codigo_ord_carga()
RETURNS CHAR(9) AS $$
DECLARE
    num INT;
BEGIN
    num := nextval('codigo_ord_carga_seq');
RETURN 'OC' || LPAD(num::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql;

-- Programaciones de despacho
CREATE OR REPLACE FUNCTION registrar_codigo_prog_desp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_prog_desp();
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER antes_registro_prog_desp
BEFORE INSERT ON programacionesdespacho
FOR EACH ROW
EXECUTE FUNCTION registrar_codigo_prog_desp();

-- Ordenes de carga
CREATE OR REPLACE FUNCTION registrar_codigo_ord_carga()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.codigo IS NULL THEN
        NEW.codigo := generar_codigo_ord_carga();
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER antes_registro_ord_carga
BEFORE INSERT ON ordenescarga
FOR EACH ROW
EXECUTE FUNCTION registrar_codigo_ord_carga();

-- Funcionalidad Interfaz I-601:
CREATE OR REPLACE FUNCTION obtener_pedidos_pendientes()
RETURNS TABLE(
	ped_cod pedidoscliente.codigo%TYPE, 
	est_ped pedidoscliente.estado_pedido_cliente%TYPE, 
	fec_prog_ent pedidoscliente.fecha_prog_entrega%TYPE
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    select pc.codigo as "Código", pc.estado_pedido_cliente as "Estado del Pedido", pc.fecha_prog_entrega as "Fecha de Entrega"
	from pedidoscliente pc 
	left join pedidosdespacho pd 
	    on pc.id_pedido_cliente = pd.id_pedido_cliente 
	where not(estado_pedido_cliente = 'Completado')
	    and pd.id_prog_desp is null 
	    or pc.id_pedido_cliente in (
	        select pc.id_pedido_cliente
	        from pedidoscliente pc
	        left join pedidosdespacho pd
	        on pc.id_pedido_cliente = pd.id_pedido_cliente 
	        group by pc.id_pedido_cliente 
	        having pc.estado_pedido_cliente = 'Despacho parcial'
	        and count(*) = 1
    	);
END;
$$;

-- Funcionalidad Interfaz I-603:

-- Registrar Programacion Despacho y Orden Carga
CREATE OR REPLACE PROCEDURE registrar_prog_despacho_datos(
	cod_emp empleados.codigo%TYPE, 
	fec_salida programacionesdespacho.fecha_prog_salida%TYPE
)
LANGUAGE plpgsql
AS $$
BEGIN
	-- Insertar en programacionesdespacho
	INSERT INTO programacionesdespacho (id_empleado, fecha_prog_salida, fecha_programacion)
	SELECT e.id_empleado, fec_salida, current_timestamp
	FROM empleados e 
	WHERE e.codigo = cod_emp;

	-- Insertar en ordenescarga
	INSERT INTO ordenescarga (id_prog_desp, estado)
	SELECT id_prog_desp, 'En espera'
	FROM programacionesdespacho 
	ORDER BY fecha_programacion DESC 
	LIMIT 1;
END;
$$;

-- Carga de Página (Ventana Emergente)
CREATE OR REPLACE FUNCTION lista_ped_selec()
RETURNS TABLE(
	ped_cod pedidoscliente.codigo%TYPE, 
	est_ped pedidoscliente.estado_pedido_cliente%TYPE,
	fec_prog_ent pedidoscliente.fecha_prog_entrega%TYPE,
	zona_ent TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT 
		pc.codigo,
		pc.estado_pedido_cliente,
		pc.fecha_prog_entrega,
		u.departamento || ' - ' || u.provincia || ' - ' || u.distrito AS "Zona de Entrega"
	FROM pedidoscliente pc 
	LEFT JOIN pedidosdespacho pd 
		ON pc.id_pedido_cliente = pd.id_pedido_cliente 
	INNER JOIN ubigeos u
		ON pc.ubigeo_entrega = u.id_ubigeo 
	WHERE NOT (estado_pedido_cliente = 'Completado')
		AND pd.id_prog_desp IS NULL 
		OR pc.id_pedido_cliente IN (
			SELECT pc.id_pedido_cliente
			FROM pedidoscliente pc
			LEFT JOIN pedidosdespacho pd
				ON pc.id_pedido_cliente = pd.id_pedido_cliente 
			GROUP BY pc.id_pedido_cliente 
			HAVING pc.estado_pedido_cliente = 'Despacho parcial'
				AND COUNT(*) = 1
		);
END;
$$;

-- Asignar un pedido a una programación de despacho
CREATE OR REPLACE PROCEDURE seleccionar_pedido_prog(pedido_cod pedidoscliente.codigo%type)
LANGUAGE plpgsql
AS $$
BEGIN
    insert into pedidosdespacho (id_prog_desp, id_pedido_cliente, motivo_despacho)
	select 
	    (select id_prog_desp
	     from programacionesdespacho
	     order by fecha_programacion desc 
	     limit 1),
	    p.id_pedido_cliente,
	    case 
	        when p.estado_pedido_cliente = 'Despacho parcial' then 'Reposicion'::motivo_despacho_enum
	        else 'Entrega'::motivo_despacho_enum
	    end 
	from pedidoscliente p
	where p.codigo = pedido_cod;
END;
$$;

-- Lista de pedidos asignados a la programación de despacho

CREATE OR REPLACE FUNCTION pedidos_asignados_prog()
RETURNS TABLE(
	ped_cod pedidoscliente.codigo%TYPE, 
	est_ped pedidoscliente.estado_pedido_cliente%TYPE,
	fec_prog_ent pedidoscliente.fecha_prog_entrega%TYPE,
	zona_ent TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	select pc.codigo as "Código Pedido", pc.estado_pedido_cliente as "Estado", pc.fecha_prog_entrega as "Fecha Programada de Entrega", 
	    u.departamento || ' - ' || u.provincia || ' - ' || u.distrito as "Zona de Entrega"
	from pedidosdespacho pd
	inner join pedidoscliente pc
	    on pd.id_pedido_cliente = pc.id_pedido_cliente 
	inner join ubigeos u
	    on pc.ubigeo_entrega = u.id_ubigeo 
	where pd.id_prog_desp = (select id_prog_desp from programacionesdespacho order by fecha_programacion desc limit 1);
END;
$$;

-- Procedimiento de poblamiento de registros de entrega (se crean registros vacíos en contenido pero necesarios para enlaces)
create or replace procedure crear_reg_ent()
language plpgsql
as $$
declare
    id_prog programacionesdespacho.id_prog_desp%TYPE;
    id_pedido pedidosdespacho.id_pedido_cliente%TYPE;
    id_carga ordenescarga.id_orden_carga%TYPE;
begin
    -- Obtener id de la programacion del despacho
    SELECT id_prog_desp
    INTO id_prog
    FROM programacionesdespacho
    WHERE fecha_programacion = (
        SELECT MAX(fecha_programacion) FROM programacionesdespacho
    );

    -- Obtener el id de la orden de carga
    SELECT id_orden_carga
    INTO id_carga
    FROM ordenescarga
    WHERE id_prog_desp = id_prog;

    -- Recorrer los pedidos
    FOR id_pedido IN
        SELECT pdesp.id_pedido_cliente
        FROM pedidosdespacho pdesp
        INNER JOIN programacionesdespacho prog
            ON pdesp.id_prog_desp = prog.id_prog_desp
        WHERE prog.id_prog_desp = id_prog
    LOOP
        -- RAISE NOTICE 'ID Pedido Cliente: %', id_pedido;

        -- Creación del Registro de Entrega
        INSERT INTO registrosentrega (id_orden_carga, estado_entrega) VALUES (id_carga, 'Pendiente');
        -- RAISE NOTICE 'REGISTRO DE ENTREGA: % - %', id_carga, id_pedido;

        -- Creación de los Detalles de Entrega
        INSERT INTO detallesentrega (id_reg_ent, id_picking, id_lote_producto)
        SELECT
            (
                select re.id_reg_ent 
                from registrosentrega re
                inner join ordenescarga oc
                    on oc.id_orden_carga = re.id_orden_carga 
                where oc.id_orden_carga = id_carga
                order by re.id_reg_ent desc
                limit 1
            ), p.id_picking, dpick.id_lote_producto
        FROM pickings p 
        INNER JOIN detallespicking dpick
            ON p.id_picking = dpick.id_picking
        WHERE p.id_pedido_cliente = id_pedido
            AND p.fecha_picking = (select max(fecha_picking) from pickings where id_pedido_cliente = id_pedido);
    END LOOP;
end; $$;

-- Funcionalidad Interfaz I-615:

-- Carga de Página:

CREATE OR REPLACE FUNCTION seguimiento_ordenes_carga()
RETURNS TABLE(
	oc_cod ordenescarga.codigo%TYPE, 
	oc_est ordenescarga.estado%TYPE,
	fec_prog_sal TEXT,
	zona_ent TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	select 
	    oc.codigo as "Código", 
	    oc.estado as "Estado", 
	    to_char(pd.fecha_prog_salida, 'YYYY-MM-DD HH24:MI') as "Fecha Prog. Salida", 
	    (
	        select u.departamento || ' - ' || u.provincia
	        from programacionesdespacho p 
	        inner join pedidosdespacho pdesp on p.id_prog_desp = pdesp.id_prog_desp
	        inner join pedidoscliente pc on pc.id_pedido_cliente = pdesp.id_pedido_cliente 
	        inner join ubigeos u on pc.ubigeo_entrega = u.id_ubigeo
	        where p.id_prog_desp = pd.id_prog_desp 
	        limit 1
	    ) as "Zona de Entrega"
	from ordenescarga oc
	inner join programacionesdespacho pd
	    on oc.id_prog_desp = pd.id_prog_desp
	where not(oc.estado = 'Finalizado');
END;
$$;

-- Funcionalidad Interfaz I-618:

create or replace procedure registrar_tipo_guia(cod_oc ordenescarga.codigo%type, cod_ped pedidoscliente.codigo%type, tipo_gr VARCHAR)
language plpgsql
as $$
begin
    insert into guiasremision (id_reg_ent, motivo_traslado, fecha_emision)
	select distinct re.id_reg_ent, tipo_gr, current_timestamp --::motivo_traslado_enum
	from registrosentrega re
	inner join ordenescarga oc
	    on re.id_orden_carga = oc.id_orden_carga 
	inner join detallesentrega dent
	    on re.id_reg_ent = dent.id_reg_ent 
	inner join detallespicking dpick
	    on dpick.id_picking = dent.id_picking and dpick.id_lote_producto = dent.id_lote_producto 
	inner join pickings pick
	    on pick.id_picking = dpick.id_picking 
	inner join pedidoscliente pc
	    on pc.id_pedido_cliente = pick.id_pedido_cliente 
	where oc.codigo = cod_oc and pc.codigo = cod_ped;
end; 
$$;


-- Funcionalidad Registros de Entrega

CREATE OR REPLACE PROCEDURE registrar_detalles_entrega(
	cod_lote lotesproducto.codigo%TYPE, 
	cant_obs detallesentrega.cant_observada%type,
	tipo_inc tiposincidencia.descripcion%type,
	observ detallesentrega.observacion%type,
	cod_ped pedidoscliente.codigo%type,
	cod_oc ordenescarga.codigo%type
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE detallesentrega d
	SET 
	    cant_observada = cant_obs, 
	    tipo_incidencia = (SELECT codigo FROM tiposincidencia WHERE descripcion = tipo_inc),
	    observacion = observ
	WHERE EXISTS (
	    SELECT 1
	    FROM detallespicking dpick
	    INNER JOIN pickings p ON p.id_picking = dpick.id_picking
	    INNER JOIN lotesproducto lp ON d.id_lote_producto = lp.id_lote_producto
	    INNER JOIN registrosentrega rent ON d.id_reg_ent = rent.id_reg_ent
	    INNER JOIN ordenescarga oc ON rent.id_orden_carga = oc.id_orden_carga
	    INNER JOIN pedidoscliente pc ON pc.id_pedido_cliente = p.id_pedido_cliente
	    WHERE 
	        dpick.id_picking = d.id_picking
	        AND dpick.id_lote_producto = d.id_lote_producto
	        AND pc.codigo = cod_ped
	        AND oc.codigo = cod_oc
	        AND lp.codigo = cod_lote
	);
END;
$$;



CREATE OR REPLACE PROCEDURE registrar_recepcionista(
	num_dni personas.dni%TYPE, 
	nom personas.nombre%type,
	ap_pat personas.ap_paterno%type,
	ap_mat personas.ap_materno%type,
	cod_ped pedidoscliente.codigo%type,
	cod_oc ordenescarga.codigo%type
)
LANGUAGE plpgsql
AS $$
BEGIN
	insert into personas (dni, nombre, ap_paterno, ap_materno) values (num_dni, nom, ap_pat, ap_mat);

	update registrosentrega 
	set id_receptor = (select id_persona from personas where dni = num_dni)
	where id_reg_ent = (
		select distinct rent.id_reg_ent 
		from detallesentrega dent
		inner join detallespicking dpick
			on dpick.id_picking = dent.id_picking and dpick.id_lote_producto = dent.id_lote_producto 
		inner join pickings pick
			on pick.id_picking = dpick.id_picking
		inner join registrosentrega rent
			on rent.id_reg_ent = dent.id_reg_ent 
		inner join pedidoscliente pc
			on pc.id_pedido_cliente = pick.id_pedido_cliente 
		inner join ordenescarga oc
			on oc.id_orden_carga = rent.id_orden_carga 
		where oc.codigo = cod_oc and pc.codigo = cod_ped
	);
END;
$$;



CREATE OR REPLACE PROCEDURE actualizar_pedido_entrega(
	cant_obs detallesentrega.cant_observada%type,
	cod_ped pedidoscliente.codigo%type,
	cod_oc ordenescarga.codigo%type
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF cant_obs = 0 THEN
		update pedidoscliente 
		set estado_pedido_cliente = 'Completado'
		where codigo = cod_ped;
		
		update registrosentrega 
		set estado_entrega = 'Conforme'
		where id_reg_ent = (
			select distinct rent.id_reg_ent 
			from detallesentrega dent
			inner join detallespicking dpick
				on dpick.id_picking = dent.id_picking and dpick.id_lote_producto = dent.id_lote_producto 
			inner join pickings pick
				on pick.id_picking = dpick.id_picking
			inner join registrosentrega rent
				on rent.id_reg_ent = dent.id_reg_ent 
			inner join pedidoscliente pc
				on pc.id_pedido_cliente = pick.id_pedido_cliente 
			inner join ordenescarga oc
				on oc.id_orden_carga = rent.id_orden_carga 
			where oc.codigo = cod_oc and pc.codigo = cod_ped
		    );
	ELSE
		update pedidoscliente 
		set estado_pedido_cliente = 'Despacho parcial'
		where id_pedido_cliente = (
		        select id_pedido_cliente 
		        from pedidoscliente 
		        where codigo = cod_ped
		    );
		
		update registrosentrega 
		set estado_entrega = 'Rechazado'
		where id_reg_ent = (
			select distinct rent.id_reg_ent 
			from detallesentrega dent
			inner join detallespicking dpick
				on dpick.id_picking = dent.id_picking and dpick.id_lote_producto = dent.id_lote_producto 
			inner join pickings pick
				on pick.id_picking = dpick.id_picking
			inner join registrosentrega rent
				on rent.id_reg_ent = dent.id_reg_ent 
			inner join pedidoscliente pc
				on pc.id_pedido_cliente = pick.id_pedido_cliente 
			inner join ordenescarga oc
				on oc.id_orden_carga = rent.id_orden_carga 
			where oc.codigo = cod_oc and pc.codigo = cod_ped
		    );
		
		update ordenescarga 
		set estado = 'Incidencia'
		where codigo = cod_oc;
	END IF;
END;
$$;


-- ==========================================================================================================================
-- Modulo 7
-- ==========================================================================================================================