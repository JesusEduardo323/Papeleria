----------------------------------------------------------------------
--Tema: Gestion de descuentos
----------------------------------------------------------------------

-- 1. Aplicacion de descuentos a productos
--Este procedimiento actualizará el precio de un producto con base en un porcentaje de descuento

create or replace procedure sp_aplicar_descuento_producto(_product_id numeric, _descuento numeric)
as
$$
    declare
        _precio_original numeric;
        _nuevo_precio numeric;
    begin
        -- Consultar el precio original del producto
        select precio into _precio_original
        from productos
        where clvpro = _product_id;

        -- Verificar si el producto existe
        if _precio_original is null then
            raise notice 'El producto % no existe', _product_id;
        else
            -- Aplicar el descuento
            _nuevo_precio := _precio_original - (_precio_original * (_descuento / 100));

            -- Actualizar el precio del producto con el descuento
            update productos
            set precio = _nuevo_precio
            where clvpro = _product_id;

            -- Mostrar el nuevo precio
            raise notice 'El nuevo precio para el producto % es: %.2f', _product_id, _nuevo_precio;
        end if;
    end;
$$
language plpgsql;

-- 2. Consultar descuentos aplicados para un producto
--Este procedimiento consultará los descuentos aplicados a un producto.

create or replace procedure sp_consultar_descuento_producto(_product_id numeric)
as
$$
    declare
        _descuento_porcentaje numeric;  -- Se cambia a numeric
        _fecha_inicio date;
        _fecha_fin date;
    begin
        -- Consultar el descuento aplicado al producto
        select porcentaje, fechainicio, fechafin
        into _descuento_porcentaje, _fecha_inicio, _fecha_fin
        from descuentos
        where clvpro = _product_id and fechafin > current_date; -- Verificar si el descuento aún está activo

        if _descuento_porcentaje is null then
            raise notice 'No hay descuentos activos para el producto %', _product_id;
        else
            raise notice 'Producto % tiene un descuento de %%% válido desde % hasta %', 
                _product_id, _descuento_porcentaje, _fecha_inicio, _fecha_fin;
        end if;
    end;
$$
language plpgsql;

-- 3. Procedimiento para aplicar descuentos durante la venta
--Durante una venta, es importante verificar si el producto tiene un descuento activo y aplicar dicho descuento en el total de la compra

CREATE OR REPLACE PROCEDURE sp_aplicar_descuento_a_detalle_venta(_clvven NUMERIC, _descuento NUMERIC)
AS $$
DECLARE
    record RECORD;
    _precio_original NUMERIC;
    _nuevo_precio NUMERIC;
BEGIN
    -- Iterar sobre los productos en el detalle de la venta
    FOR record IN 
        SELECT clvpro, cantidad 
        FROM detalle_pro_ven 
        WHERE clvven = _clvven
    LOOP
        -- Obtener el precio original del producto
        SELECT precio 
        INTO _precio_original
        FROM Productos
        WHERE clvpro = record.clvpro;

        -- Verificar si el producto existe y tiene un precio válido
        IF _precio_original IS NULL THEN
            RAISE NOTICE 'El producto % no tiene un precio válido en la tabla Productos.', record.clvpro;
            CONTINUE; -- Saltar al siguiente producto
        END IF;

        -- Calcular el nuevo precio con el descuento aplicado
        _nuevo_precio := _precio_original - (_precio_original * (_descuento / 100));

        -- Actualizar el precio unitario en el detalle de la venta
        UPDATE detalle_pro_ven
        SET preciounitario = _nuevo_precio,
            descuentoaplicado = _descuento
        WHERE clvven = _clvven AND clvpro = record.clvpro;
    END LOOP;

    RAISE NOTICE 'Descuento aplicado correctamente a la venta %', _clvven;
END;
$$ LANGUAGE plpgsql;



----------------------------------------------------------------------
--Ejemplos

call sp_aplicar_descuento_producto(1, 20);
select clvpro, nombre, precio
from productos
where clvpro = 1;

call sp_consultar_descuento_producto(10);
select clvpro, porcentaje, fechainicio, fechafin
from descuentos
where clvpro = 10
  and fechafin > current_date; -- Solo muestra descuentos que aún están activos


call sp_aplicar_descuento_a_detalle_venta(5, 10);
SELECT * 
FROM detalle_pro_ven
WHERE clvven = 5;