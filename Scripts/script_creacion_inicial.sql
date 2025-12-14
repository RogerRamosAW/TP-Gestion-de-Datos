USE GD1C2025
GO

---CREACION DE SCHEMA---
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'LOSGDS')
BEGIN
    EXEC('CREATE SCHEMA LOSGDS')
END
GO

---DROP DE TABLAS---
IF OBJECT_ID('LOSGDS.SillonXMaterial', 'U') IS NOT NULL DROP TABLE LOSGDS.SillonXMaterial;
IF OBJECT_ID('LOSGDS.Detalle_Factura', 'U') IS NOT NULL DROP TABLE LOSGDS.Detalle_Factura;
IF OBJECT_ID('LOSGDS.Envio', 'U') IS NOT NULL DROP TABLE LOSGDS.Envio;
IF OBJECT_ID('LOSGDS.Cancelacion_Pedido', 'U') IS NOT NULL DROP TABLE LOSGDS.Cancelacion_Pedido;
IF OBJECT_ID('LOSGDS.Detalle_Pedido', 'U') IS NOT NULL DROP TABLE LOSGDS.Detalle_Pedido;
IF OBJECT_ID('LOSGDS.Factura', 'U') IS NOT NULL DROP TABLE LOSGDS.Factura;
IF OBJECT_ID('LOSGDS.Pedido', 'U') IS NOT NULL DROP TABLE LOSGDS.Pedido;
IF OBJECT_ID('LOSGDS.Detalle_Compra', 'U') IS NOT NULL DROP TABLE LOSGDS.Detalle_Compra;
IF OBJECT_ID('LOSGDS.Compra', 'U') IS NOT NULL DROP TABLE LOSGDS.Compra;
IF OBJECT_ID('LOSGDS.Cliente', 'U') IS NOT NULL DROP TABLE LOSGDS.Cliente;
IF OBJECT_ID('LOSGDS.Sillon', 'U') IS NOT NULL DROP TABLE LOSGDS.Sillon;
IF OBJECT_ID('LOSGDS.Tela', 'U') IS NOT NULL DROP TABLE LOSGDS.Tela;
IF OBJECT_ID('LOSGDS.Relleno_Sillon', 'U') IS NOT NULL DROP TABLE LOSGDS.Relleno_Sillon;
IF OBJECT_ID('LOSGDS.Madera', 'U') IS NOT NULL DROP TABLE LOSGDS.Madera;
IF OBJECT_ID('LOSGDS.Material', 'U') IS NOT NULL DROP TABLE LOSGDS.Material;
IF OBJECT_ID('LOSGDS.Sucursal', 'U') IS NOT NULL DROP TABLE LOSGDS.Sucursal;
IF OBJECT_ID('LOSGDS.Proveedor', 'U') IS NOT NULL DROP TABLE LOSGDS.Proveedor;
IF OBJECT_ID('LOSGDS.Direccion', 'U') IS NOT NULL DROP TABLE LOSGDS.Direccion;
IF OBJECT_ID('LOSGDS.Localidad', 'U') IS NOT NULL DROP TABLE LOSGDS.Localidad;
IF OBJECT_ID('LOSGDS.Medida', 'U') IS NOT NULL DROP TABLE LOSGDS.Medida;
IF OBJECT_ID('LOSGDS.Modelo', 'U') IS NOT NULL DROP TABLE LOSGDS.Modelo;
IF OBJECT_ID('LOSGDS.Provincia', 'U') IS NOT NULL DROP TABLE LOSGDS.Provincia;


CREATE TABLE LOSGDS.Provincia (
    id_provincia BIGINT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255)
)
GO

CREATE TABLE LOSGDS.Localidad (
    id_localidad BIGINT IDENTITY(1,1) PRIMARY KEY,
    localidad_provincia BIGINT NOT NULL,
    nombre NVARCHAR(255),
    CONSTRAINT fk_localidad_provincia FOREIGN KEY(localidad_provincia)
        REFERENCES LOSGDS.Provincia(id_provincia)
)
GO

CREATE TABLE LOSGDS.Direccion (
    id_direccion BIGINT IDENTITY(1,1) PRIMARY KEY,
    direccion_localidad BIGINT NOT NULL,
    nombre NVARCHAR(255),
    CONSTRAINT fk_direccion_localidad FOREIGN KEY(direccion_localidad) 
        REFERENCES LOSGDS.Localidad(id_localidad)
)
GO

CREATE TABLE LOSGDS.Proveedor (
    id_proveedor BIGINT IDENTITY(1,1) PRIMARY KEY,
    proveedor_direccion BIGINT NOT NULL,
    razon_social NVARCHAR(255),
    cuit NVARCHAR(255),
    telefono NVARCHAR(255),
    mail NVARCHAR(255),
    CONSTRAINT fk_proveedor_direccion FOREIGN KEY(proveedor_direccion) 
        REFERENCES LOSGDS.Direccion(id_direccion)
)
GO

CREATE TABLE LOSGDS.Sucursal (
    id_sucursal BIGINT IDENTITY(1,1) PRIMARY KEY,
    nro_sucursal BIGINT NOT NULL,
	sucursal_direccion BIGINT NOT NULL,
    mail NVARCHAR(255),
    telefono NVARCHAR(255),
    CONSTRAINT fk_sucursal_direccion FOREIGN KEY (sucursal_direccion) 
        REFERENCES LOSGDS.Direccion(id_direccion)
)
GO

CREATE TABLE LOSGDS.Compra (
    id_compra BIGINT IDENTITY(1,1) PRIMARY KEY,
    numero_compra DECIMAL(18,0) NOT NULL,
    compra_sucursal BIGINT NOT NULL,
    compra_proveedor BIGINT NOT NULL,
    fecha DATETIME2(6),
    total DECIMAL(18,2),
    CONSTRAINT fk_compra_sucursal FOREIGN KEY (compra_sucursal) REFERENCES LOSGDS.Sucursal(id_sucursal),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (compra_proveedor) REFERENCES LOSGDS.Proveedor(id_proveedor)
)
GO

CREATE TABLE LOSGDS.Material (
    id_material  BIGINT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(255),
    material_nombre NVARCHAR(255),
    precio DECIMAL(38,2),
    tipo NVARCHAR(255)
)
GO

CREATE TABLE LOSGDS.Detalle_Compra (
    id_det_compra BIGINT IDENTITY(1,1) PRIMARY KEY,
    det_compra_compra BIGINT NOT NULL,
    detalle_material BIGINT NOT NULL,
    precio DECIMAL(18,2),
    cantidad DECIMAL(18,2),
    subtotal DECIMAL(18,2),
    CONSTRAINT fk_det_compra_compra FOREIGN KEY (det_compra_compra) REFERENCES LOSGDS.Compra(id_compra),
    CONSTRAINT fk_detalle_material FOREIGN KEY (detalle_material) REFERENCES LOSGDS.Material(id_material)
)
GO

CREATE TABLE LOSGDS.Modelo (
	cod_modelo BIGINT PRIMARY KEY,
    modelo NVARCHAR(255),
    descripcion NVARCHAR(255),
    precio DECIMAL(18,2)
)
GO

CREATE TABLE LOSGDS.Medida (
    cod_medida BIGINT IDENTITY(1,1) PRIMARY KEY,
    alto DECIMAL(18,2),
    ancho DECIMAL(18,2),
    profundidad DECIMAL(18,2),
    precio DECIMAL(18,2)
)
GO

CREATE TABLE LOSGDS.Sillon (
    cod_sillon BIGINT PRIMARY KEY,
    sillon_modelo BIGINT NOT NULL,
    sillon_medida BIGINT NOT NULL,
    CONSTRAINT fk_sillon_modelo FOREIGN KEY (sillon_modelo) 
        REFERENCES LOSGDS.Modelo (cod_modelo),
    CONSTRAINT fk_sillon_medida FOREIGN KEY (sillon_medida) 
        REFERENCES LOSGDS.Medida (cod_medida)
);
GO

CREATE TABLE LOSGDS.Cliente (
    id_cliente BIGINT IDENTITY(1,1) PRIMARY KEY,
    cliente_direccion BIGINT NOT NULL,
    dni BIGINT NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    apellido NVARCHAR(255) NOT NULL,
    fecha_nacimiento DATETIME2(6) NOT NULL,
    mail NVARCHAR(255),
    telefono NVARCHAR(255),
    CONSTRAINT fk_cliente_direccion FOREIGN KEY (cliente_direccion)
        REFERENCES LOSGDS.Direccion(id_direccion)
)
GO

CREATE TABLE LOSGDS.Pedido (
    id_pedido BIGINT IDENTITY(1,1) PRIMARY KEY,
    nro_pedido DECIMAL(18,0),
    pedido_sucursal BIGINT NOT NULL,
    pedido_cliente BIGINT NOT NULL,
    fecha DATETIME2(6),
    total DECIMAL(18,2),
    estado NVARCHAR(255),
    CONSTRAINT fk_pedido_sucursal FOREIGN KEY (pedido_sucursal)
        REFERENCES LOSGDS.Sucursal(id_sucursal),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (pedido_cliente)
        REFERENCES LOSGDS.Cliente(id_cliente)
)
GO

CREATE TABLE LOSGDS.Detalle_Pedido (
    id_det_pedido BIGINT IDENTITY(1,1) PRIMARY KEY,
    det_ped_sillon BIGINT NOT NULL,
    det_ped_pedido BIGINT NOT NULL,
    cantidad BIGINT,
    precio DECIMAL(18,2),
    subtotal DECIMAL(18,2),
    CONSTRAINT fk_det_ped_sillon FOREIGN KEY (det_ped_sillon) REFERENCES LOSGDS.Sillon(cod_sillon),
    CONSTRAINT fk_det_ped_pedido FOREIGN KEY (det_ped_pedido) REFERENCES LOSGDS.Pedido(id_pedido)
)
GO

CREATE TABLE LOSGDS.Cancelacion_Pedido (
    id_cancel_pedido BIGINT IDENTITY(1,1) PRIMARY KEY,
    cancel_ped_pedido BIGINT NOT NULL,
    fecha DATETIME2(6),
    motivo NVARCHAR(255),
    CONSTRAINT fk_cancel_ped_pedido FOREIGN KEY (cancel_ped_pedido) REFERENCES LOSGDS.Pedido(id_pedido)
)
GO

CREATE TABLE LOSGDS.Factura (
    id_factura BIGINT IDENTITY(1,1) PRIMARY KEY,
    fact_cliente BIGINT NOT NULL,
    fact_sucursal BIGINT NOT NULL,
    fact_numero BIGINT NOT NULL,
    fecha DATETIME2(6),
    total DECIMAL(38,2),
    CONSTRAINT fk_fact_cliente FOREIGN KEY (fact_cliente)
        REFERENCES LOSGDS.Cliente(id_cliente),
    CONSTRAINT fk_fact_sucursal FOREIGN KEY (fact_sucursal)
        REFERENCES LOSGDS.Sucursal(id_sucursal)
)
GO

CREATE TABLE LOSGDS.Envio (
    envio_nro BIGINT IDENTITY(1,1) PRIMARY KEY,
    numero DECIMAL(18,0),
    envio_factura BIGINT NOT NULL,
    fecha_programada DATETIME2(6),
    fecha DATETIME2(6),
    importe_traslado DECIMAL(18,2),
    importe_subida DECIMAL(18,2),
    total DECIMAL(18,2),
    CONSTRAINT fk_envio_factura FOREIGN KEY (envio_factura)
        REFERENCES LOSGDS.Factura(id_factura)
)
GO

CREATE TABLE LOSGDS.Detalle_Factura (
    id_det_fact BIGINT IDENTITY(1,1) PRIMARY KEY,
    det_fact_factura BIGINT NOT NULL,
    det_fact_det_pedido BIGINT NOT NULL,
    precio DECIMAL(18,2),
    cantidad DECIMAL(18,0),
    subtotal DECIMAL(18,2),
    CONSTRAINT fk_det_fact_factura FOREIGN KEY (det_fact_factura)
        REFERENCES LOSGDS.Factura(id_factura),
    CONSTRAINT fk_det_fact_det_pedido FOREIGN KEY (det_fact_det_pedido)
        REFERENCES LOSGDS.Detalle_Pedido(id_det_pedido)
)
GO

CREATE TABLE LOSGDS.SillonXMaterial (
    cod_sillon BIGINT,
    id_material BIGINT,
    PRIMARY KEY (cod_sillon, id_material),
    CONSTRAINT fk_cod_sillon FOREIGN KEY (cod_sillon) 
        REFERENCES LOSGDS.Sillon (cod_sillon),
    CONSTRAINT fk_id_material FOREIGN KEY (id_material) 
        REFERENCES LOSGDS.Material (id_material)
)
GO

CREATE TABLE LOSGDS.Tela (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    color NVARCHAR(255),
    textura NVARCHAR(255),
    tela_material BIGINT NOT NULL,
    CONSTRAINT fk_tela_material FOREIGN KEY (tela_material) 
        REFERENCES LOSGDS.Material (id_material)
)
GO

CREATE TABLE LOSGDS.Relleno_Sillon (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    densidad DECIMAL(38,2),
    relleno_material BIGINT NOT NULL,
    CONSTRAINT fk_relleno_material FOREIGN KEY (relleno_material) 
        REFERENCES LOSGDS.Material (id_material)
)
GO


CREATE TABLE LOSGDS.Madera (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    color NVARCHAR(255),
    dureza NVARCHAR(255),
    madera_material BIGINT NOT NULL,
    CONSTRAINT fk_madera_material FOREIGN KEY (madera_material) 
        REFERENCES LOSGDS.Material (id_material)
)
GO



CREATE PROCEDURE LOSGDS.MigrarProvincias AS
BEGIN
	INSERT INTO LOSGDS.Provincia
	SELECT DISTINCT Sucursal_Provincia AS Provincia 
	FROM gd_esquema.Maestra WHERE Sucursal_Provincia IS NOT NULL
	UNION
	SELECT DISTINCT Cliente_Provincia AS Provincia 
	FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
	UNION
	SELECT DISTINCT Proveedor_Provincia AS Provincia 
	FROM gd_esquema.Maestra WHERE Proveedor_Provincia IS NOT NULL
	ORDER BY Provincia
END
GO

CREATE PROCEDURE LOSGDS.MigrarLocalidades AS
BEGIN
	INSERT INTO LOSGDS.Localidad
	SELECT DISTINCT 
	p.id_provincia AS Provincia,
	Cliente_Localidad AS Localidad 
	FROM gd_esquema.Maestra 
	left JOIN LOSGDS.Provincia p ON Cliente_Provincia = p.nombre 
	left join LOSGDS.Localidad l ON Cliente_Localidad = l.nombre
	WHERE Cliente_Provincia IS NOT NULL AND Cliente_Localidad IS NOT NULL
	UNION
	SELECT DISTINCT 
	p.id_provincia AS Provincia,
	Proveedor_Localidad AS Localidad 
	FROM gd_esquema.Maestra 
	left JOIN LOSGDS.Provincia p ON Proveedor_Provincia = p.nombre
	left join LOSGDS.Localidad l ON Proveedor_Localidad = l.nombre
	WHERE Proveedor_Localidad IS NOT NULL AND Proveedor_Provincia IS NOT NULL
	UNION
	SELECT DISTINCT 
	p.id_provincia AS Provincia,
	Sucursal_Localidad AS Localidad	
	FROM gd_esquema.Maestra 
	left JOIN LOSGDS.Provincia p ON Sucursal_Provincia = p.nombre 
	left join LOSGDS.Localidad l ON Sucursal_Localidad = l.nombre
	WHERE Sucursal_Localidad IS NOT NULL AND Sucursal_Provincia IS NOT NULL
	ORDER BY Provincia,Localidad
END
GO

CREATE PROCEDURE LOSGDS.MigrarDirecciones AS
BEGIN
		INSERT INTO LOSGDS.Direccion
		SELECT DISTINCT 
			l.id_localidad AS Localidad,
			Sucursal_Direccion AS Direccion
			FROM gd_esquema.Maestra
			left JOIN LOSGDS.Provincia p ON Sucursal_Provincia = p.nombre
			left JOIN LOSGDS.Localidad l ON Sucursal_Localidad = l.nombre and l.localidad_provincia = p.id_provincia
			WHERE 
			Sucursal_Direccion IS NOT NULL 
			AND Sucursal_Provincia IS NOT NULL 
			AND Sucursal_Localidad IS NOT NULL
		UNION
		SELECT DISTINCT 
			l.id_localidad AS Localidad,
			Cliente_Direccion AS Direccion
			FROM [gd_esquema].[Maestra]
			left JOIN LOSGDS.Provincia p ON Cliente_Provincia = p.nombre
			left JOIN LOSGDS.Localidad l ON Cliente_Localidad = l.nombre and l.localidad_provincia = p.id_provincia
			WHERE Cliente_Direccion IS NOT NULL 
			AND Sucursal_Provincia IS NOT NULL 
			AND Sucursal_Localidad IS NOT NULL
		UNION 
		SELECT DISTINCT 
			l.id_localidad AS Localidad,
			Proveedor_Direccion AS Direccion
			FROM [gd_esquema].[Maestra]
			left JOIN LOSGDS.Provincia p ON p.nombre = Proveedor_Provincia
			left JOIN LOSGDS.Localidad l ON l.nombre = Proveedor_Localidad and l.localidad_provincia = p.id_provincia
			WHERE Proveedor_Direccion IS NOT NULL 
			AND Sucursal_Provincia IS NOT NULL 
			AND Sucursal_Localidad IS NOT NULL
			ORDER BY Localidad,Direccion
END
GO 

CREATE PROCEDURE LOSGDS.MigrarProveedor AS
BEGIN
	INSERT INTO LOSGDS.Proveedor
	SELECT DISTINCT
		d.id_direccion,
		m.Proveedor_RazonSocial,
		m.Proveedor_Cuit,
		m.Proveedor_Telefono,
		m.Proveedor_Mail
	FROM gd_esquema.Maestra m
	LEFT JOIN LOSGDS.Provincia p ON Proveedor_Provincia = p.nombre 
	LEFT JOIN LOSGDS.Localidad l ON Proveedor_Localidad = l.nombre AND l.localidad_provincia = p.id_provincia
	LEFT JOIN LOSGDS.Direccion d ON Proveedor_Direccion = d.nombre
	WHERE m.Proveedor_RazonSocial IS NOT NULL
	AND m.Proveedor_Cuit IS NOT NULL
	AND NOT(Proveedor_Provincia IS NULL 
			AND Proveedor_Localidad IS NULL 
			AND id_direccion IS NULL)
	ORDER BY id_direccion 
END
GO

CREATE PROCEDURE LOSGDS.migrar_Compra AS
BEGIN
    INSERT INTO LOSGDS.Compra 
        (numero_compra, compra_sucursal, compra_proveedor, fecha, total)
    SELECT DISTINCT
        m.Compra_Numero,
        s.id_sucursal,
        p.id_proveedor,
        m.Compra_Fecha,
        CASE 
            WHEN m.Compra_Total < 0 THEN NULL 
            ELSE m.Compra_Total 
        END AS Total
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Sucursal s ON s.mail = m.Sucursal_mail
	AND s.telefono = m.Sucursal_telefono and s.nro_sucursal = Sucursal_NroSucursal
    LEFT JOIN LOSGDS.Proveedor p ON p.cuit = m.Proveedor_Cuit 
	AND Proveedor_RazonSocial = p.razon_social
	WHERE m.Sucursal_mail IS NOT NULL AND m.Sucursal_telefono IS NOT NULL
	AND Sucursal_NroSucursal IS NOT NULL AND M.Compra_Fecha IS NOT NULL 
	AND m.Compra_Total IS NOT NULL;
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Detalle_Compra AS
BEGIN
    INSERT INTO LOSGDS.Detalle_Compra 
        (det_compra_compra, detalle_material, precio, cantidad, subtotal)
    SELECT DISTINCT
        c.id_compra,
        mat.id_material,
        m.Detalle_Compra_Precio,
        m.Detalle_Compra_Cantidad,
        m.Detalle_Compra_SubTotal
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Compra c ON c.numero_compra = m.Compra_Numero
	AND m.Compra_Fecha = c.fecha AND m.Compra_Total = c.total
    LEFT JOIN LOSGDS.Material mat ON m.Material_Descripcion = mat.descripcion
	AND mat.material_nombre = m.Material_Nombre 
	AND mat.tipo = m.Material_Tipo
	WHERE m.Compra_Numero IS NOT NULL AND m.Material_Nombre IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Material AS
BEGIN
    INSERT INTO LOSGDS.Material (descripcion, material_nombre, precio, tipo)
    SELECT DISTINCT
        Material_Descripcion, 
        Material_Nombre,
        Material_Precio,
        Material_Tipo
    FROM gd_esquema.Maestra
    WHERE Material_Descripcion IS NOT NULL AND
	Material_Nombre IS NOT NULL AND
	Material_Precio IS NOT NULL AND
	Material_Tipo IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Tela AS
BEGIN
    INSERT INTO LOSGDS.Tela (color, textura, tela_material)
    SELECT DISTINCT 
        m.Tela_Color,
        m.Tela_Textura,
        mat.id_material
    FROM GD1C2025.gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Material mat
        ON mat.tipo = m.Material_Tipo
        AND mat.material_nombre = m.Material_Nombre
        AND mat.descripcion = m.Material_Descripcion
        AND mat.precio = m.Material_Precio
    WHERE m.Material_Tipo = 'Tela';
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Madera AS
BEGIN
    INSERT INTO LOSGDS.Madera (color, dureza, madera_material)
    SELECT DISTINCT 
        m.Madera_Color,
        m.Madera_Dureza,
        mat.id_material
    FROM GD1C2025.gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Material mat ON mat.tipo = m.Material_Tipo
        AND mat.material_nombre = m.Material_Nombre
        AND mat.descripcion = m.Material_Descripcion
        AND mat.precio = m.Material_Precio
	WHERE m.Madera_Color IS NOT NULL 
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Relleno_Sillon AS
BEGIN
    INSERT INTO LOSGDS.Relleno_Sillon (densidad, relleno_material)
    SELECT DISTINCT 
        m.Relleno_Densidad,
        mat.id_material
    FROM GD1C2025.gd_esquema.Maestra m
    left JOIN LOSGDS.Material mat
        ON mat.tipo = m.Material_Tipo
        AND mat.material_nombre = m.Material_Nombre
        AND mat.descripcion = m.Material_Descripcion
        AND mat.precio = m.Material_Precio
	WHERE mat.id_material IS NOT NULL AND 
		  m.Relleno_Densidad IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Detalle_Factura AS
BEGIN
    INSERT INTO LOSGDS.Detalle_Factura (det_fact_factura, det_fact_det_pedido, precio, cantidad, subtotal)
    SELECT DISTINCT                
        f.id_factura,                      
        dp.id_det_pedido,                 
        m.Detalle_Pedido_Precio,           
        m.Detalle_Pedido_Cantidad,         
        m.Detalle_Pedido_SubTotal          
    FROM GD1C2025.gd_esquema.Maestra m
	JOIN LOSGDS.Pedido p ON p.nro_pedido = m.Pedido_Numero
    JOIN LOSGDS.Detalle_Pedido dp ON p.id_pedido = dp.det_ped_pedido	
    JOIN LOSGDS.Factura f
        ON f.fact_numero = m.Factura_Numero
        
	WHERE Detalle_Factura_Precio IS NOT NULL AND
	Detalle_Factura_Cantidad IS NOT NULL AND
	Detalle_Factura_SubTotal IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Medida AS
BEGIN
    INSERT INTO LOSGDS.Medida 
        (alto, ancho, profundidad, precio)
    SELECT DISTINCT
        Sillon_Medida_Alto, 
        Sillon_Medida_Ancho,
        Sillon_Medida_Profundidad,
        Sillon_Medida_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Modelo AS
BEGIN
    INSERT INTO LOSGDS.Modelo 
        (cod_modelo, modelo, descripcion, precio)
    SELECT DISTINCT
        Sillon_Modelo_Codigo,
        Sillon_Modelo, 
        Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.MigrarEnvio
AS
BEGIN
    INSERT INTO LOSGDS.Envio
    SELECT
        m.Envio_Numero,
        f.id_factura,
        m.Envio_Fecha_Programada,
        m.Envio_Fecha,
        m.Envio_ImporteTraslado,
        m.Envio_ImporteSubida,
        m.Envio_Total
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Factura f ON m.Factura_Numero = f.fact_numero
    WHERE m.Envio_Numero IS NOT NULL AND m.Factura_Numero IS NOT NULL
END
GO

CREATE PROCEDURE LOSGDS.migrar_Pedido AS
BEGIN
    INSERT INTO LOSGDS.Pedido 
        (pedido_sucursal, pedido_cliente, nro_pedido, fecha, total, estado)
    SELECT DISTINCT
        s.id_sucursal,
        c.id_cliente,
        m.Pedido_Numero,
        m.Pedido_Fecha,
        m.Pedido_Total,
        m.Pedido_Estado
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Sucursal s ON s.nro_sucursal = m.Sucursal_NroSucursal
	AND s.mail = m.Sucursal_mail
    LEFT JOIN LOSGDS.Cliente c ON  c.nombre = m.Cliente_Nombre and c.dni = m.Cliente_Dni
    WHERE m.Sucursal_NroSucursal IS NOT NULL 
	AND c.id_cliente is not null and
	m.Pedido_Numero IS NOT NULL AND
        m.Pedido_Total IS NOT NULL AND
        m.Pedido_Estado IS NOT NULL 
	END
GO

CREATE PROCEDURE LOSGDS.MigrarCliente AS
BEGIN
    INSERT INTO LOSGDS.Cliente
    SELECT DISTINCT
        d.id_direccion,
        m.Cliente_Dni,
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_FechaNacimiento,
        m.Cliente_Mail,
        m.Cliente_Telefono
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Provincia p ON Cliente_Provincia = p.nombre 
    LEFT JOIN LOSGDS.Localidad l ON Cliente_Localidad  = l.nombre AND l.localidad_provincia = p.id_provincia
    LEFT JOIN LOSGDS.Direccion d ON Cliente_Direccion = d.nombre--ESTE ES EL PROBLEMA QUE COMPARA BIGITN CON ID DIRECCION
    WHERE m.Cliente_Provincia IS NOT NULL
    AND m.Cliente_Localidad IS NOT NULL
    AND Cliente_Direccion IS NOT NULL 
    ORDER BY id_direccion 
END
GO

CREATE PROCEDURE LOSGDS.migrar_Sillon AS
BEGIN
    INSERT INTO LOSGDS.Sillon (cod_sillon, sillon_modelo, sillon_medida)
    SELECT DISTINCT
        m.Sillon_Codigo,
        m.Sillon_Modelo_Codigo,
        med.cod_medida
    FROM gd_esquema.Maestra m
    left JOIN LOSGDS.Medida med
        ON med.alto = m.Sillon_Medida_Alto
        AND med.ancho = m.Sillon_Medida_Ancho
        AND med.profundidad = m.Sillon_Medida_Profundidad
        AND med.precio = m.Sillon_Medida_Precio
    WHERE m.Sillon_Codigo IS NOT NULL
END;
GO

CREATE PROCEDURE LOSGDS.migrar_SillonXMaterial AS
BEGIN
    INSERT INTO LOSGDS.SillonXMaterial (cod_sillon, id_material)
    SELECT DISTINCT
        s.cod_sillon,
        mat.id_material
    FROM gd_esquema.Maestra m
	INNER JOIN LOSGDS.Sillon s
		ON s.cod_sillon = m.Sillon_Codigo
    INNER JOIN LOSGDS.Material mat
        ON mat.tipo = m.Material_Tipo
        AND mat.material_nombre = m.Material_Nombre
        AND mat.descripcion = m.Material_Descripcion
        AND mat.precio = m.Material_Precio
    WHERE m.Sillon_Codigo IS NOT NULL;
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Sucursal AS 
BEGIN
    INSERT INTO LOSGDS.Sucursal 
        (nro_sucursal, sucursal_direccion, mail, telefono)
    SELECT DISTINCT
        m.Sucursal_NroSucursal,
        d.id_direccion,
        m.Sucursal_mail,
        m.Sucursal_telefono
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Direccion d ON d.nombre = m.Sucursal_Direccion
	WHERE d.id_direccion IS NOT NULL AND m.Sucursal_NroSucursal IS NOT NULL AND m.Sucursal_Direccion IS NOT NULL;
END;
GO

CREATE PROCEDURE LOSGDS.MigrarFactura AS 
BEGIN
    INSERT INTO LOSGDS.Factura
		(fact_cliente,fact_sucursal, fact_numero, fecha, total)
    SELECT DISTINCT
        c.id_cliente,
        s.id_sucursal,
        m.Factura_Numero,
        m.Factura_Fecha,
        m.Factura_Total
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Sucursal s ON Sucursal_NroSucursal = s.nro_sucursal
    LEFT JOIN LOSGDS.Cliente c ON Cliente_Dni = c.dni AND Cliente_Apellido = c.apellido 
    AND Cliente_Nombre =c.nombre and Cliente_FechaNacimiento = c.fecha_nacimiento
    WHERE Cliente_Dni IS NOT NULL AND m.Sucursal_NroSucursal IS NOT NULL
    AND Cliente_Apellido IS NOT NULL
    AND Cliente_Nombre IS NOT NULL 
	AND m.Factura_Numero IS NOT NULL
    AND Cliente_FechaNacimiento IS NOT NULL 
END
GO

CREATE PROCEDURE LOSGDS.migrar_Cancelacion_Pedido AS 
BEGIN
    INSERT INTO LOSGDS.Cancelacion_Pedido 
        (cancel_ped_pedido, fecha, motivo)
    SELECT DISTINCT
        p.id_pedido,
        m.Pedido_Cancelacion_Fecha,
        m.Pedido_Cancelacion_Motivo
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Pedido p ON p.nro_pedido = m.Pedido_Numero
    WHERE m.Pedido_Cancelacion_Fecha IS NOT NULL AND m.Pedido_Cancelacion_Motivo IS NOT NULL;
END;
GO

CREATE PROCEDURE LOSGDS.migrar_Detalle_Pedido AS 
BEGIN
    INSERT INTO LOSGDS.Detalle_Pedido 
        (det_ped_sillon, det_ped_pedido, cantidad, precio, subtotal)
    SELECT DISTINCT
        s.cod_sillon,
        p.id_pedido, 
        m.Detalle_Pedido_Cantidad,
        m.Detalle_Pedido_Precio,
        m.Detalle_Pedido_SubTotal
    FROM gd_esquema.Maestra m
    LEFT JOIN LOSGDS.Sillon s ON s.cod_sillon = m.Sillon_Codigo
    LEFT JOIN LOSGDS.Pedido p ON p.nro_pedido = m.Pedido_Numero
	WHERE s.cod_sillon IS NOT NULL AND p.id_pedido IS NOT NULL 
		AND m.Pedido_Numero IS NOT NULL AND m.Sillon_Modelo_Codigo IS NOT NULL
END;
GO


BEGIN TRANSACTION
    EXECUTE LOSGDS.MigrarProvincias
    EXECUTE LOSGDS.MigrarLocalidades
    EXECUTE LOSGDS.MigrarDirecciones
    EXECUTE LOSGDS.migrar_Modelo
	EXECUTE LOSGDS.migrar_Medida
	EXECUTE LOSGDS.migrar_Sillon
	EXECUTE LOSGDS.migrar_Material
    EXECUTE LOSGDS.migrar_Tela
	EXECUTE LOSGDS.migrar_Madera
	EXECUTE LOSGDS.migrar_Relleno_Sillon
	EXECUTE LOSGDS.migrar_SillonXMaterial
	EXECUTE LOSGDS.MigrarCliente
    EXECUTE LOSGDS.migrar_Sucursal
    EXECUTE LOSGDS.MigrarFactura
    EXECUTE LOSGDS.MigrarEnvio
    EXECUTE LOSGDS.migrar_Pedido
    EXECUTE LOSGDS.migrar_Cancelacion_Pedido
    EXECUTE LOSGDS.migrar_Detalle_Pedido
    EXECUTE LOSGDS.migrar_Detalle_Factura
	EXECUTE LOSGDS.MigrarProveedor
    EXECUTE LOSGDS.migrar_Compra
	EXECUTE LOSGDS.migrar_Detalle_Compra
COMMIT TRANSACTION


---Drop de procedures---
DROP PROCEDURE LOSGDS.MigrarProvincias
DROP PROCEDURE LOSGDS.MigrarLocalidades
DROP PROCEDURE LOSGDS.MigrarDirecciones
DROP PROCEDURE LOSGDS.MigrarProveedor
DROP PROCEDURE LOSGDS.migrar_Modelo
DROP PROCEDURE LOSGDS.migrar_Medida
DROP PROCEDURE LOSGDS.migrar_Sillon
DROP PROCEDURE LOSGDS.migrar_Material
DROP PROCEDURE LOSGDS.migrar_Tela
DROP PROCEDURE LOSGDS.migrar_Madera
DROP PROCEDURE LOSGDS.migrar_Relleno_Sillon
DROP PROCEDURE LOSGDS.migrar_SillonXMaterial
DROP PROCEDURE LOSGDS.migrar_Detalle_Factura
DROP PROCEDURE LOSGDS.migrar_Sucursal
DROP PROCEDURE LOSGDS.migrar_Compra
DROP PROCEDURE LOSGDS.migrar_Detalle_Compra
DROP PROCEDURE LOSGDS.migrar_Detalle_Pedido
DROP PROCEDURE LOSGDS.migrar_Cancelacion_Pedido
DROP PROCEDURE LOSGDS.MigrarFactura
DROP PROCEDURE LOSGDS.MigrarCliente
DROP PROCEDURE LOSGDS.migrar_Pedido
DROP PROCEDURE LOSGDS.MigrarEnvio