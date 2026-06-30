# gcp/ — infrastructure-as-code (in progress)

Terraform + Cloud Build for deploying World Monitor on GCP. See
[`../docs/architecture.md`](../docs/architecture.md) for the target design and the open
decisions that gate what goes here.

Planned layout:

```
gcp/
  terraform/
    main.tf            # providers, project, APIs
    artifact.tf        # Artifact Registry
    redis.tf           # Memorystore + VPC connector
    secrets.tf         # Secret Manager entries
    run.tf             # Cloud Run: worldmonitor, ais-relay, redis-rest, ollama
    jobs.tf            # Cloud Run Job: seeders
    iam.tf
    variables.tf
    terraform.tfvars.example
  cloudbuild.yaml      # build upstream image -> Artifact Registry -> deploy Cloud Run
```

Nothing here is applied yet. Do not commit `*.tfstate` or real `*.tfvars`
(both are gitignored).
