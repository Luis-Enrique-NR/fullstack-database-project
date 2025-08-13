/*
-- Forzar el dropeo del esquema
DROP SCHEMA public CASCADE;

-- Reconstruir el esquema
CREATE SCHEMA public;
*/

DROP TABLE IF EXISTS Personas CASCADE;
DROP TABLE IF EXISTS TelefonosPersona CASCADE;
DROP TABLE IF EXISTS CorreosPersona CASCADE;
DROP TABLE IF EXISTS Ubigeos CASCADE;
DROP TABLE IF EXISTS Empresas CASCADE;
DROP TABLE IF EXISTS TelefonosEmpresa CASCADE;
DROP TABLE IF EXISTS TiposUnidad CASCADE;
DROP TABLE IF EXISTS Vehiculos CASCADE;
DROP TABLE IF EXISTS EmpresasTransporte CASCADE;
DROP TABLE IF EXISTS Transportistas CASCADE;
DROP TABLE IF EXISTS GuiasRemision CASCADE;
DROP TABLE IF EXISTS ProgramacionesDespacho CASCADE;
DROP TABLE IF EXISTS RegistrosEntrega CASCADE;
DROP TABLE IF EXISTS OrdenesCarga CASCADE;
DROP TABLE IF EXISTS PedidosDespacho CASCADE;
DROP TABLE IF EXISTS TiposIncidencia CASCADE;
DROP TABLE IF EXISTS DetallesEntrega CASCADE;
DROP TABLE IF EXISTS RecepcionesAlmacen CASCADE;
DROP TABLE IF EXISTS Empleados CASCADE;
DROP TABLE IF EXISTS PedidosCliente CASCADE;
DROP TABLE IF EXISTS Clientes CASCADE;
DROP TABLE IF EXISTS LotesProducto CASCADE;
DROP TABLE IF EXISTS Productos CASCADE;
DROP TABLE IF EXISTS OrdenesProduccion CASCADE;
DROP TABLE IF EXISTS SolicitudesProduccion CASCADE;
DROP TABLE IF EXISTS DetallesPedido CASCADE;
DROP TABLE IF EXISTS Insumos CASCADE;
DROP TABLE IF EXISTS Formulaciones CASCADE;
DROP TABLE IF EXISTS DetallesFormulacion CASCADE;
DROP TABLE IF EXISTS Ubicaciones CASCADE;
DROP TABLE IF EXISTS Recepciones CASCADE;
DROP TABLE IF EXISTS LotesInsumo CASCADE;
DROP TABLE IF EXISTS Abastecimientos CASCADE;
DROP TABLE IF EXISTS InventariosAbastecimiento CASCADE;
DROP TABLE IF EXISTS DetallesSolicitud CASCADE;
DROP TABLE IF EXISTS SolicitudesAbastecimiento CASCADE;
DROP TABLE IF EXISTS OrdenesMantenimiento CASCADE;
DROP TABLE IF EXISTS SolicitudesMantenimiento CASCADE;
DROP TABLE IF EXISTS EjemplaresMaquina CASCADE;
DROP TABLE IF EXISTS TiposMaquina CASCADE;
DROP TABLE IF EXISTS Envasados CASCADE;
DROP TABLE IF EXISTS Secados CASCADE;
DROP TABLE IF EXISTS Moldeados CASCADE;
DROP TABLE IF EXISTS TiposBoquilla CASCADE;
DROP TABLE IF EXISTS Mezclados CASCADE;
DROP TABLE IF EXISTS ProcesosRecurrente CASCADE;
DROP TABLE IF EXISTS DosificadosXLotesInsumo CASCADE;
DROP TABLE IF EXISTS Dosificados CASCADE;
DROP TABLE IF exists Proveedores CASCADE;
DROP TABLE IF exists PropuestasCompra CASCADE;
DROP TABLE IF exists SeguimientosCompra CASCADE;
DROP TABLE IF exists OrdenesCompra CASCADE;
DROP TABLE IF exists Compras CASCADE;
DROP TABLE IF exists NotificacionesReclamo CASCADE;
DROP TABLE IF exists Reclamos CASCADE;
DROP TABLE IF exists InsumosxProveedores CASCADE;
DROP TABLE IF EXISTS InspeccionesLoteInsumo CASCADE;
DROP TABLE IF EXISTS InspeccionesProceso CASCADE;
DROP TABLE IF EXISTS InspeccionesEnvasado CASCADE;
DROP TABLE IF EXISTS InspeccionesPicking CASCADE;
DROP TABLE IF EXISTS InspeccionesGenerales CASCADE;
DROP TABLE IF EXISTS Pickings CASCADE;
DROP TABLE IF EXISTS DetallesPicking CASCADE;
DROP TABLE IF EXISTS Recepciones CASCADE;
DROP TABLE IF EXISTS Stocks CASCADE;
DROP TABLE IF EXISTS DetallesMovimiento CASCADE;
DROP TABLE IF EXISTS Movimientos CASCADE;
DROP TABLE IF EXISTS RecepcionesAlmacen CASCADE;

-- ENUMs
DO $$ BEGIN
    DROP TYPE IF EXISTS estado_actividad_enum;
END $$;
CREATE TYPE estado_actividad_enum AS ENUM ('Activo', 'Inactivo');

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_cobertura_enum;
END $$;
CREATE TYPE tipo_cobertura_enum AS ENUM ('Local', 'Regional', 'Interprovincial', 'Nacional');

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_unidad_enum;
END $$;
CREATE TYPE tipo_unidad_enum AS ENUM ('Camión', 'Furgoneta', 'Camioneta', 'Tráiler');

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_servicio_enum;
END $$;
CREATE TYPE tipo_servicio_enum AS ENUM ('Propio', 'Tercerizado');

DO $$ BEGIN
    DROP TYPE IF EXISTS disponibilidad_enum;
END $$;
CREATE TYPE disponibilidad_enum AS ENUM ('Disponible', 'Ocupado');

DO $$ BEGIN
    DROP TYPE IF EXISTS motivo_traslado_enum;
END $$;
CREATE TYPE motivo_traslado_enum AS ENUM ('Venta', 'Devolucion');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_entrega_enum;
END $$;
CREATE TYPE estado_entrega_enum AS ENUM ('Pendiente', 'Conforme', 'Rechazado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_orden_carga_enum;
END $$;
CREATE TYPE estado_orden_carga_enum AS ENUM ('En espera', 'Picking listo', 'En transito', 'Incidencia', 'Finalizado');

DO $$ BEGIN
    DROP TYPE IF EXISTS motivo_despacho_enum;
END $$;
CREATE TYPE motivo_despacho_enum AS ENUM ('Entrega', 'Reposicion');

DO $$ BEGIN
    DROP TYPE IF EXISTS unidad_medida_enum ;
END $$;
CREATE TYPE unidad_medida_enum AS ENUM ('kg','ton', 'u');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_recepcion_enum;
END $$;
CREATE TYPE estado_recepcion_enum AS ENUM ('En entrega','Proceso de Calidad', 'A recepcionar');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_abastecimiento_enum;
END $$;
CREATE TYPE estado_abastecimiento_enum AS ENUM ('atender','Atendido');

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_insumo_enum;
END $$;
CREATE TYPE tipo_insumo_enum AS ENUM ('Materia Prima','Aditivo','Material Empaque');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_laboral_enum;
END $$;
CREATE TYPE estado_laboral_enum AS ENUM ('Activo', 'Retirado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_ejemplar_enum CASCADE;
END $$;
CREATE TYPE estado_ejemplar_enum AS ENUM ('Operativo', 'En mantenimiento', 'Fuera de servicio');

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_mantenimiento_enum CASCADE;
END $$;
CREATE TYPE tipo_mantenimiento_enum AS ENUM ('Preventivo', 'Correctivo');

DO $$ BEGIN
    DROP TYPE IF EXISTS etapa_enum CASCADE;
END $$;
CREATE TYPE etapa_enum AS ENUM ('Dosificado', 'Mezclado', 'Moldeado', 'Secado', 'Envasado','Almacen');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_orden_enum CASCADE;
END $$;
CREATE TYPE estado_orden_enum AS ENUM ('En proceso', 'Completado', 'Con retraso');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_solicitud_enum CASCADE;
END $$;CREATE TYPE estado_solicitud_enum AS ENUM ('Atendida', 'Con retraso', 'Pendiente');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_solicitud_abastecimiento_enum;
END $$;
CREATE TYPE estado_solicitud_abastecimiento_enum AS ENUM ('Pendiente', 'Atendido');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_propuesta_compra_enum;
END $$;
CREATE TYPE estado_propuesta_compra_enum AS ENUM ('Pendiente', 'Aprobado', 'Rechazado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_orden_compra_enum;
END $$;
CREATE TYPE estado_orden_compra_enum AS ENUM ('Sin Enviar', 'Pendiente', 'Pagado', 'Cancelado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_compra_enum;
END $$;
CREATE TYPE estado_compra_enum AS ENUM ('Sin Revision', 'En Proceso', 'Aceptado', 'Rechazado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_seguimiento_compra_enum;
END $$;
CREATE TYPE estado_seguimiento_compra_enum AS ENUM ('Pendiente', 'A Tiempo', 'Con Retraso', 'Cancelado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_notificacion_reclamo_enum;
END $$;
CREATE TYPE estado_notificacion_reclamo_enum AS ENUM ('Pendiente', 'Atendido');

DO $$ BEGIN
    DROP TYPE IF EXISTS objetivo_reclamo_enum;
END $$;
CREATE TYPE objetivo_reclamo_enum AS ENUM ('Reposicion', 'Devolucion');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_reclamo_enum;
END $$;
CREATE TYPE estado_reclamo_enum AS ENUM ('Pendiente', 'Completado');

DO $$ BEGIN
    DROP TYPE IF EXISTS estado_pedido_cliente_enum;
END $$;
CREATE TYPE estado_pedido_cliente_enum AS ENUM ('Pendiente','Pickeado','Despacho parcial','Completado');  -- Despacho parcial

DO $$ BEGIN
    DROP TYPE IF EXISTS tipo_cliente_enum CASCADE;
END $$;
CREATE TYPE tipo_cliente_enum AS ENUM ('Retail', 'Mayorista', 'Distribuidor local');

CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(70) NOT NULL,
    peso_producto NUMERIC(5,2),
    cantidad_envases_empaque NUMERIC(3),
    presentacion VARCHAR(18) CHECK (presentacion IN ('Bolsa de plastico', 'Caja de carton')),
    precio_unitario NUMERIC(5,2),
    descripcion TEXT
);

CREATE TABLE Ubigeos (
    id_ubigeo CHAR(6) PRIMARY KEY,
    departamento VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL
);

CREATE TABLE Personas (
    id_persona SERIAL PRIMARY KEY,
    dni CHAR(8) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    ap_paterno VARCHAR(50) NOT NULL,
    ap_materno VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    ubigeo_direccion CHAR(6),
    fecha_nac DATE,
    FOREIGN KEY (ubigeo_direccion) REFERENCES Ubigeos(id_ubigeo)
);

CREATE TABLE TelefonosPersona (
    id_persona INT NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    PRIMARY KEY (id_persona, telefono),
    FOREIGN KEY (id_persona) REFERENCES Personas(id_persona)
);

CREATE TABLE CorreosPersona (
    id_persona INT NOT NULL,
    correo VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_persona, correo),
    FOREIGN KEY (id_persona) REFERENCES Personas(id_persona)
);

CREATE TABLE Empresas (
    id_empresa SERIAL PRIMARY KEY,
    codigo_ruc CHAR(11) NULL UNIQUE,
    razon_social VARCHAR(80) NULL,
    nombre_comercial VARCHAR(80),
    direccion VARCHAR(150),
    ubigeo_direccion CHAR(6),
    FOREIGN KEY (ubigeo_direccion) REFERENCES Ubigeos(id_ubigeo)
);

CREATE TABLE TelefonosEmpresa (
    id_empresa INT NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    PRIMARY KEY (id_empresa, telefono),
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
);

CREATE TABLE Empleados (
    id_empleado INT PRIMARY KEY,
    codigo CHAR(5) UNIQUE NOT NULL,
    estado_laboral estado_laboral_enum NOT NULL,
    area VARCHAR(40) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Personas(id_persona)
);

CREATE TABLE Insumos (
    id_insumo SERIAL PRIMARY KEY,
    codigo VARCHAR(20) unique not NULL,
    nombre_insumo VARCHAR(30)  not NULL,
    unidad_medida VARCHAR(3) check (unidad_medida in ('kg', 'ton', 'u')), -- unidad_medida_enum not NULL
    tipo_insumo VARCHAR(16) check (tipo_insumo in ('Materia Prima', 'Aditivo', 'Material Empaque', NULL)), -- tipo_insumo_enum not null
    stock_minimo INT not null,
    rango_venc_alerta INT not null 
);

CREATE TABLE Formulaciones (
    id_formulacion SERIAL PRIMARY key,
    id_producto INT not NULL,
    codigo VARCHAR(29) UNIQUE not NULL, 
    Nombre_formulacion VARCHAR(100) not null,
    fecha_creacion DATE not null,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE DetallesFormulacion (
    id_formulacion INT NOT NULL,
    id_insumo INT NOT NULL,
    cantidad_asignada NUMERIC(5,2) NOT NULL,
    PRIMARY KEY (id_formulacion, id_insumo),
    FOREIGN KEY (id_formulacion) REFERENCES Formulaciones(id_formulacion),
    FOREIGN KEY (id_insumo) REFERENCES Insumos(id_insumo)
);

create table Proveedores (
	id_proveedor SERIAL primary key,
	codigo VARCHAR(5) unique not null,
	id_empresa INT NOT null,
	tipo_insumo VARCHAR(16) check (tipo_insumo in ('Materia Prima', 'Aditivo', 'Material Empaque', NULL)), -- tipo_insumo_enum not null

	FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
);

CREATE TABLE SolicitudesAbastecimiento (
    id_solicitud_abastecimiento SERIAL PRIMARY KEY,
    codigo VARCHAR(50) unique NOT null,
    Fecha_solicitud_abastecimiento timestamp not null,
    id_empleado INT NOT NULL,
    estado VARCHAR(9) check (estado in ('Pendiente', 'Atendido')), -- estado_solicitud_abastecimiento_enum not null,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

create table PropuestasCompra (
	id_propuesta_compra SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_empleado INT not null,
	id_proveedor INT not null,
	id_solicitud_abastecimiento INT not null,
	fecha_propuesta_compra TIMESTAMP not null,
	fecha_acuerdo_entrega TIMESTAMP not null,
	estado VARCHAR(9) CHECK (estado in ('Pendiente', 'Aprobado', 'Rechazado')),-- estado_propuesta_compra_enum not null
	descuento_compra NUMERIC(4,2) not null CHECK (descuento_compra >= 0),
	monto_total_compra NUMERIC(7,2) NOT NULL CHECK (monto_total_compra >= 0),
	
	foreign key (id_empleado) references Empleados(id_empleado),
	foreign key (id_proveedor) references Proveedores(id_proveedor),
	foreign key (id_solicitud_abastecimiento) references SolicitudesAbastecimiento(id_solicitud_abastecimiento)
);

create table OrdenesCompra (
	id_orden_compra SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_propuesta_compra INT not null,
	id_empleado INT not null,
	estado VARCHAR(10) CHECK (estado in ('Sin enviar', 'Pendiente', 'Pagado' , 'Cancelado')), -- estado_orden_compra_enum not null
	
	foreign key (id_empleado) references Empleados(id_empleado),
	foreign key (id_propuesta_compra) references PropuestasCompra(id_propuesta_compra)
);

create table Compras (
	id_compra SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_orden_compra INT not null,
	estado VARCHAR(12) check (estado in ('Sin revision', 'En proceso', 'Aceptado', 'Rechazado', null)), -- estado_compra_enum null
	
	foreign key (id_orden_compra) references OrdenesCompra(id_orden_compra)
);

create table SeguimientosCompra (
	id_seguimiento_compra SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_compra INT not null,
	fecha_ingreso_compra TIMESTAMP null,
	estado VARCHAR(11) CHECK (estado in ('Pendiente', 'A Tiempo', 'Con Retraso', 'Cancelado')), --estado_seguimiento_compra_enum not null
	
	foreign key (id_compra) references Compras(id_compra)
);

CREATE TABLE Ubicaciones (
    id_ubicacion SERIAL PRIMARY KEY,
    zona VARCHAR(50) NOT NULL ,
    estanteria VARCHAR(50) NOT NULL,
    nivel VARCHAR(50) NOT NULL
);

CREATE TABLE Recepciones (
    id_recepcion SERIAL PRIMARY KEY,
    codigo VARCHAR(20) unique not NULL, 
    fecha_llegada TIMESTAMP,
    estado VARCHAR(20) CHECK (estado IN ('En entrega','Proceso de Calidad', 'A recepcionar', 'Recepcionado')),--estado_recepcion_enum ,
    id_compra INT NOT NULL,
    id_empleado INT NULL,
    foreign key (id_compra) references Compras(id_compra),
    foreign key (id_empleado) references Empleados(id_empleado)
);

CREATE TABLE LotesInsumo (
    id_lote_insumo SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    cantidad_recibida INT NULL,
    cantidad_disponible INT NULL,
    fecha_vencimiento DATE NULL,
    estado_lote_insumo VARCHAR(10) CHECK (estado_lote_insumo IN ('Pendiente','Aprobado','Rechazado')),
    id_insumo INT NOT NULL,
    id_compra INT NOT NULL,
    id_recepcion INT NULL,
    id_ubicacion INT NULL,
    fecha_hora_ingreso_lab TIMESTAMP NULL,
    foreign key (id_insumo) references Insumos(id_insumo),
    foreign key (id_recepcion) references Recepciones(id_recepcion),
    foreign key (id_ubicacion) references Ubicaciones(id_ubicacion),
    foreign key (id_compra) references Compras(id_compra)
);

CREATE TABLE InspeccionesGenerales (
    id_inspeccion SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    tipo_inspeccion VARCHAR(20) NOT NULL CHECK (tipo_inspeccion IN ('Lote de Insumo', 'Proceso', 'Envasado', 'Picking')),
    fecha_hora_inspeccion TIMESTAMP,
    estado_revision VARCHAR(10) NOT NULL CHECK (estado_revision IN ('Pendiente', 'Revisado')),
    comentario VARCHAR(300),
    evidencia VARCHAR(250),
    id_empleado INT ,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE InspeccionesLoteInsumo (
    id_inspeccion INT PRIMARY KEY,
    id_lote_insumo INT NOT NULL,
    motivo_rechazo VARCHAR(30) CHECK (motivo_rechazo IN ('Saco roto', 'Humedad visible', 'Fecha vencida', 'Color o textura anormal', 'Contaminacion')),
    foreign key (id_inspeccion) references InspeccionesGenerales(id_inspeccion),
    foreign key (id_lote_insumo) references LotesInsumo(id_lote_insumo)
);

create table NotificacionesReclamo (
	id_notificacion_reclamo SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_lote_insumo INT not null,
	id_empleado INT not null,
	estado varchar(9) check (estado in ('Pendiente', 'Atendido')), -- estado_notificacion_reclamo_enum not null
	
	foreign key (id_empleado) references Empleados(id_empleado),
	foreign key (id_lote_insumo) references LotesInsumo(id_lote_insumo)
);

create table Reclamos (
	id_reclamo SERIAL primary key,
	codigo VARCHAR(8) unique not null,
	id_notificacion_reclamo INT null,
	objetivo VARCHAR(10) CHECK (objetivo in ('Reposicion', 'Devolucion')), -- objetivo_reclamo_enum not null,
	estado VARCHAR(10) CHECK (estado in ('Pendiente', 'Completado')), -- estado_reclamo_enum not null
	id_lote_insumo INT null,
	monto_devuelto numeric(6,2) null CHECK (monto_devuelto >= 0),
	fecha_atencion_reclamo TIMESTAMP null,
	foreign key (id_lote_insumo) references LotesInsumo(id_lote_insumo),
	foreign key (id_notificacion_reclamo) references NotificacionesReclamo(id_notificacion_reclamo)
);

create table InsumosXProveedores (
	precio_referencial NUMERIC(4,2) not null CHECK (precio_referencial >= 0),
	id_proveedor INT not null,
	id_insumo INT not null,
	
	primary key (id_proveedor, id_insumo),
	foreign key (id_proveedor) references Proveedores(id_proveedor),
	foreign key (id_insumo) references Insumos(id_insumo)
);

CREATE TABLE SolicitudesProduccion (
    id_solicitud_produccion SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    cantidad_requerida INT NOT NULL,
    fecha_requerida DATE NOT NULL,
    fecha_solicitud TIMESTAMP NOT NULL,
    estado estado_solicitud_enum NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

CREATE TABLE OrdenesProduccion (
    id_orden_produccion SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    fecha_emision TIMESTAMP NOT NULL,
    fecha_fin_estimada DATE NOT NULL,
    fecha_finalizacion DATE,
    estado estado_orden_enum NOT NULL,
    id_solicitud_produccion INT ,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_solicitud_produccion) REFERENCES SolicitudesProduccion(id_solicitud_produccion),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Abastecimientos (
    id_abastecimiento SERIAL PRIMARY key,
    codigo VARCHAR(50) unique NOT null,
    fecha_abastecimiento TIMESTAMP ,
    estado VARCHAR(20) CHECK (estado IN ('atender','Atendido')), --estado_abastecimiento_enum
    id_empleado INT NULL,
    id_orden_produccion INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_orden_produccion) REFERENCES OrdenesProduccion(id_orden_produccion)
);

CREATE TABLE InventariosAbastecimiento (
    id_abastecimiento INT not null,
    id_lote_insumo INT not null,
    cantidad_asignada NUMERIC(5,2) not null,
    PRIMARY KEY (id_abastecimiento, id_lote_insumo),
    FOREIGN KEY (id_abastecimiento) REFERENCES Abastecimientos(id_abastecimiento),
    FOREIGN KEY (id_lote_insumo) REFERENCES LotesInsumo(id_lote_insumo)    
);

CREATE TABLE DetallesSolicitud (
    id_solicitud_abastecimiento INT not NULL,
    id_insumo INT not NULL,
    cantidad_requeridos INT not null,
    PRIMARY KEY (id_solicitud_abastecimiento, id_insumo),
    FOREIGN KEY (id_insumo) REFERENCES Insumos(id_insumo),
    FOREIGN KEY (id_solicitud_abastecimiento) REFERENCES SolicitudesAbastecimiento(id_solicitud_abastecimiento)
);

CREATE TABLE TiposIncidencia (
    codigo CHAR(2) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE EmpresasTransporte (
    id_empresa INT PRIMARY KEY,
    tipo_cobertura tipo_cobertura_enum NOT NULL,
    detalle_cobertura VARCHAR(50),
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
);

CREATE TABLE Vehiculos (
    id_vehiculo SERIAL PRIMARY KEY,
    num_placa CHAR(7) NOT NULL UNIQUE,
    tipo_unidad tipo_unidad_enum NOT NULL,
    estado estado_actividad_enum,
    disponibilidad disponibilidad_enum,
    capac_peso NUMERIC(5) CHECK (capac_peso > 0),
    capac_emp NUMERIC(4) CHECK (capac_emp > 0),
    id_empresa INT,
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
);

CREATE TABLE Transportistas (
    id_transportista SERIAL PRIMARY KEY,
    id_empresa INT,
    num_licencia CHAR(9) NOT NULL UNIQUE,
    estado estado_actividad_enum,
    disponibilidad disponibilidad_enum,
    FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa),
    FOREIGN KEY (id_transportista) REFERENCES Personas(id_persona)
);

CREATE TABLE ProgramacionesDespacho (
    id_prog_desp SERIAL PRIMARY KEY,
    id_transportista INT,
    id_vehiculo INT,
    id_empleado INT NOT NULL,
    codigo CHAR(8) NOT NULL UNIQUE,
    tipo_servicio VARCHAR(11) CHECK(tipo_servicio IN ('Propio', 'Tercerizado')), -- tipo_servicio_enum,
    fecha_prog_salida TIMESTAMP NOT NULL,
    fecha_programacion TIMESTAMP NOT NULL,
    FOREIGN KEY (id_transportista) REFERENCES Transportistas(id_transportista),
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE OrdenesCarga (
    id_orden_carga SERIAL PRIMARY KEY,
    id_prog_desp INT NOT NULL,
    codigo CHAR(8) NOT NULL UNIQUE,
    fecha_salida TIMESTAMP,
    estado VARCHAR(15) CHECK (estado IN ('En espera', 'Picking listo', 'En transito', 'Incidencia', 'Finalizado')), --estado_orden_carga_enum NOT NULL,
    FOREIGN KEY (id_prog_desp) REFERENCES ProgramacionesDespacho(id_prog_desp)
);

CREATE TABLE Clientes (
	id_cliente SERIAL PRIMARY KEY,
	tipo_cliente tipo_cliente_enum,
	FOREIGN KEY (id_cliente) REFERENCES Empresas(id_empresa)
);

CREATE TABLE PedidosCliente (
    id_pedido_cliente SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    estado_pedido_cliente VARCHAR(16) CHECK (estado_pedido_cliente IN ('Pendiente','Pickeado','Despacho parcial','Completado')),--estado_pedido_cliente_enum NOT NULL,
    fecha_pedido TIMESTAMP NOT NULL,
    fecha_prog_entrega DATE NOT NULL,
    direccion_entrega VARCHAR(150),
    ubigeo_entrega CHAR(6),
    FOREIGN KEY (ubigeo_entrega) REFERENCES Ubigeos(id_ubigeo),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE PedidosDespacho (
    id_prog_desp INT NOT NULL,
    id_pedido_cliente INT NOT NULL,
    motivo_despacho motivo_despacho_enum NOT NULL,
    PRIMARY KEY (id_prog_desp, id_pedido_cliente),
    FOREIGN KEY (id_prog_desp) REFERENCES ProgramacionesDespacho(id_prog_desp),
    FOREIGN KEY (id_pedido_cliente) REFERENCES PedidosCliente(id_pedido_cliente)
);

CREATE TABLE RegistrosEntrega (
	id_reg_ent SERIAL PRIMARY KEY,
    id_orden_carga INT NOT NULL,
    --id_pedido_cliente INT NOT NULL,
    estado_entrega estado_entrega_enum NOT NULL,
    fecha_entrega TIMESTAMP,
    id_receptor INT,
    FOREIGN KEY (id_orden_carga) REFERENCES OrdenesCarga(id_orden_carga),
    --FOREIGN KEY (id_pedido_cliente) REFERENCES PedidosCliente(id_pedido_cliente),
    FOREIGN KEY (id_receptor) REFERENCES Personas(id_persona)
);

CREATE TABLE GuiasRemision (
    id_guia_rem SERIAL PRIMARY KEY,
    id_reg_ent INT NOT NULL,
    num_guia CHAR(13) UNIQUE,
    motivo_traslado VARCHAR(10) CHECK (motivo_traslado IN ('Venta', 'Devolucion')), --motivo_traslado_enum NOT NULL,
    fecha_emision TIMESTAMP NOT NULL,
    origen_direccion VARCHAR(150),
    ubigeo_origen CHAR(6),
    destino_direccion VARCHAR(150),
    ubigeo_destino CHAR(6),
    FOREIGN KEY (id_reg_ent) REFERENCES RegistrosEntrega(id_reg_ent),
    FOREIGN KEY (ubigeo_origen) REFERENCES Ubigeos(id_ubigeo),
    FOREIGN KEY (ubigeo_destino) REFERENCES Ubigeos(id_ubigeo)
);

CREATE TABLE LotesProducto (
    id_lote_producto SERIAL PRIMARY KEY,
    codigo CHAR(8)  UNIQUE NOT NULL,
    cantidad_planeada INT NOT NULL,
    cantidad_producida INT NOT NULL,
    cantidad_disponible INT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    estado_lote_producto VARCHAR(15) CHECK (estado_lote_producto IN ('En proceso', 'Completado', 'En inspeccion', 'Retirado')),
    estado_calidad VARCHAR(15) CHECK (estado_calidad IN ('Pendiente', 'Aprobado', 'Rechazado')), 
    fecha_vencimiento DATE,
    etapa_produccion VARCHAR(15) CHECK (etapa_produccion IN ('Dosificado', 'Mezclado', 'Moldeado', 'Secado', 'Envasado','Almacen')),  
    id_orden_produccion INT NOT NULL,
    FOREIGN KEY (id_orden_produccion) REFERENCES OrdenesProduccion(id_orden_produccion)
);

CREATE TABLE TiposMaquina (
    id_tipo_maquina SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    etapa_produccion etapa_enum NOT NULL
);

CREATE TABLE EjemplaresMaquina (
    id_ejemplar_maquina SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    fecha_instalacion DATE,
    estado estado_ejemplar_enum NOT NULL,
    fecha_ultimo_mantenimiento DATE,
    plan_mantenimiento INT NOT NULL,
    id_tipo_maquina INT NOT NULL ,
 	FOREIGN KEY (id_tipo_maquina) REFERENCES TiposMaquina(id_tipo_maquina)
);

CREATE TABLE Dosificados (
    id_dosificado SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    numero_batch NUMERIC(2) CHECK (numero_batch > 0),
    fecha_proceso TIMESTAMP NOT NULL,
    tiempo_proceso NUMERIC(3) CHECK (tiempo_proceso > 0),
    estado VARCHAR(15) check (estado in ('Completado', 'En inspeccion', 'En proceso', 'Retirado')),
    id_lote_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE DosificadosXLotesInsumo (
    id_dosificado INT NOT NULL,
    id_lote_insumo INT NOT NULL,
    cantidad_dosificada NUMERIC(4,1) CHECK (cantidad_dosificada > 0),
    
    PRIMARY KEY (id_dosificado, id_lote_insumo),
    
    FOREIGN KEY (id_dosificado) REFERENCES Dosificados(id_dosificado),
    FOREIGN KEY (id_lote_insumo) REFERENCES LotesInsumo(id_lote_insumo)
);

CREATE TABLE ProcesosRecurrente (
    id_proceso_recurrente SERIAL PRIMARY KEY,
    numero_batch NUMERIC(2) CHECK (numero_batch > 0),
    fecha_proceso TIMESTAMP NOT NULL,
    tiempo_proceso NUMERIC(3) CHECK (tiempo_proceso > 0),
    peso_inicial NUMERIC(6,1) CHECK (peso_inicial > 0),
    merma NUMERIC(5,1) CHECK (merma >= 0),
    estado VARCHAR(15) CHECK (estado IN ('En proceso', 'Completado', 'En inspeccion', 'Retirado')),
    estado_calidad VARCHAR(15) CHECK (estado_calidad IN ('Pendiente', 'Aprobado', 'Rechazado')), 
    id_lote_producto INT NOT NULL,
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto)
);

CREATE TABLE Mezclados (
    id_proceso_recurrente INT PRIMARY key, 
    codigo CHAR(8) UNIQUE NOT NULL,
    porcentaje_humedad NUMERIC(2,2) CHECK (porcentaje_humedad > 0),
    cantidad_agua NUMERIC(4) CHECK (cantidad_agua > 0),
    id_empleado INT NOT NULL,
    id_ejemplar_maquina INT NOT NULL,
    id_formulacion INT NOT NULL,
    FOREIGN KEY (id_proceso_recurrente) REFERENCES ProcesosRecurrente(id_proceso_recurrente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_ejemplar_maquina) REFERENCES EjemplaresMaquina(id_ejemplar_maquina),
    FOREIGN KEY (id_formulacion) references Formulaciones(id_formulacion)
);

CREATE TABLE TiposBoquilla (
    codigo VARCHAR(5) PRIMARY KEY,
    descripcion VARCHAR(15) NOT NULL
);

CREATE TABLE Moldeados (
    id_proceso_recurrente INT PRIMARY KEY, 
    codigo CHAR(8) UNIQUE NOT NULL,
    tipo_boquilla VARCHAR(5) NOT NULL,
    presion NUMERIC(3) CHECK (presion > 0),
    velocidad_corte NUMERIC(6,2) CHECK (velocidad_corte > 0),
    tamano_corte NUMERIC(2) CHECK (tamano_corte > 0),
    id_empleado INT NOT NULL,
    id_ejemplar_maquina INT NOT NULL,
    FOREIGN KEY (id_proceso_recurrente) REFERENCES ProcesosRecurrente(id_proceso_recurrente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_ejemplar_maquina) REFERENCES EjemplaresMaquina(id_ejemplar_maquina),
    FOREIGN KEY (tipo_boquilla) REFERENCES TiposBoquilla(codigo)
);

CREATE TABLE Secados (
    id_proceso_recurrente INT PRIMARY KEY, 
    codigo CHAR(8) UNIQUE NOT NULL,
    numero_bandejas NUMERIC(2) CHECK (numero_bandejas > 0),
    temperatura_inicial NUMERIC(7,3) CHECK (temperatura_inicial > 0),
    temperatura_final NUMERIC(7,3) CHECK (temperatura_final > 0),
    porcentaje_humedad numeric(5,2) CHECK (porcentaje_humedad > 0),
    id_empleado INT NOT NULL,
    id_ejemplar_maquina INT NOT NULL,
    FOREIGN KEY (id_proceso_recurrente) REFERENCES ProcesosRecurrente(id_proceso_recurrente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_ejemplar_maquina) REFERENCES EjemplaresMaquina(id_ejemplar_maquina)
);

CREATE TABLE Envasados (
    id_envasado SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    fecha_proceso TIMESTAMP NOT NULL,
    numero_batch NUMERIC(2) CHECK (numero_batch > 0),
    tipo_envase VARCHAR(18) CHECK (tipo_envase IN ('Bolsa de plastico', 'Caja de carton')),
    tiempo_proceso NUMERIC(3,1) CHECK (tiempo_proceso > 0),
    peso NUMERIC(4) CHECK (peso > 0),
    estado VARCHAR(15) CHECK (estado IN ('En proceso', 'Completado', 'En inspeccion', 'Retirado')),
    estado_calidad VARCHAR(15) CHECK (estado_calidad IN ('Pendiente', 'Aprobado', 'Rechazado')), 
    id_lote_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE InspeccionesProceso (
    id_inspeccion INT PRIMARY KEY,
    id_proceso_recurrente INT NOT NULL,
    tipo_proceso VARCHAR(10) NOT NULL CHECK (tipo_proceso IN ('Mezclado', 'Moldeado', 'Secado')), -- Mezclado, Moldeado o Secado
    tipo_fallo VARCHAR(10) CHECK (tipo_fallo IN ('Humano', 'Maquina')),
    detalle_fallo_proceso VARCHAR(100),
    cantidad_perdida NUMERIC(6,2) DEFAULT 0.00,

    FOREIGN KEY (id_inspeccion) REFERENCES InspeccionesGenerales(id_inspeccion),
    FOREIGN KEY (id_proceso_recurrente) REFERENCES ProcesosRecurrente(id_proceso_recurrente)
);

CREATE TABLE InspeccionesEnvasado (
    id_inspeccion INT PRIMARY KEY,
    id_envasado INT NOT NULL,
    tipo_defecto_empaque VARCHAR(10) CHECK (tipo_defecto_empaque IN ('Leve', 'Critico')),
    cantidad_envases_defectuosos NUMERIC(4,0) CHECK (cantidad_envases_defectuosos >= 0),
    FOREIGN KEY (id_inspeccion) REFERENCES InspeccionesGenerales(id_inspeccion),
    FOREIGN KEY (id_envasado) REFERENCES Envasados(id_envasado)
);

CREATE TABLE SolicitudesMantenimiento(
    id_solicitud_mantenimiento SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    fecha_solicitud TIMESTAMP,
    fecha_requerida DATE,
    tipo_mantenimiento tipo_mantenimiento_enum NOT NULL,
    estado estado_solicitud_enum NOT NULL,
    id_ejemplar_maquina INT NOT NULL ,
    id_inspeccion_proceso INT ,
	FOREIGN KEY (id_ejemplar_maquina) REFERENCES EjemplaresMaquina(id_ejemplar_maquina),
	FOREIGN KEY (id_inspeccion_proceso) REFERENCES InspeccionesProceso(id_inspeccion)
);

CREATE TABLE OrdenesMantenimiento (
    id_orden_mantenimiento SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    fecha_emision TIMESTAMP,
    fecha_fin_estimada DATE,
    fecha_finalizacion DATE,
    estado estado_orden_enum NOT NULL,
    id_empleado INT NOT NULL,
    id_tecnico INT NOT NULL,
    id_solicitud_mantenimiento INT,
    FOREIGN KEY (id_solicitud_mantenimiento) REFERENCES SolicitudesMantenimiento(id_solicitud_mantenimiento),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    FOREIGN KEY (id_tecnico) REFERENCES Personas(id_persona)
);

CREATE TABLE Pickings (
    id_picking SERIAL PRIMARY KEY,
    codigo CHAR(8) UNIQUE NOT NULL,
    estado_picking VARCHAR(10) CHECK (estado_picking IN ('Aprobado', 'Rechazado')),
    id_pedido_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_picking TIMESTAMP NOT NULL,
    FOREIGN KEY (id_pedido_cliente) REFERENCES PedidosCliente(id_pedido_cliente),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE DetallesPicking (
	id_picking INT NOT NULL,
	id_lote_producto INT NOT NULL,
	cantidad_asignada NUMERIC(5) CHECK (cantidad_asignada >= 0),
    PRIMARY KEY (id_picking, id_lote_producto),
	FOREIGN KEY (id_picking) REFERENCES Pickings(id_picking),
	FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto)
);

CREATE TABLE DetallesEntrega (
    id_det_ent SERIAL PRIMARY KEY,
	id_reg_ent INT NOT NULL,
    id_picking INT NOT NULL,
    id_lote_producto INT NOT NULL,
    -- cant_entregada NUMERIC(3) CHECK (cant_entregada >= 0),
    cant_observada NUMERIC(3) CHECK (cant_observada >= 0),
    tipo_incidencia CHAR(2),
    observacion VARCHAR(100),
    -- PRIMARY KEY (id_reg_ent, id_lote_producto),
    FOREIGN KEY (id_reg_ent) REFERENCES RegistrosEntrega(id_reg_ent),
    FOREIGN KEY (id_picking, id_lote_producto) REFERENCES DetallesPicking(id_picking, id_lote_producto),
    FOREIGN KEY (tipo_incidencia) REFERENCES TiposIncidencia(codigo)
);

CREATE TABLE InspeccionesPicking (
    id_inspeccion INT PRIMARY KEY,
    id_picking INT NOT NULL,
    id_lote_producto INT NOT NULL,
    cantidad_defectuosa NUMERIC(5,0) CHECK (cantidad_defectuosa >= 0),
    motivo_defecto VARCHAR(30) CHECK (motivo_defecto IN ('Caja rota', 'Sellado deficiente', 'Codigo ilegible', 'Exceso de humedad', 'Golpe visible')),
    FOREIGN KEY (id_inspeccion) REFERENCES InspeccionesGenerales(id_inspeccion),
    FOREIGN KEY (id_picking) REFERENCES Pickings(id_picking),
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto)
);

CREATE TABLE Movimientos (
    id_movimiento SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE DetallesMovimiento (
    id_detalle_movimiento SERIAL PRIMARY KEY,
    cantidad_movida NUMERIC(3),
    id_ubicacion_inicial INT,
    id_ubicacion_final INT,
    id_lote_producto INT NOT NULL,
    id_movimiento INT NOT NULL,
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto),
    FOREIGN KEY (id_movimiento) REFERENCES Movimientos(id_movimiento),
    FOREIGN KEY (id_ubicacion_inicial) REFERENCES Ubicaciones(id_ubicacion),
    FOREIGN KEY (id_ubicacion_final) REFERENCES Ubicaciones(id_ubicacion)
);

CREATE TABLE DetallesPedido (
    id_producto INT NOT NULL,
    id_pedido_cliente INT NOT NULL,
    cantidad_solicitada NUMERIC(3) NOT NULL,
    PRIMARY KEY (id_producto, id_pedido_cliente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
    FOREIGN KEY (id_pedido_cliente) REFERENCES PedidosCliente(id_pedido_cliente)
);

CREATE TABLE RecepcionesAlmacen (
    id_recepcion SERIAL PRIMARY KEY,
    fecha_recepcion DATE NOT NULL,
    hora_recepcion TIME,
    cantidad NUMERIC(10,2),
    id_lote_producto INT NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_lote_producto) REFERENCES LotesProducto(id_lote_producto),
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);