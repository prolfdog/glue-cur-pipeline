import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsgluedq.transforms import EvaluateDataQuality
from awsglue import DynamicFrame
import re

import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Add handler to output logs
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)


def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)

# get command line arguments and pass them into the job
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'DATABASE_NAME',
    'TABLE_NAME',
    'OUTPUT_PATH',
    'REVENUE_THRESHOLD',
    'PREMIUM_THRESHOLD',
    'GOLD_THRESHOLD'
])

# set up spark context, session and job
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# log start
logger.info("Starting customer pipeline job")
logger.info(f"Database: {args['DATABASE_NAME']}")
logger.info(f"Table: {args['TABLE_NAME']}")
logger.info(f"Revenue Threshold: {args['REVENUE_THRESHOLD']}")
logger.info(f"Premium Threshold: {args['PREMIUM_THRESHOLD']}")
logger.info(f"Gold Threshold: {args['GOLD_THRESHOLD']}")
logger.info(f"Output Path: {args['OUTPUT_PATH']}")


# Script generated for node Amazon S3

try:
    # 1. READ from catalog
    source_data = glueContext.create_dynamic_frame.from_catalog(
        database=args['DATABASE_NAME'], 
        table_name=args['TABLE_NAME'], 
        transformation_ctx="source_data"
    )
    logger.info(f"Read data from catalog. Record count: {source_data.count()}")

    # 2. FILTER
    revenue_threshold = int(args['REVENUE_THRESHOLD'])
    filtered_data = Filter.apply(
        frame=source_data, 
        f=lambda row: (row["revenue"] > revenue_threshold), 
        transformation_ctx="filtered_data"
    )
    logger.info(f"Filtered data. Record count: {filtered_data.count()}")

    # 3. SQL TRANSFORM
    premium_threshold = int(args['PREMIUM_THRESHOLD'])
    gold_threshold = int(args['GOLD_THRESHOLD'])
    
    SqlQuery0 = f'''
    SELECT 
        *,
        CASE 
            WHEN revenue > {premium_threshold} THEN 'Premium'
            WHEN revenue > {gold_threshold} THEN 'Gold'
            ELSE 'Silver'
        END as customer_tier
    FROM myDataSource
    '''
    final_data = sparkSqlQuery(
        glueContext, 
        query=SqlQuery0, 
        mapping={"myDataSource": filtered_data}, 
        transformation_ctx="final_data"
    )
    
    logger.info(f"Writing {final_data.count()} records to {args['OUTPUT_PATH']}")

    # 4. WRITE to S3
    glueContext.write_dynamic_frame.from_options(
        frame=final_data, 
        connection_type="s3", 
        format="glueparquet", 
        connection_options={
            "path": args['OUTPUT_PATH'], 
            "partitionKeys": []
        }, 
        format_options={"compression": "snappy"}, 
        transformation_ctx="output_to_s3"
    )

except Exception as e:
    logger.error(f"Job failed with error: {str(e)}")
    raise

logger.info("Job completed successfully")
job.commit()