-- Create product table to store product information
CREATE OR REPLACE TABLE `project_id.seller_product.product` AS
SELECT
  current_seller.store_id
  , id product_id
  , name
  , price
  , images
  , warranty_info
  , categories
  , description
  , short_description
  , rating_average
  , all_time_quantity_sold
  , brand
  , sku
  , review_text
  , review_count
FROM `project_id.tiki.product`;

-- Create seller table to store seller information
CREATE OR REPLACE TABLE `project_id.seller_product.seller` AS
SELECT
  DISTINCT current_seller.store_id
  , current_seller.name
  , current_seller.logo
  , current_seller.link
  , current_seller.is_offline_installment_supported
  , current_seller.is_best_store
FROM `project_id.tiki.product`;
