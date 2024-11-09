  SELECT [ClvCat]
      ,[Nombre]
  FROM [papeleria_corregido].[dbo].[Categorias]
  for json PATH

  SELECT ClvCli
      ,Nombre
      ,Apellido
      ,JSON_ARRAY(Telefono)AS Telefono,
      Ciudad AS[Domicilio.Ciudad],
      Region AS[Domicilio.Region],
      CP AS[Domicilio.CP],
      Pais AS[Domicilio.Pais],
      Calle AS[Domicilio.Calle],
      NumCasa AS[Domicilio.NumCasa]
  FROM Clientes
  for json path

    SELECT[ClvCom]
      ,[PrecioCompra]
      ,[FechaCompra]
  FROM [papeleria_corregido].[dbo].[Compras]
  for json path

    SELECT [ClvDesc]
      ,[ClvPro]
      ,[Porcentaje]
      ,[FechaInicio]
      ,[FechaFin]
  FROM [papeleria_corregido].[dbo].[Descuentos]
  for json path

    SELECT  [ClvPro]
      ,[ClvCom]
      ,[Cantidad]
      ,[PrecioUnitario]
  FROM [papeleria_corregido].[dbo].[Detalle_Pro_Com]
  for json path

    SELECT  [ClvPro]
      ,[ClvProv]
      ,[PrecioCompra]
      ,[PlazoEntrega]
  FROM [papeleria_corregido].[dbo].[Detalle_Pro_Prov]
  for json path

  SELECT [ClvPro]
      ,[ClvVen]
      ,[Cantidad]
      ,[PrecioUnitario]
      ,[DescuentoAplicado]
  FROM [papeleria_corregido].[dbo].[Detalle_Pro_Ven]
  FOR JSON PATH

  SELECT [ClvVen]
      ,[ClvCli]
      ,[FechaCompra]
      ,[TotalCompra]
      ,[MetodoPago]
  FROM [papeleria_corregido].[dbo].[Detalle_Ven_Cli]
  for json path

  
  SELECT  [ClvDevCom]
      ,[ClvCom]
      ,[ClvPro]
      ,[Cantidad]
      ,[FechaDev]
      ,[Motivo]
      ,[Ajuste]
  FROM [papeleria_corregido].[dbo].[Devoluciones_Compras]for json path

    SELECT  [ClvDevVen]
      ,[ClvVen]
      ,[ClvPro]
      ,[Cantidad]
      ,[FechaDev]
      ,[Motivo]
      ,[Reembolso]
  FROM [papeleria_corregido].[dbo].[Devoluciones_Ventas]
  for json path

    SELECT[ClvHistorial]
      ,[ClvPro]
      ,[ClvVen]
      ,[ClvCom]
      ,[ClvDevVen]
      ,[ClvDevCom]
      ,[CantidadAnt]
      ,[CantidadNueva]
      ,[FechaCambio]
      ,[Motivo]
  FROM [papeleria_corregido].[dbo].[Historial_Inventario]
  for json path

    SELECT  [ClvPro]
      ,[CantidadDisponible]
      ,[CantidadMinima]
      ,[CantidadMaxima]
      ,[FechaActualizacion]
  FROM [papeleria_corregido].[dbo].[Inventario]
  for json path

    SELECT  [ClvPro]
      ,[Nombre]
      ,[Precio]
      ,[Costo]
      ,[Ganancia]
      ,[Descuento]
      ,[Imagen]
      ,[ClvSubCat]
  FROM [papeleria_corregido].[dbo].[Productos]
  for json path

    SELECT [ClvProv]
      ,[Nombre]
      ,JSON_ARRAY(Telefono)AS Telefono,
      Ciudad AS[Domicilio.Ciudad],
      Region AS[Domicilio.Region],
      CP AS[Domicilio.CP],
      Pais AS[Domicilio.Pais],
      Calle AS[Domicilio.Calle],
      NumCasa AS[Domicilio.NumCasa]
      ,[Calificacion]
      ,[PlazoEntrega]
      ,[Reputacion]
  FROM [papeleria_corregido].[dbo].[Proveedores]
  for json path

    SELECT[ClvSubCat]
      ,[Nombre]
      ,[ClvCat]
  FROM [papeleria_corregido].[dbo].[Subcategorias]
  for json path

    SELECT [ClvVen]
      ,[ClvCli]
      ,[PrecioTotal]
      ,[Fecha]
      ,[CantidadTotal]
  FROM [papeleria_corregido].[dbo].[Ventas]
  for json path