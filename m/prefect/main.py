import io
import pprint
import random
import time

import httpx
from dynaconf import Dynaconf
from minio import Minio
from minio.error import S3Error
from prefect import flow, task

# Load configuration
settings = Dynaconf(
    envvar_prefix="cv",
    settings_files=["settings.yaml", ".secrets.yaml"],
)

# Connect to Minio
client = Minio(
    "localhost:9000", access_key="minioadmin", secret_key="minioadmin", secure=False
)

# Step 1: Create a bucket
bucket_name = "civitai"
found = client.bucket_exists(bucket_name)
if not found:
    client.make_bucket(bucket_name)
    print(f"Bucket '{bucket_name}' created.")


@task(log_prints=True)
def get_stars(repo: str):
    url = f"https://api.github.com/repos/{repo}"
    count = httpx.get(url).json()["stargazers_count"]

    # Step 2: Upload a string as an object to the bucket with a unique name
    content = f"{repo} has {count} stars!"
    prefix = "stars-"
    suffix = f"{int(time.time())}-{random.randint(100, 199)}"
    object_name = f"{prefix}{suffix}.txt"

    # Convert the string to a BytesIO object
    content_bytes = io.BytesIO(content.encode("utf-8"))

    # Upload the object
    client.put_object(
        bucket_name,  # Bucket name
        object_name,  # Object name with unique suffix
        data=content_bytes,  # Data as a BytesIO stream
        length=len(content),  # Length of the content
    )
    print(f"Object '{object_name}' uploaded to bucket '{bucket_name}'.")


@flow(name="stars")
def github_stars(repos: list[str]):
    for repo in repos:
        get_stars(repo)


if __name__ == "__main__":
    github_stars(["defn/dev"])
