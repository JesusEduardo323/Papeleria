----------------------------------------------------------------------
--Tema: Gestion de inventario 
----------------------------------------------------------------------

-- 1. Tablas necesarias: Inventarion e Historial_Inventario

-- 2. Procedimientos 

-- A) Actualizar inventario despues de una compra o venta
-- Este procedimiento actualiza las existencias del producto y registra el cambio en el historial

create or replace procedure sp_actualizar_inventario(
    _clvpro int,
    _cantidad int,
    _operacion text
)
as $$
	declare
	    _inventario_actual int;
	begin
	    -- Obtener el inventario actual
	    select cantidaddisponible
	    into _inventario_actual
	    from inventario
	    where clvpro = _clvpro;
	
	    -- Validar si el producto existe en inventario
	    if not found then
	        raise exception 'El producto con clave % no existe en el inventario', _clvpro;
	    end if;
	
	    -- Operación para una venta (reducir inventario)
	    if _operacion = 'venta' then
	        if _inventario_actual < _cantidad then
	            raise exception 'Inventario insuficiente para el producto con clave %', _clvpro;
	        end if;
	
	        update inventario
	        set cantidaddisponible = cantidaddisponible - _cantidad,
	            fechaactualizacion = current_date
	        where clvpro = _clvpro;
	
	    -- Operación para una compra (aumentar inventario)
	    elsif _operacion = 'compra' then
	        update inventario
	        set cantidaddisponible = cantidaddisponible + _cantidad,
	            fechaactualizacion = current_date
	        where clvpro = _clvpro;
	
	    else
	        raise exception 'Operación no válida: %. Use "venta" o "compra".', _operacion;
	    end if;
	
	    -- Confirmar éxito
	    raise notice 'Inventario actualizado correctamente para el producto %', _clvpro;
	end;
$$
language plpgsql;


-- B) Consultar el inventario bajo
-- Este procedimiennto detecta los productos con existencias menores a la cantidad minima

create or replace procedure sp_consultar_inventario_bajo()
as $$
	declare
	    Record record;
	begin
	    -- Mostrar un mensaje previo
	    raise notice 'Productos con inventario bajo:';
	
	    -- Seleccionar y recorrer los productos con inventario bajo
	    for record in (
	        select clvpro, cantidaddisponible, cantidadminima
	        from inventario
	        where cantidaddisponible < cantidadminima
	    )
	    loop
	        raise notice 'Producto: %, Inventario: %, Mínimo requerido: %', record.clvpro, record.cantidaddisponible, record.cantidadminima;
	    end loop;
	end;
$$
language plpgsql;


-- C) Revisar inventario por producto
-- Consultar el inventario de un producto especifico

create or replace procedure sp_revisar_inventario_por_producto(_product_id numeric)
as 
$$
	declare
		_cantidad_disponible int;
	begin
		-- Consultar inventario usando la columna correcta
		select cantidaddisponible into _cantidad_disponible
		from inventario 
		where clvpro = _product_id;

		if _cantidad_disponible is null then
			-- Si no hay inventario para ese producto, mostrar el mensaje
			raise notice 'El producto % no existe en el inventario', _product_id;
		else
			-- Mostrar la cantidad disponible del producto
			raise notice 'El producto % tiene % unidades disponibles', _product_id, _cantidad_disponible;
		end if;
end;
$$
language plpgsql;


-------------------------------------------------------------------
-- Ejemplos

call sp_actualizar_inventario(1, 10, 'venta'); -- Vender 10 unidades del producto 1
call sp_actualizar_inventario(1, 20, 'compra');

call sp_consultar_inventario_bajo();

call sp_revisar_inventario_por_producto(1); -- Revisar inventario del producto 1
call sp_revisar_inventario_por_producto(5); -- Error: producto no existe

