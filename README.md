# Source

## 0. Setup
- Create a google cloud VM
- Install MongoDB on the VM to store Tiki scraped data
- Create a GCS bucket
- Create the BigQuery database and tables

## 1. Migrate data from MongoDB to GCS
Script: [migrate_data](src/migrate_data.sh)
### Workflow
- Export the `product` collection from the `tiki` database to a JSON file `product.json`
- Upload the JSON file to the `mongodb-data-1` bucket
- Use `parallel_composite_upload_threshold` to enable parallel composite uploads if the file size exceeds 150 megabytes
- After the upload process is done, remove the JSON file
- Use `crontab` to run the script at 22:00 everyday

## 2. Load data from the GCS bucket to a Big Query table
Script: [load_data](src/load_data.py)
### Workflow
- Create a Google Cloud Function that triggers when the file `product.json` is uploaded to the `mongodb-data-1` bucket and loads the data into the `product` table within the `tiki` database in BigQuery
- Output: [product_sample](data/processed_data/migrated_data)

## 3. Create 
