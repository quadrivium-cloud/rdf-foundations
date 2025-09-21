# Foundational RDF -> Terraform example

This small example shows a JSON-LD definition for an Azure Storage Account, a Python
ingestion script that converts the JSON-LD to a Terraform `tfvars` file, and a
minimal Terraform configuration that consumes the generated `storage_account.tfvars`.

Repository layout
- `definitions/storage_account.jsonld` - JSON-LD definition of the storage account and resource group
- `tooling/ingest.py` - Python script that converts the definition into `terraform/storage_account.tfvars`
- `bicep/` - Bicep configuration (main, parameters)
- `terraform/` - Terraform configuration (variables, main)

## Terraform

### How it works
1. Edit `definitions/storage_account.jsonld` with your desired properties.
2. Run the ingestion script to emit `terraform/storage_account.auto.tfvars`.
3. From the `terraform` directory run `terraform init` and `terraform apply`.

### Quick start

```bash
# From respository root
python tooling/ingest.py
cd terraform
terraform init
terraform apply
```

## Bicep

### How it works
1. Edit `definitions/storage_account.jsonld` with your desired properties.
2. Run the ingestion script to emit `bicep/main.bicepparam`.
3. From the `bicep` directory run `az deployment sub create ...`

### Quick start

```bash
# From respository root
python tooling/ingest.py
cd bicep
az deployment sub create --resource-group <your-resource-group> --template-file main.bicep --parameters main.bicepparam
```

Notes
- This example keeps the JSON-LD simple and the ingestion script minimal on purpose.
- For production ingestion of arbitrary RDF/JSON-LD consider using an RDF library (rdflib) and a more robust mapping layer.
