-- Retrieve product information
Create `poject_id.tiki.product_information` as
Select
  id
  , name product_name
  , categories.name category
  , current_seller.name seller
  , list_price price
  , all_time_quantity_sold quantity_sold
  , rating_average rating
from `upheld-ellipse-387807.tiki.product`;

-- Retrieve product origin information
Create table `project_id.tiki.product_origin` as
select
  u.id id
  , u.categories.name category
  , Case
      when a.value = "Trung Quốc" then "Trung Quốc" else "Các nước khác" end as origin
from `upheld-ellipse-387807.tiki.product` u
, unnest(specifications) s
, unnest(s.attributes) a
where a.name = "Xuất xứ thương hiệu";
