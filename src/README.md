# SOURCE

## 0. Setup
- Install Google Cloud CLI
- Login to GCP with command `gcloud auth application-default login`
- Export Environment Variable `GOOGLE_APPLICATION_CREDENTIALS` which path of `~/.config/gcloud/application_default_credentials.json`

## 1. Export Data to JSONL file:
- Script: [export_and_upload_to_GCS/export_to_JSONL.py](src/export_and_upload_to_GCS/export_to_JSONL.py)
- Parameters: `None`

### **Workflow**
- Query all Data from MongoDB
- Change flieds `_id` and `crawled_time` to `string` for importing to BigQuery
- Export data to JSON Newline Delemiter in foler [export](export)
  - Example: category_[date_time].json and product_[date_time].json

## 2. Upload file to Google Cloud Storage: 
- Script: [export_and_upload_to_GCS/upload_to_GCS.py](src/export_and_upload_to_GCS/upload_to_GCS.py)
- Parameters:
  1. `File path`: File or Folder to upload to GCS
  2. `Bucket name`: Destination Bucket in GCS
- Example command: `python [project_path]/src/export_and_upload_to_GCS/upload_to_GSC.py [file_path] [bucket_name]`

### **Workflow**
- Considering the input is folder or file
- Create `gsutil` command for copy File/Folder from local to Destination Bucket
  - The command use option `-m` and config `parallel_composite_upload_threshold` for multithresh uploading

## * Export from MongoDB + Upload to GCS:
- script: [export_and_upload_to_GCS/main.py](src/export_and_upload_to_GCS/main.py)
- Parameters:
  1. `Bucket name`: Destination Bucket in GCS
- Example command: `python [project_path]/src/export_and_upload_to_GCS/main.py [bucket_name]`

### **Workflow**
- Query all Data from MongoDB
- Change flieds `_id` and `crawled_time` to `string` for importing to BigQuery
- Export data to JSON Newline Delemiter in foler [export](export)
- The output is [category.json](export/category.json) and [product.json](export/product.json) (Overwrite if exist)
- Load two output files to Destination Bucket

## 3. Load Data to BigQuery by Google Cloud Function
- Source code:
  - [load_data_to_BQ/main.py](src/function_load_data_to_BQ/main.py)
  - [load_data_to_BQ/requirement.txt](src/function_load_data_to_BQ/requirement.txt)
    - Import `google_cloud_bigquery` for BigQuery Client
- Create Function with:
  - Runtime environment: Python3.9
  - Trigger type: Cloud Storage
  - Event type: On (finalizing/creating) file in the selected bucket
  - Bucket name: Match with Destination Bucket above
  - Entry point: `load_table_uri_json`
  - _**Note:**_ The Region of Function must match with Region of Bucket 

### **Workflow**
- Trigger when a file uploaded or overwrite in the selected bucket
- If the uploaded file is not CSV file, then finish.
- If the uploaded file is CSV file, get name of the file for table name.
- Load Data from file to Table.