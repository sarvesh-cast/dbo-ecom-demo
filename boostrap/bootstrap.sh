#!/bin/bash

# Define the JSON string
json_data='{
    "product1": {
    "name": "Hacked fashion chuck taylor all star",
    "url_key": "allstar",
    "sku": "allstar",
    "images": "/assets/plv4117-Blue-listing.png",
    "description": "Maximum cushioning provides a comfortable ride for everyday runs. Our softest, most cushioned ride has lightweight ZoomX foam stacked on top of responsive ReactX foam in the midsole. Plus, a redesigned traction pattern offers a smooth heel-to-toe transition.",
    "meta_title": "allstar",
    "price": "400"
  },
    "product2": {
    "name": "Seasonal color chuck 70",
    "url_key": "chuck70",
    "sku": "chuck70",
    "images": "/assets/plv3643-Blue-listing.png",
    "description": "Maximum cushioning provides a comfortable ride for everyday runs. Our softest, most cushioned ride has lightweight ZoomX foam stacked on top of responsive ReactX foam in the midsole. Plus, a redesigned traction pattern offers a smooth heel-to-toe transition.",
    "meta_title": "chuck70",
    "price": "600"
  },
  "product3": {
    "name": "Nike pegasus 350",
    "url_key": "pegasus",
    "sku": "pegasus",
    "images": "/assets/plv7632-Green-listing.png",
    "description": "Maximum cushioning provides a comfortable ride for everyday runs. Our softest, most cushioned ride has lightweight ZoomX foam stacked on top of responsive ReactX foam in the midsole. Plus, a redesigned traction pattern offers a smooth heel-to-toe transition.",
    "meta_title": "pegasus",
    "price": "411"
  },
  "product4": {
    "name": "Nike zoom",
    "url_key": "zoom",
    "sku": "zoom",
    "images": "/assets/plv7836-Blue-listing.png",
    "description": "Maximum cushioning provides a comfortable ride for everyday runs. Our softest, most cushioned ride has lightweight ZoomX foam stacked on top of responsive ReactX foam in the midsole. Plus, a redesigned traction pattern offers a smooth heel-to-toe transition.",
    "meta_title": "zoom",
    "price": "499.99"
  },
    "product5": {
    "name": "React phantom run flyknit 2",
    "url_key": "phantom",
    "sku": "phantom",
    "images": "/assets/plv2108-Green-listing.png",
    "description": "Maximum cushioning provides a comfortable ride for everyday runs. Our softest, most cushioned ride has lightweight ZoomX foam stacked on top of responsive ReactX foam in the midsole. Plus, a redesigned traction pattern offers a smooth heel-to-toe transition.",
    "meta_title": "phantom",
    "price": "500"
  }
}'

source bootstrap.vars

echo $EMAIL
echo $PASSWORD
COOKIE=$(curl -c - -i --location "http://$APP_HOST:3000/admin/user/login" \
--header "Content-Type: application/json" \
--data-raw "{
    \"email\": \"$EMAIL\",
    \"password\": \"$PASSWORD\"
  }" | grep -i 'Set-Cookie:' | sed 's/Set-Cookie: //' | tr -d '\r\n')
echo "$COOKIE"
COOKIE_VALUE=$(echo "$COOKIE" | cut -d';' -f1)
echo "$COOKIE_VALUE"


# Extract keys and iterate through each product
echo "$json_data" | jq -c 'to_entries[] | .value' | while IFS= read -r product; do
  name=$(echo "$product" | jq -r '.name')
  description=$(echo "$product" | jq -r '.description')
  sku=$(echo "$product" | jq -r '.sku')
  url_key=$(echo "$product" | jq -r '.url_key')
  images=$(echo "$product" | jq -r '.images')
  price=$(echo "$product" | jq -r '.price')
  
  echo $name
  echo $sku

  # Run the curl command with extracted values
  curl -X POST \
    http://$APP_HOST:3000/api/products \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Cookie: $COOKIE_VALUE;" \
    -d "{
      \"name\": \"$name\",
      \"description\": \"$description\",
      \"short_description\": \"$description\",
      \"sku\": \"$sku\",
      \"url_key\": \"$url_key\",
      \"meta_title\": \"$meta_title\",
      \"meta_description\": \"Your product meta description\",
      \"meta_keywords\": \"keywords\",
      \"status\": 1,
       \"price\": \"$price\",
      \"weight\": \"1\",
      \"qty\": \"100\",
      \"manage_stock\": 1,
      \"stock_availability\": 1,
      \"group_id\": 1,
      \"visibility\": 1,
      \"images\": [\"$images\"],
      \"category_id\": 3,
      \"attributes\": [
        {
          \"attribute_code\": \"size\",
          \"value\": \"2\"
        },
        {
          \"attribute_code\": \"color\",
          \"value\": [\"1\"]
        }
      ]
    }"
done

PGPASSWORD="$DB_PASSWORD" psql -h $MAIN_DB -U $DB_USER -d $DB_NAME -f bootstrap.sql
