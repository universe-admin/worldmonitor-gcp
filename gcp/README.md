# gcp/ — infrastructure-as-code

Terraform + Cloud Build for deploying **Universe Monitor** on GCP, following the
17-phase cloud-native plan. Progress against each phase is tracked in
[`../docs/roadmap.md`](../docs/roadmap.md); the target design is in
[`../docs/architecture.md`](../docs/architecture.md).

## Layout

```
gcp/
  cloudbuild.yaml          # Phase 13 — build app image -> Artifact Registry -> deploy Cloud Run
  terraform/
    versions.tf            # provider + backend pins
    variables.tf           # inputs (project, region, domain, sizing)
    main.tf                # providers + locals (Cloud Run service catalogue)
    apis.tf                # Phase 1  — enable GCP APIs
    network.tf             # Phase 1/14 — VPC, subnets, connector, NAT, PSA, firewall
    iam.tf                 # Phase 2  — service accounts + least-privilege roles
    artifact.tf            # Phase 4  — Artifact Registry
    run.tf                 # Phase 5  — Cloud Run: frontend/backend/websocket/auth + relay/redis-rest/ollama
    sql.tf                 # Phase 6  — Cloud SQL (Postgres, private IP)
    storage.tf             # Phase 7  — GCS buckets
    pubsub.tf              # Phase 8  — Pub/Sub topics + subscriptions
    secrets.tf             # Phase 9  — Secret Manager containers (+ generated DB password)
    redis.tf               # Growth   — Memorystore for Redis
    jobs.tf                # Cloud Run Job — seeders
    scheduler.tf           # Phase 16 — Cloud Scheduler -> Pub/Sub
    monitoring.tf          # Phase 12 — uptime check + alert policies
    loadbalancer.tf        # Phase 14/15 — static IP, HTTPS LB, Cloud Armor, TLS
    dns.tf                 # Phase 14 — Cloud DNS zone + records
    outputs.tf             # LB IP, name servers, registry path, SQL/Redis, service URLs
    terraform.tfvars.example
```

## Usage

```bash
cd gcp/terraform
cp terraform.tfvars.example terraform.tfvars   # set project_id, domain, sizing
terraform init                                 # downloads providers (needs registry access)
terraform plan
terraform apply
```

After apply:
1. Add secret **values** (everything except the generated DB password) —
   `gcloud secrets versions add <name> --data-file=-`.
2. Trigger Cloud Build to push the first image, then re-apply / `gcloud run deploy`
   so services run the real image instead of the placeholder.
3. Point the registrar's nameservers at the zone — `terraform output dns_name_servers`.
4. Run the seeders job — `gcloud run jobs execute uvm-seeders --region <region>`.

## Notes

- **Remote state:** create a GCS bucket and uncomment the `backend "gcs"` block in
  `versions.tf` before collaborating.
- Do **not** commit `*.tfstate` or real `*.tfvars` — both are gitignored.
- `deletion_protection = true` on the SQL instance guards against accidental destroy.
- Provider download was blocked in the authoring sandbox (egress policy), so
  `terraform init/validate/plan` run in your environment; `terraform fmt` passes here.
