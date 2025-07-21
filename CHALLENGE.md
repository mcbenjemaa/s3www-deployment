## CHALLENGE.md

This file describes the challenges and solutions implemented in this project, focusing on deploying MinIO on Kubernetes as a chart dependency and using init containers for file upload.

### Deploy MinIO on Kubernetes as Chart Dependency

In this challenge, we will deploy MinIO on Kubernetes using a Helm chart as a dependency in our application chart.
This approach allows us to manage MinIO as part of our application's deployment, ensuring that it is always available when our application starts.
We will use the official MinIO Helm chart to deploy MinIO in our Kubernetes cluster.

By following this approach, we can easily manage the MinIO deployment alongside our application, ensuring that it is always in sync with our application's lifecycle.
Not only that but also, it allows us to configure MinIO with the necessary settings, such as access keys and bucket names, directly from our application's Helm chart values.
and can be easily enabled or disabled based on the application's requirements.

By setting up the condition for the MinIO dependency, we can control whether MinIO is deployed or not based on the application's configuration.
```yaml
dependencies:
  - name: minio
    alias: minio
    version: 5.4.0
    repository: https://charts.min.io/
    condition: minio.enabled
```

This upstream chart allows configuration of various settings, such as access keys, bucket names, and other MinIO-specific configurations.
therefore, we can easily create buckets,policies and users to suit our application's needs.
All minIO values will be defined in it's own section in the `values.yaml` file of our application chart, allowing us to customize the MinIO deployment as needed.

```yaml
minio:
  enabled: true
  mode: standalone
  # other MinIO configurations
```

Using the upstream MinIO chart capbilities, we can easily create a bucket and set up the necessary policies and users to allow our application to interact with MinIO.

```yaml
minio:
 # ... other MinIO configurations
  # This list defines the buckets to be created in MinIO at startup.
  buckets:
    - name: s3www-data
      policy: none
      purge: false
      
  # This list defines the buckets to be created in MinIO at startup.    
  policies:
    - name: allow-read
      statements:
        - effect: Allow  # this is the default
          resources:
            - 'arn:aws:s3:::s3www-data/*'
          actions:
            - "s3:GetObject"
            - "s3:ListBucket"
```

### Kubernetes Init Container for File Upload to minIO

In this challenge, we will implement a Kubernetes init containers to upload a file to a MinIO instance before starting the main application container.
This approach ensures that the file is available in the MinIO bucket before the application starts, leveraging Kubernetes' lifecycle management.

I have chose to use init containers for this task because it allows us to perform the file download/upload before the main application starts,
ensuring that the file is available when the application needs it.
This method avoids modifying the existing `s3www` logic and keeps the file upload process separate from the main application logic.
in addition, using an init container allows us to handle the file upload in a controlled manner, ensuring that the main application only starts after the file is successfully uploaded.
and handles retries and failures gracefully.

We need a value in our `values.yaml` file to specify the file to be served.
```yaml
fileToServeUrl: "https://example.com/path/to/file.txt"
```

By design, We need to add 2 init containers to our deployment:

* The first init container will download the file from the specified URL and save it to a temporary location.
* The second init container will upload the downloaded file to the MinIO bucket using the MinIO client (mc).

The biggest challenge here was to wait until the MinIO service is ready before attempting to upload the file.
I have created a simple retry mechanism in the second init container that checks if the minio set command is successful.
**This is truly can be improved**

Although, the setup here is a bit complex, it is a robust solution that ensures the file is uploaded to MinIO before the main application starts.
