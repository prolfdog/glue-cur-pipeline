# Glue Customer Pipeline

AWS Glue ETL pipeline for processing customer data with revenue-based filtering and tiering.

## Overview

This pipeline:
1. Reads customer data from AWS Glue Data Catalog
2. Filters customers by revenue threshold
3. Assigns customer tiers (Premium/Gold/Silver)
4. Writes results to S3 as Parquet files

## Prerequisites

- Python 3.9+
- Terraform >= 1.0
- AWS CLI configured
- AWS Glue Data Catalog with `customers` table

## Setup

### 1. Clone and Install Dependencies
```bash