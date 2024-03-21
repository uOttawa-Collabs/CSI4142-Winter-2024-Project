ALTER TABLE public.customer
ADD PRIMARY KEY (customer_id);

ALTER TABLE public.shipping_type
ADD PRIMARY KEY (shipping_type_id);

ALTER TABLE public.product
ADD PRIMARY KEY (product_id);

ALTER TABLE public.location
ADD PRIMARY KEY (location_id);

ALTER TABLE public.season
ADD PRIMARY KEY (season_id);

ALTER TABLE public.age_group
ADD PRIMARY KEY (age_group_id);


ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_shipping_type
FOREIGN KEY (shipping_type_id)
REFERENCES shipping_type(shipping_type_id);

ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_product
FOREIGN KEY (product_id)
REFERENCES product(product_id);

ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_location
FOREIGN KEY (location_id)
REFERENCES location(location_id);

ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_season
FOREIGN KEY (season_id)
REFERENCES season(season_id);

ALTER TABLE public.fact
ADD CONSTRAINT foreign_key_age_group
FOREIGN KEY (age_group_id)
REFERENCES age_group(age_group_id);

ALTER TABLE public.fact
ADD PRIMARY KEY (customer_id, shipping_type_id, product_id, location_id, season_id, age_group_id);
