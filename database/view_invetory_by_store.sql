CREATE OR REPLACE VIEW inventory_by_store AS
SELECT
    i.id_inventory,
    i.sku,
    i.modified_date,
    i.status_items_inventory,
    s.full_name AS store_name,
    b.brand_name,
    v.vendor_name,
    i.model_id,
    m.title_variant,
    p.title_product
FROM
    inventory i
JOIN
    store s ON i.store_id = s.id_store
JOIN
    model m ON i.model_id = m.id_model
JOIN
    product p ON m.product_id = p.id_product
JOIN
    brand b ON p.brand_id = b.id_brand
JOIN
    vendor v ON p.vendor_id = v.id_vendor
WHERE
    i.status_items_inventory = ANY (ARRAY['Ready for Sale', 'Defective', 'On Return', 'ICT (to receive in MN)', 'ICT (sent and not received)']::status_items_inventory[])
    AND (b.brand_name IS NOT NULL)
    AND (v.vendor_name IS NOT NULL);

COMMENT ON VIEW inventory_by_store IS 'View to display inventory by store with filters for status items, brand, and vendor


-- 1. Получение всех записей из представления inventory_by_store
SELECT * FROM inventory_by_store;

-- 2. Фильтрация по конкретному магазину (store_name)
SELECT * FROM inventory_by_store
WHERE store_name = ''Main Store'';

-- 3. Фильтрация по конкретному бренду (brand_name)
SELECT * FROM inventory_by_store
WHERE brand_name = ''BrandX'';

-- 4. Фильтрация по конкретному вендору (vendor_name)
SELECT * FROM inventory_by_store
WHERE vendor_name = ''VendorY'';

-- 5. Фильтрация по статусу предметов инвентаря (status_items_inventory)
SELECT * FROM inventory_by_store
WHERE status_items_inventory = ''Ready for Sale'';

-- 6. Комбинированная фильтрация по магазину и бренду
SELECT * FROM inventory_by_store
WHERE store_name = ''Main Store'' AND brand_name = ''BrandX'';

-- 7. Фильтрация по дате модификации (modified_date) с определенной даты
SELECT * FROM inventory_by_store
WHERE modified_date >= ''2023-01-01'';

-- 8. Фильтрация по нескольким статусам предметов инвентаря
SELECT * FROM inventory_by_store
WHERE status_items_inventory IN (''Ready for Sale'', ''Defective'');

-- 9. Фильтрация по модели (model_id) и варианту (title_variant)
SELECT * FROM inventory_by_store
WHERE model_id = 123 AND title_variant = ''Variant A'';

-- 10. Фильтрация по названию продукта (title_product)
SELECT * FROM inventory_by_store
WHERE title_product = ''Product Z'';

';