CREATE OR REPLACE VIEW price_search_view AS
SELECT
    pb.id_price_book,
    pb.purchase_price,
    pb.regular_price,
    pb.low_price,
    pb.discount,
    m.title_variant,
    p.title_product,
    i.sku,
    i.id_inventory
FROM
    price_book pb
JOIN
    model m ON pb.model_id = m.id_model
JOIN
    product p ON m.product_id = p.id_product
JOIN
    inventory i ON m.id_model = i.model_id;

COMMENT ON VIEW price_search_view IS 'View to search prices by title_variant, title_product, sku, or id_inventory

-- Примеры использования представления price_search_view:

-- 1. Поиск по title_variant из таблицы model
SELECT purchase_price, regular_price, low_price, discount
FROM price_search_view
WHERE title_variant = ''Example Variant'';

-- 2. Поиск по title_product из таблицы product
SELECT purchase_price, regular_price, low_price, discount
FROM price_search_view
WHERE title_product = ''Example Product'';

-- 3. Поиск по sku из таблицы inventory
SELECT purchase_price, regular_price, low_price, discount
FROM price_search_view
WHERE sku = ''123456789012'';

-- 4. Поиск по id_inventory из таблицы inventory
SELECT purchase_price, regular_price, low_price, discount
FROM price_search_view
WHERE id_inventory = 1;

';