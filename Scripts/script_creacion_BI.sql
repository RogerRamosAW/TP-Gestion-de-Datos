USE GD1C2025
GO

/****************************************
 1) DROPS TABLES Y VIEWS (limpieza inicial)
****************************************/

IF OBJECT_ID('LOSGDS.BI_Vista_Factura_Promedio_Mensual', 'V') IS NOT NULL
    DROP VIEW LOSGDS.BI_Vista_Factura_Promedio_Mensual;
GO

IF OBJECT_ID('LOSGDS._Rendimiento_Modelos', 'V') IS NOT NULL
    DROP VIEW LOSGDS._Rendimiento_Modelos;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_Volumen_Pedidos', 'V') IS NOT NULL
    DROP VIEW LOSGDS.BI_Vista_Volumen_Pedidos;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_Conversion_Pedidos', 'V') IS NOT NULL
    DROP VIEW LOSGDS.BI_Vista_Conversion_Pedidos;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_Tiempo_Promedio_Fabricacion', 'V') IS NOT NULL
    DROP VIEW LOSGDS.BI_Vista_Tiempo_Promedio_Fabricacion;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_ComprasPromedio', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_ComprasPromedio;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_ComprasTotal', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_ComprasTotal;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_Rendimiento_Modelos', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_Rendimiento_Modelos;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_CumplimientoEnvios', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_CumplimientoEnvios;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_LocalidadesMayorCostoEnvio', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_LocalidadesMayorCostoEnvio;
GO

IF OBJECT_ID('LOSGDS.BI_Vista_Ganancias', 'V') IS NOT NULL
	DROP VIEW LOSGDS.BI_Vista_Ganancias;
GO

IF OBJECT_ID('LOSGDS.BI_Hechos_Pedidos',  'U') IS NOT NULL DROP TABLE LOSGDS.BI_Hechos_Pedidos;
IF OBJECT_ID('LOSGDS.BI_Hechos_Compras',  'U') IS NOT NULL DROP TABLE LOSGDS.BI_Hechos_Compras;
IF OBJECT_ID('LOSGDS.BI_Hechos_Facturacion', 'U') IS NOT NULL DROP TABLE LOSGDS.BI_Hechos_Facturacion;
IF OBJECT_ID('LOSGDS.BI_Hechos_Envios') IS NOT NULL DROP TABLE LOSGDS.BI_Hechos_Envios;

IF OBJECT_ID('LOSGDS.BI_Dim_Turno_Ventas', 'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Turno_Ventas;
IF OBJECT_ID('LOSGDS.BI_Dim_Sucursal',    'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Sucursal;
IF OBJECT_ID('LOSGDS.BI_Dim_Estado_Pedido','U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Estado_Pedido;
IF OBJECT_ID('LOSGDS.BI_Dim_Tiempo',       'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Tiempo;
IF OBJECT_ID('LOSGDS.BI_Dim_Ubicacion',       'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Ubicacion;
IF OBJECT_ID('LOSGDS.BI_Dim_Rango_Etario_Cliente', 'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Rango_Etario_Cliente;
IF OBJECT_ID('LOSGDS.BI_Dim_Modelo_Sillon', 'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_Modelo_Sillon;
IF OBJECT_ID('LOSGDS.BI_Dim_TipoMaterial', 'U') IS NOT NULL DROP TABLE LOSGDS.BI_Dim_TipoMaterial;


GO

/****************************************
 2) CREATE TABLE Dimensiones
****************************************/

CREATE TABLE LOSGDS.BI_Dim_Tiempo (
    id_tiempo    BIGINT      IDENTITY,
    anio         INT         NOT NULL,
    mes          INT         NOT NULL,
    cuatrimestre NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_BI_Dim_Tiempo PRIMARY KEY CLUSTERED (id_tiempo)
);
GO

CREATE TABLE LOSGDS.BI_Dim_Ubicacion (
    id_ubicacion BIGINT IDENTITY,
	id_provincia BIGINT NOT NULL,
	id_localidad BIGINT NOT NULL,
	nombre_provincia NVARCHAR(255) NOT NULL,
	nombre_localidad NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_BI_Dim_Ubicacion PRIMARY KEY CLUSTERED (id_ubicacion)
);
GO

CREATE TABLE LOSGDS.BI_Dim_Rango_Etario_Cliente (
    id_rango_etario 	BIGINT IDENTITY,
    rango_etario_inicio INT,
    rango_etario_fin 	INT,
	CONSTRAINT PK_BI_Dim_Rango_Etario_Cliente PRIMARY KEY CLUSTERED (id_rango_etario)
);
GO


CREATE TABLE LOSGDS.BI_Dim_Sucursal (
    id_sucursal  BIGINT      IDENTITY,
    nro_sucursal BIGINT      NOT NULL,
    CONSTRAINT PK_BI_Dim_Sucursal PRIMARY KEY CLUSTERED (id_sucursal)
);
GO

CREATE TABLE LOSGDS.BI_Dim_Modelo_Sillon (
    id_modelo_sillon BIGINT NOT NULL,
    nombre 			 NVARCHAR(255),
    descripcion 	 NVARCHAR(255),
	CONSTRAINT PK_BI_Dim_Modelo_Sillon PRIMARY KEY CLUSTERED (id_modelo_sillon)
);
GO

CREATE TABLE LOSGDS.BI_Dim_Estado_Pedido (
    id_estado_pedido BIGINT      IDENTITY,
    estado_pedido    NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_BI_Dim_Estado_Pedido PRIMARY KEY CLUSTERED (id_estado_pedido)
);
GO

CREATE TABLE LOSGDS.BI_Dim_Turno_Ventas (
    id_turno_ventas BIGINT      IDENTITY,
    turno_ventas    NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_BI_Dim_Turno_Ventas PRIMARY KEY CLUSTERED (id_turno_ventas)
);
GO


CREATE TABLE LOSGDS.BI_Dim_TipoMaterial (
    id_material BIGINT IDENTITY PRIMARY KEY,
    tipo_material NVARCHAR(50) NOT NULL
)
GO



/****************************************
 3) CREATE TABLE Hechos
****************************************/


CREATE TABLE LOSGDS.BI_Hechos_Pedidos (
    id_tiempo                 BIGINT      NOT NULL,
    id_estado_pedido          BIGINT      NOT NULL,
    id_sucursal               BIGINT      NOT NULL,
    id_turno_ventas           BIGINT      NOT NULL,
    cantidad                  INT         NOT NULL,
    dias_promedio_facturacion DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_BI_Hechos_Pedidos PRIMARY KEY CLUSTERED (
        id_tiempo,
        id_estado_pedido,
        id_sucursal,
        id_turno_ventas
    ),
    CONSTRAINT FK_HP_Tiempo        FOREIGN KEY(id_tiempo)        REFERENCES LOSGDS.BI_Dim_Tiempo(id_tiempo),
    CONSTRAINT FK_HP_EstadoPedido FOREIGN KEY(id_estado_pedido) REFERENCES LOSGDS.BI_Dim_Estado_Pedido(id_estado_pedido),
    CONSTRAINT FK_HP_Sucursal     FOREIGN KEY(id_sucursal)      REFERENCES LOSGDS.BI_Dim_Sucursal(id_sucursal),
    CONSTRAINT FK_HP_TurnoVenta   FOREIGN KEY(id_turno_ventas)  REFERENCES LOSGDS.BI_Dim_Turno_Ventas(id_turno_ventas)
);
GO

CREATE TABLE LOSGDS.BI_Hechos_Compras (
    id_tiempo BIGINT NOT NULL,
	id_material BIGINT NOT NULL,
	id_sucursal BIGINT NOT NULL,
	importe_total DECIMAL(18,2) NOT NULL,
	cantidad_total INT NOT NULL,
	FOREIGN KEY (id_material) REFERENCES LOSGDS.BI_Dim_TipoMaterial(id_material),
    FOREIGN KEY (id_tiempo) REFERENCES LOSGDS.BI_Dim_Tiempo(id_tiempo),
	FOREIGN KEY (id_sucursal) REFERENCES LOSGDS.BI_Dim_Sucursal(id_sucursal),
	PRIMARY KEY(id_tiempo,id_material ,id_sucursal)
)
GO

CREATE TABLE LOSGDS.BI_Hechos_Facturacion (
    id_tiempo BIGINT NOT NULL,
    id_ubicacion BIGINT NOT NULL,
    id_sucursal BIGINT NOT NULL,
    id_rango_etario BIGINT NOT NULL,
    id_modelo_sillon BIGINT NOT NULL,
	cantidad_facturas INT NOT NULL,
    total DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (id_tiempo, id_ubicacion, id_sucursal, id_rango_etario, id_modelo_sillon),
    FOREIGN KEY (id_tiempo) REFERENCES LOSGDS.BI_Dim_Tiempo(id_tiempo),
    FOREIGN KEY (id_ubicacion) REFERENCES LOSGDS.BI_Dim_Ubicacion(id_ubicacion),
    FOREIGN KEY (id_sucursal) REFERENCES LOSGDS.BI_Dim_Sucursal(id_sucursal),
    FOREIGN KEY (id_rango_etario) REFERENCES LOSGDS.BI_Dim_Rango_Etario_Cliente(id_rango_etario),
    FOREIGN KEY (id_modelo_sillon) REFERENCES LOSGDS.BI_Dim_Modelo_Sillon(id_modelo_sillon)
);
GO

CREATE TABLE LOSGDS.BI_Hechos_Envios(
	id_tiempo BIGINT,
	id_ubicacion BIGINT,
	costo_envio_promedio DECIMAL(18,2),
	cumplidos_en_fecha INT,
	cantidad_envios INT,
	CONSTRAINT PK_HechosEnvios PRIMARY KEY (id_tiempo, id_ubicacion),
	CONSTRAINT FK_HechosEnvios_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOSGDS.BI_Dim_Tiempo(id_tiempo),
	CONSTRAINT FK_HechosEnvios_Ubicacion FOREIGN KEY (id_ubicacion) REFERENCES LOSGDS.BI_Dim_Ubicacion(id_ubicacion)
);
GO

/****************************************
 4) CREATE PROCEDURES (migraciones dimensiones)
****************************************/

-- 4.1 Migrar Dim_Sucursal
CREATE PROCEDURE LOSGDS.MigrarDimSucursal
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_Sucursal
    SELECT DISTINCT 
        s.nro_sucursal
	FROM LOSGDS.Sucursal s
END
GO

-- 4.2 Migrar Dim_Ubicacion
CREATE PROCEDURE LOSGDS.MigrarDimUbicacion
AS
BEGIN
    
INSERT INTO LOSGDS.BI_Dim_Ubicacion (id_provincia, id_localidad, nombre_provincia, nombre_localidad)
    SELECT DISTINCT 
        pr.id_provincia,
        l.id_localidad,
        pr.nombre,
        l.nombre
    FROM LOSGDS.Proveedor p
    JOIN LOSGDS.Direccion d ON d.id_direccion = p.proveedor_direccion
    JOIN LOSGDS.Localidad l ON l.id_localidad = d.direccion_localidad
    JOIN LOSGDS.Provincia pr ON pr.id_provincia = l.localidad_provincia

    UNION
    SELECT DISTINCT 
        pr.id_provincia,
        l.id_localidad,
        pr.nombre,
        l.nombre
    FROM LOSGDS.Sucursal s
    JOIN LOSGDS.Direccion d ON d.id_direccion = s.sucursal_direccion
    JOIN LOSGDS.Localidad l ON l.id_localidad = d.direccion_localidad
    JOIN LOSGDS.Provincia pr ON pr.id_provincia = l.localidad_provincia

    UNION
    SELECT DISTINCT 
        pr.id_provincia,
        l.id_localidad,
        pr.nombre,
        l.nombre
    FROM LOSGDS.Cliente c
    JOIN LOSGDS.Direccion d ON d.id_direccion = c.cliente_direccion
    JOIN LOSGDS.Localidad l ON l.id_localidad = d.direccion_localidad
    JOIN LOSGDS.Provincia pr ON pr.id_provincia = l.localidad_provincia

	UNION
    SELECT DISTINCT 
        prov.id_provincia,
        l.id_localidad,
        prov.nombre,
        l.nombre
    FROM  LOSGDS.Envio e
    JOIN LOSGDS.Factura f ON f.id_factura = e.envio_factura
    JOIN LOSGDS.Cliente c ON c.id_cliente = f.fact_cliente
    JOIN LOSGDS.Direccion d ON d.id_direccion = c.cliente_direccion
    JOIN LOSGDS.Localidad l ON l.id_localidad = d.direccion_localidad
    JOIN LOSGDS.Provincia prov ON prov.id_provincia = l.localidad_provincia
END
GO

-- 4.3 Migrar Dim_Rango_Etario_Cliente
DROP PROCEDURE IF EXISTS LOSGDS.CrearRangosEtarios;
GO

CREATE PROCEDURE LOSGDS.CrearRangosEtarios
AS
BEGIN
	BEGIN TRANSACTION;
		INSERT INTO LOSGDS.BI_Dim_Rango_Etario_Cliente(rango_etario_inicio,rango_etario_fin)
        VALUES
		(NULL,25),
		(25,35),
		(35,50),
		(50,null)
	COMMIT TRANSACTION;
END
GO	

-- 4.4 Migrar Dim_Tiempo
CREATE PROCEDURE LOSGDS.MigrarDimTiempo
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_Tiempo (anio, cuatrimestre, mes)
    SELECT DISTINCT 
        YEAR(f.fecha),
        CASE 
            WHEN MONTH(f.fecha) BETWEEN 1 AND 4 THEN 'Primer Cuatrimestre'
            WHEN MONTH(f.fecha) BETWEEN 5 AND 8 THEN 'Segundo Cuatrimestre'
            ELSE 'Tercer Cuatrimestre'
        END,
        MONTH(f.fecha)
    FROM LOSGDS.Factura f

    UNION

    SELECT DISTINCT 
        YEAR(c.fecha),
        CASE 
            WHEN MONTH(c.fecha) BETWEEN 1 AND 4 THEN 'Primer Cuatrimestre'
            WHEN MONTH(c.fecha) BETWEEN 5 AND 8 THEN 'Segundo Cuatrimestre'
            ELSE 'Tercer Cuatrimestre'
        END,
        MONTH(c.fecha)
    FROM LOSGDS.Compra c

    UNION

    SELECT DISTINCT 
        YEAR(p.fecha),
        CASE 
            WHEN MONTH(p.fecha) BETWEEN 1 AND 4 THEN 'Primer Cuatrimestre'
            WHEN MONTH(p.fecha) BETWEEN 5 AND 8 THEN 'Segundo Cuatrimestre'
            ELSE 'Tercer Cuatrimestre'
        END,
        MONTH(p.fecha)
    FROM LOSGDS.Pedido p

    UNION

    SELECT DISTINCT 
        YEAR(e.fecha),
        CASE 
            WHEN MONTH(e.fecha) BETWEEN 1 AND 4 THEN 'Primer Cuatrimestre'
            WHEN MONTH(e.fecha) BETWEEN 5 AND 8 THEN 'Segundo Cuatrimestre'
            ELSE 'Tercer Cuatrimestre'
        END,
        MONTH(e.fecha)
    FROM LOSGDS.Envio e
END
GO


-- 4.5 Migrar Dim_Modelo_Sillon
CREATE PROCEDURE LOSGDS.MigrarDimModeloSillon
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_Modelo_Sillon (id_modelo_sillon, nombre, descripcion)
    SELECT 
        cod_modelo,
        modelo,
        descripcion
    FROM LOSGDS.Modelo
END
GO

-- 4.6 Migrar Dim_Estado_Pedido
CREATE PROCEDURE LOSGDS.MigrarDimEstadoPedido
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_Estado_Pedido (estado_pedido)
    SELECT DISTINCT p.estado
    FROM LOSGDS.Pedido p
    WHERE p.estado IS NOT NULL;
END;
GO

-- 4.7 Migrar Dim_Turno_Ventas
CREATE PROCEDURE LOSGDS.MigrarDimTurnoVentas
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_Turno_Ventas (turno_ventas)
    SELECT DISTINCT 
        CASE 
            WHEN CAST(FORMAT(p.fecha, 'HH:mm') AS TIME) BETWEEN '08:00' AND '13:59' THEN '08:00 - 14:00'
            ELSE '14:00 - 20:00'
        END
    FROM LOSGDS.Pedido p
    WHERE p.fecha IS NOT NULL;
END;
GO


-- 4.8 Migracion BI_Dim_TipoMaterial
CREATE PROCEDURE LOSGDS.MigrarDimTipoMaterial
AS
BEGIN
    INSERT INTO LOSGDS.BI_Dim_TipoMaterial
    SELECT DISTINCT 
        m.tipo 
	FROM LOSGDS.Material m
END
GO

/****************************************
 5) CREATE PROCEDURES (migraciones hechos)
****************************************/

-- 5.1 Migrar Hechos_Facturacion
CREATE PROCEDURE LOSGDS.MigrarHechosFacturacion
AS
BEGIN
    INSERT INTO LOSGDS.BI_Hechos_Facturacion (
        id_tiempo,
        id_ubicacion,
        id_sucursal,
        id_rango_etario,
        id_modelo_sillon,
		cantidad_facturas,
        total
    )
    SELECT 
        t.id_tiempo,
        u.id_ubicacion,
        s.id_sucursal,
        r.id_rango_etario,
        mo.cod_modelo,
		COUNT(DISTINCT f.id_factura) AS cantidad_facturas,
        SUM(df.subtotal) AS total
    FROM LOSGDS.Detalle_Factura df
    JOIN LOSGDS.Factura f ON f.id_factura = df.det_fact_factura
    JOIN LOSGDS.Detalle_Pedido dp ON dp.id_det_pedido = df.det_fact_det_pedido
    JOIN LOSGDS.Pedido p ON p.id_pedido = dp.det_ped_pedido
    JOIN LOSGDS.Cliente c ON c.id_cliente = p.pedido_cliente
    JOIN LOSGDS.Sillon si ON si.cod_sillon = dp.det_ped_sillon
    JOIN LOSGDS.Modelo mo ON mo.cod_modelo = si.sillon_modelo
    JOIN LOSGDS.Sucursal s ON s.id_sucursal = f.fact_sucursal
    JOIN LOSGDS.Direccion d ON d.id_direccion = s.sucursal_direccion
    JOIN LOSGDS.Localidad l ON l.id_localidad = d.direccion_localidad
    JOIN LOSGDS.Provincia pr ON pr.id_provincia = l.localidad_provincia
    JOIN LOSGDS.BI_Dim_Ubicacion u ON u.id_localidad = l.id_localidad AND u.id_provincia = pr.id_provincia
    JOIN LOSGDS.BI_Dim_Tiempo t ON t.anio = YEAR(f.fecha) AND t.mes = MONTH(f.fecha)
    JOIN LOSGDS.BI_Dim_Rango_Etario_Cliente r 
    ON (
            (r.rango_etario_inicio IS NULL AND DATEDIFF(YEAR, c.fecha_nacimiento, f.fecha) < r.rango_etario_fin) OR
            (r.rango_etario_fin IS NULL AND DATEDIFF(YEAR, c.fecha_nacimiento, f.fecha) >= r.rango_etario_inicio) OR
            (DATEDIFF(YEAR, c.fecha_nacimiento, f.fecha) >= r.rango_etario_inicio AND 
            DATEDIFF(YEAR, c.fecha_nacimiento, f.fecha) < r.rango_etario_fin)
        )
    GROUP BY 
        t.id_tiempo,
        u.id_ubicacion,
        s.id_sucursal,
        r.id_rango_etario,
        mo.cod_modelo
END
GO

-- 5.2 Migrar Hechos_Pedidos
CREATE  PROCEDURE LOSGDS.MigrarHechosPedidos
AS
BEGIN
    INSERT INTO LOSGDS.BI_Hechos_Pedidos (
        id_tiempo,
        id_estado_pedido,
        id_sucursal,
        id_turno_ventas,
        cantidad,
        dias_promedio_facturacion
    )
    SELECT 
        dt.id_tiempo,
        dep.id_estado_pedido,
        ds.id_sucursal,
        dtv.id_turno_ventas,
        COUNT(DISTINCT p.id_pedido) AS cantidad_pedidos,
    ISNULL(AVG(DATEDIFF(DAY, p.fecha, f.fecha)), 0)

    FROM LOSGDS.Pedido p
    JOIN LOSGDS.Detalle_Pedido dp           ON dp.det_ped_pedido = p.id_pedido
    JOIN LOSGDS.Detalle_Factura df          ON df.det_fact_det_pedido = dp.id_det_pedido
    JOIN LOSGDS.Factura f                   ON f.id_factura = df.det_fact_factura

    JOIN LOSGDS.Sucursal s                  ON p.pedido_sucursal = s.id_sucursal
    JOIN LOSGDS.BI_Dim_Sucursal ds          ON ds.nro_sucursal = s.nro_sucursal
    JOIN LOSGDS.BI_Dim_Estado_Pedido dep    ON dep.estado_pedido = p.estado
    JOIN LOSGDS.BI_Dim_Tiempo dt            ON dt.anio = YEAR(p.fecha) AND dt.mes = MONTH(p.fecha)
    JOIN LOSGDS.BI_Dim_Turno_Ventas dtv     ON dtv.turno_ventas = 
        CASE 
            WHEN CAST(FORMAT(p.fecha, 'HH:mm') AS TIME) BETWEEN '08:00' AND '13:59'
                THEN '08:00 - 14:00'
            ELSE '14:00 - 20:00'
        END
	WHERE p.fecha IS NOT NULL
    GROUP BY 
        dt.id_tiempo,
        dep.id_estado_pedido,
        ds.id_sucursal,
        dtv.id_turno_ventas;
END;
GO
-- 5.3 Migrar Hechos_Envios
CREATE PROCEDURE LOSGDS.MigrarHechosEnvios
AS
BEGIN

    INSERT INTO LOSGDS.BI_Hechos_Envios (id_tiempo,id_ubicacion,costo_envio_promedio,cumplidos_en_fecha,cantidad_envios)
    SELECT  
	dt.id_tiempo, 
	du.id_ubicacion,
	AVG(e.total),
	SUM( CASE 
			WHEN e.fecha_programada = e.fecha THEN 1
			ELSE 0
		 END
	),
	COUNT(*) AS cantidad_envios
    FROM  LOSGDS.Envio e
	INNER JOIN LOSGDS.BI_Dim_Tiempo dt
	ON dt.anio = YEAR(e.fecha)
	AND dt.mes = MONTH(e.fecha)
	AND dt.cuatrimestre = 
		CASE 
            WHEN MONTH(e.fecha) BETWEEN 1 AND 4 THEN 'Primer Cuatrimestre'
            WHEN MONTH(e.fecha) BETWEEN 5 AND 8 THEN 'Segundo Cuatrimestre'
			else 'Tercer Cuatrimestre'
        END


	INNER JOIN LOSGDS.Factura f
	ON f.id_factura = e.envio_factura
	INNER JOIN LOSGDS.Cliente c
	ON c.id_cliente = f.fact_cliente
	INNER JOIN LOSGDS.Direccion d
	ON d.id_direccion = c.cliente_direccion
	INNER JOIN LOSGDS.Localidad l
	ON l.id_localidad = d.direccion_localidad
	INNER JOIN LOSGDS.Provincia prov
	ON prov.id_provincia = l.localidad_provincia
	INNER JOIN LOSGDS.BI_Dim_Ubicacion du
	ON du.id_localidad = l.id_localidad
	AND du.id_provincia = prov.id_provincia
	GROUP BY
	dt.id_tiempo, du.id_ubicacion
	ORDER BY cantidad_envios
END
GO


-- 5.4 Migrar hechos compras

CREATE PROCEDURE LOSGDS.MigrarHechosCompras
AS
BEGIN
    INSERT INTO LOSGDS.BI_Hechos_Compras
		SELECT
			t.id_tiempo,
			tm.id_material,
			id_sucursal,
			SUM(c.total) AS importe_total,
			COUNT(*) AS cantidad
		FROM LOSGDS.Compra c
		JOIN LOSGDS.BI_Dim_Tiempo t ON YEAR(c.fecha) = t.anio AND MONTH(c.fecha) = mes
		JOIN LOSGDS.Detalle_Compra dc ON c.id_compra = dc.det_compra_compra
		JOIN LOSGDS.Material m ON m.id_material = dc.detalle_material
		JOIN LOSGDS.BI_Dim_TipoMaterial tm ON tm.tipo_material = m.tipo
		JOIN LOSGDS.BI_Dim_Sucursal s ON s.id_sucursal = c.compra_sucursal
		GROUP BY t.id_tiempo, tm.id_material, id_sucursal
END
GO





/****************************************
 6) EJECUCIÓN de migraciones
****************************************/

BEGIN TRANSACTION
	EXEC LOSGDS.MigrarDimTiempo;
	EXEC LOSGDS.MigrarDimUbicacion;
	EXEC LOSGDS.MigrarDimSucursal;
	EXEC LOSGDS.MigrarDimEstadoPedido;
  EXEC LOSGDS.MigrarDimTurnoVentas;
	EXEC LOSGDS.CrearRangosEtarios;
	EXEC LOSGDS.MigrarDimModeloSillon;
	EXEC LOSGDS.MigrarDimTipoMaterial;

	EXEC LOSGDS.MigrarHechosCompras;
	EXEC LOSGDS.MigrarHechosFacturacion;
  EXEC LOSGDS.MigrarHechosPedidos;
	EXEC LOSGDS.MigrarHechosEnvios;
COMMIT TRANSACTION
GO

/****************************************
 7) CREATE VIEWS (indicadores)
****************************************/

-- 1. Ganancias (Por mes por sucursal) [Total de ingresos (facturación) - total de egresos (compras)]
CREATE VIEW LOSGDS.BI_Vista_Ganancias AS
SELECT 
    COALESCE(f.mes, c.mes) AS mes,
    COALESCE(f.id_sucursal, c.id_sucursal) AS id_sucursal,
    COALESCE(f.total_factura, 0) - COALESCE(c.total_compra, 0) AS ganancia_mensual
FROM (
    SELECT
        t.mes,
        f.id_sucursal,
        SUM(f.total) AS total_factura
    FROM LOSGDS.BI_Hechos_Facturacion f
    JOIN LOSGDS.BI_Dim_Tiempo t ON f.id_tiempo = t.id_tiempo
    GROUP BY t.mes, f.id_sucursal
) f
FULL OUTER JOIN (
    SELECT
        t.mes,
        c.id_sucursal,
        SUM(c.importe_total) AS total_compra
    FROM LOSGDS.BI_Hechos_Compras c
    JOIN LOSGDS.BI_Dim_Tiempo t ON c.id_tiempo = t.id_tiempo
    GROUP BY t.mes, c.id_sucursal
) c
ON f.mes = c.mes AND f.id_sucursal = c.id_sucursal
GO

-- 2. Factura Promedio Mensual (Toma los datos de un cuatrimestre)
CREATE VIEW LOSGDS.BI_Vista_Factura_Promedio_Mensual AS
    SELECT 
    t.anio,
    t.cuatrimestre,
    u.nombre_provincia,
    SUM(hf.total) AS total_facturado,
    SUM(hf.cantidad_facturas) AS total_facturas,
    SUM(hf.total) / 4.0 AS promedio_mensual
    FROM LOSGDS.BI_Hechos_Facturacion hf
    JOIN LOSGDS.BI_Dim_Tiempo t ON t.id_tiempo = hf.id_tiempo
    JOIN LOSGDS.BI_Dim_Ubicacion u ON u.id_ubicacion = hf.id_ubicacion
    GROUP BY t.anio, t.cuatrimestre, u.nombre_provincia;
GO

-- 3. Rendimiento de Modelos 
CREATE VIEW LOSGDS.BI_Vista_Rendimiento_Modelos AS
    WITH Top3Modelos AS (
        SELECT 
            t.anio,
            t.cuatrimestre,
            u.nombre_localidad,
            r.id_rango_etario,
            r.rango_etario_inicio,
            r.rango_etario_fin,
            m.nombre AS modelo_nombre,
            SUM(hf.total) AS total_facturado,
            ROW_NUMBER() OVER (
                PARTITION BY t.anio, t.cuatrimestre, u.nombre_localidad, r.id_rango_etario
                ORDER BY SUM(hf.total) DESC
            ) AS posicion
        FROM LOSGDS.BI_Hechos_Facturacion hf
        JOIN LOSGDS.BI_Dim_Tiempo t ON t.id_tiempo = hf.id_tiempo
        JOIN LOSGDS.BI_Dim_Ubicacion u ON u.id_ubicacion = hf.id_ubicacion
        JOIN LOSGDS.BI_Dim_Rango_Etario_Cliente r ON r.id_rango_etario = hf.id_rango_etario
        JOIN LOSGDS.BI_Dim_Modelo_Sillon m ON m.id_modelo_sillon = hf.id_modelo_sillon
        GROUP BY 
            t.anio, t.cuatrimestre, u.nombre_localidad,
            r.id_rango_etario, r.rango_etario_inicio, r.rango_etario_fin,
            m.nombre
        )
    SELECT * FROM Top3Modelos WHERE posicion <= 3;
GO

-- 4. Volumen de pedidos
CREATE VIEW LOSGDS.BI_Vista_Volumen_Pedidos AS
SELECT
    t.anio,
    t.mes,
    s.nro_sucursal,
    v.turno_ventas,
    SUM(h.cantidad) AS volumen_pedidos
FROM LOSGDS.BI_Hechos_Pedidos h
JOIN LOSGDS.BI_Dim_Tiempo t         ON h.id_tiempo     = t.id_tiempo
JOIN LOSGDS.BI_Dim_Sucursal s       ON h.id_sucursal   = s.id_sucursal
JOIN LOSGDS.BI_Dim_Turno_Ventas v   ON h.id_turno_ventas = v.id_turno_ventas
GROUP BY t.anio, t.mes, s.nro_sucursal, v.turno_ventas;
GO

-- 5. Conversión de pedidos
CREATE VIEW LOSGDS.BI_Vista_Conversion_Pedidos AS
SELECT 
    t.anio,
    t.cuatrimestre,
    s.nro_sucursal,
    e.estado_pedido,
    SUM(h.cantidad) AS cantidad_pedidos,
    CAST(
        SUM(h.cantidad) * 100.0 /
        NULLIF((
            SELECT SUM(h2.cantidad)
            FROM LOSGDS.BI_Hechos_Pedidos h2
            JOIN LOSGDS.BI_Dim_Tiempo t2 ON h2.id_tiempo = t2.id_tiempo
            WHERE t2.anio = t.anio
              AND t2.cuatrimestre = t.cuatrimestre
              AND h2.id_sucursal = s.id_sucursal
        ), 0)
    AS DECIMAL(5,2)) AS porcentaje
FROM LOSGDS.BI_Hechos_Pedidos h
JOIN LOSGDS.BI_Dim_Tiempo         t ON h.id_tiempo = t.id_tiempo
JOIN LOSGDS.BI_Dim_Sucursal       s ON h.id_sucursal = s.id_sucursal
JOIN LOSGDS.BI_Dim_Estado_Pedido  e ON h.id_estado_pedido = e.id_estado_pedido
GROUP BY t.anio, t.cuatrimestre, s.nro_sucursal, s.id_sucursal, e.estado_pedido;
GO

-- 6. Tiempo promedio fabricación
CREATE VIEW LOSGDS.BI_Vista_Tiempo_Promedio_Fabricacion AS
SELECT 
    t.anio,
    t.cuatrimestre,
    s.nro_sucursal,
    ISNULL(AVG(CASE 
                  WHEN h.dias_promedio_facturacion >= 0 
                  THEN h.dias_promedio_facturacion 
                  ELSE NULL 
              END), 0) AS promedio_dias
FROM LOSGDS.BI_Hechos_Pedidos h
JOIN LOSGDS.BI_Dim_Tiempo    t ON h.id_tiempo   = t.id_tiempo
JOIN LOSGDS.BI_Dim_Sucursal  s ON h.id_sucursal = s.id_sucursal
GROUP BY t.anio, t.cuatrimestre, s.nro_sucursal;
GO


-- 7 Promedio de Compras: importe promedio de compras por mes.

CREATE VIEW LOSGDS.BI_Vista_ComprasPromedio AS
	SELECT 
		t.mes AS mes,
		t.anio AS anio,
		CONVERT(decimal(18,2), SUM(c.importe_total) / SUM(c.cantidad_total)) AS importe_promedio
	FROM LOSGDS.BI_Hechos_Compras c
	JOIN LOSGDS.BI_Dim_Tiempo t ON t.id_tiempo = c.id_tiempo 
	GROUP BY t.mes, t.anio
GO


/* 8 Compras por Tipo de Material. Importe total gastado por tipo de material,
sucursal y cuatrimestre. */


CREATE VIEW LOSGDS.BI_Vista_ComprasTotal AS
	SELECT 
		t.cuatrimestre AS cuatrimestre,
		t.anio AS anio,
		tm.tipo_material AS tipoMaterial,
		s.nro_sucursal AS nroSucursal,
		SUM(c.importe_total) AS importeTotal
	FROM LOSGDS.BI_Hechos_Compras c
	JOIN LOSGDS.BI_Dim_Tiempo t ON t.id_tiempo = c.id_tiempo
	JOIN LOSGDS.BI_Dim_TipoMaterial tm ON c.id_material = tm.id_material
	JOIN LOSGDS.BI_Dim_Sucursal s ON s.id_sucursal = c.id_sucursal
	GROUP BY t.cuatrimestre, t.anio, tm.tipo_material, s.nro_sucursal
GO


-- 9. Porcentaje de cumplimiento de envíos 
CREATE VIEW LOSGDS.BI_Vista_CumplimientoEnvios AS
	SELECT
		dt.mes AS mes,
		SUM(cumplidos_en_fecha)*100/SUM(cantidad_envios)  AS porcentaje_cumplimiento
	FROM LOSGDS.BI_Hechos_Envios he
	INNER JOIN LOSGDS.BI_Dim_Tiempo dt
	ON dt.id_tiempo = he.id_tiempo
	GROUP BY dt.mes 
GO

-- 10. Localidades que pagan mayor costo de envío
CREATE VIEW LOSGDS.BI_Vista_LocalidadesMayorCostoEnvio AS
	SELECT TOP 3
		du.nombre_localidad AS localidad,
		AVG(he.costo_envio_promedio) AS promedio_costo_envio
	FROM LOSGDS.BI_Hechos_Envios he
	INNER JOIN LOSGDS.BI_Dim_Ubicacion du
		ON du.id_ubicacion = he.id_ubicacion
	GROUP BY du.nombre_localidad
	ORDER BY AVG(he.costo_envio_promedio) DESC
GO


/****************************************
 8) DROP PROCEDURES (limpieza final)
****************************************/


DROP PROCEDURE LOSGDS.MigrarDimTiempo;
DROP PROCEDURE LOSGDS.MigrarDimUbicacion;
DROP PROCEDURE LOSGDS.MigrarDimSucursal;
DROP PROCEDURE LOSGDS.CrearRangosEtarios;
DROP PROCEDURE LOSGDS.MigrarDimModeloSillon;
DROP PROCEDURE LOSGDS.MigrarDimEstadoPedido;
DROP PROCEDURE LOSGDS.MigrarDimTurnoVentas;
DROP PROCEDURE LOSGDS.MigrarDimTipoMaterial;

DROP PROCEDURE LOSGDS.MigrarHechosCompras;
DROP PROCEDURE LOSGDS.MigrarHechosFacturacion;
DROP PROCEDURE LOSGDS.MigrarHechosPedidos;
DROP PROCEDURE LOSGDS.MigrarHechosEnvios;
GO
