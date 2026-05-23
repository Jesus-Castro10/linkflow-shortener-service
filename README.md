# LinkFlow Shortener Service

Serverless URL shortener service responsible for generating unique short codes and storing URL mappings.

Built using AWS Lambda, API Gateway, DynamoDB and Terraform.

---

# Features

- URL shortening
- Base62 short code generation
- Collision retry strategy
- DynamoDB persistence
- AWS Lambda serverless architecture
- Terraform infrastructure provisioning
- Structured project architecture
- CORS support
- Deploy automation script

---

# Tech Stack

- Node.js 18
- JavaScript (ES2020)
- AWS Lambda
- API Gateway REST API
- DynamoDB
- Terraform
- AWS SDK v3

---

# Project Structure

```bash
src/
  config/
  handlers/
  models/
  repositories/
  services/
  utils/

terraform/
  providers.tf
  dynamodb.tf
  lambda.tf
  api_gateway.tf
  iam.tf
  variables.tf
  outputs.tf

scripts/
  deploy.sh
```

---

# Endpoint

## Create Short URL

```http
POST /shorten
```

---

## Request

```json
{
  "url": "https://google.com"
}
```

---

## Response

```json
{
  "shortUrl": "https://domain.com/aZ91xK",
  "code": "aZ91xK"
}
```

---

# Environment Variables

```env
TABLE_NAME=
BASE_DOMAIN=
```

---

# Infrastructure

Terraform provisions:

- Lambda function
- API Gateway
- IAM roles and permissions
- DynamoDB references
- CloudWatch logging

---

# Local Development

## Install dependencies

```bash
npm install
```

---

## Run tests or local execution

```bash
npm start
```

---

# Deployment

## Deploy using script

```bash
./scripts/deploy.sh
```

---

## Terraform Apply

```bash
terraform init
terraform apply
```

---

# Architecture Notes

- Service uses layered architecture
- Business logic isolated in services
- DynamoDB access isolated in repositories
- Utility helpers centralized in utils
- Handler layer only orchestrates requests/responses

---

# CORS

CORS is enabled for frontend integration.

---

# Future Improvements

- Custom aliases
- URL expiration
- Authentication
- Rate limiting
- Analytics enrichment

---

# License

MIT
