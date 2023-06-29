from google.cloud import bigquery
from google.cloud import storage

def process_data(event, context):
    bucket_name = event["bucket"]
    file_name = event["name"]
    failed_records_file = "gs://{bucket_name}/failed_records.json"

    # Check if the uploaded file is 'product.json'
    if file_name == "product.json":
        bq_client = bigquery.Client()
        dataset_id = "tiki"
        table_id = "product"
        bq_client.project = "project_id"

        table_ref = f"{bq_client.project}.{dataset_id}.{table_id}"

        # Load data from Cloud Storage into a BigQuery table
        job_config = bigquery.LoadJobConfig(
            source_format = bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
            write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
            max_bad_records = 50000,
            autodetect = True
        )

        uri = f"gs://{bucket_name}/{file_name}"
        load_job = bq_client.load_table_from_uri(uri, table_ref, location = "US", job_config=job_config)
        load_job.result()
        
	# Write failed records to a json file for further investigation
        with open("failed_records.json", "w") as f:
            for error in load_job.errors:
                for record in error["errors"]:
                    json.dump(record["json"], f)
                    f.write("\n")

        load_stats = load_job.statistics.load
        successful_records_count = load_stats.output_rows
        print(f"Successfully loaded records count: {successful_records_count}")

    else:
        print(f"Skipping file '{file_name}' as it is not 'product.json'.")
