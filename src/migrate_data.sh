#!/bin/bash

# Set the necessary variables
DATABASE="tiki"
COLLECTION="product"
BUCKET="mongodb-data-1"
FILE="product.json"

mongoexport --db "$DATABASE" --collection "$COLLECTION" | sed '/"_id":/s/"_id":[^,]*,//' > "$FILE"
gsutil -o "GSUtil:parallel_composite_upload_threshold=150M" -m cp "$FILE" gs://"$BUCKET"
rm "$FILE"
