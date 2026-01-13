#!/bin/bash
# Basic Terraform test script for AuDHD LifeCoach Infrastructure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running Terraform tests for AuDHD LifeCoach Infrastructure${NC}"

# Test root module
echo -e "\n${YELLOW}Testing root module syntax...${NC}"
cd "$(dirname "$0")/.."
terraform validate || {
  echo -e "${RED}Root module validation failed!${NC}"
  exit 1
}
echo -e "${GREEN}Root module syntax validation passed!${NC}"

# Run a terraform plan with RabbitMQ server if credentials are available
if [ -n "$RABBITMQ_ENDPOINT" ] && [ -n "$RABBITMQ_USERNAME" ] && [ -n "$RABBITMQ_PASSWORD" ]; then
  echo -e "\n${YELLOW}Running terraform plan with RabbitMQ server...${NC}"
  terraform init
  terraform plan \
    -var "rabbitmq_endpoint=$RABBITMQ_ENDPOINT" \
    -var "rabbitmq_username=$RABBITMQ_USERNAME" \
    -var "rabbitmq_password=$RABBITMQ_PASSWORD" || {
    echo -e "${RED}Terraform plan failed!${NC}"
    exit 1
  }
  echo -e "${GREEN}Terraform plan succeeded!${NC}"
else
  echo -e "\n${YELLOW}Skipping terraform plan because RabbitMQ credentials are not available.${NC}"
  echo -e "${YELLOW}To run a full test, set RABBITMQ_ENDPOINT, RABBITMQ_USERNAME, and RABBITMQ_PASSWORD environment variables.${NC}"
fi

# Run Terratest tests
echo -e "\n${YELLOW}Running Terratest for RabbitMQ configuration...${NC}"
cd test
go test -v -timeout 30m || {
  echo -e "${RED}Terratest tests failed!${NC}"
  exit 1
}
echo -e "${GREEN}Terratest tests passed!${NC}"

echo -e "\n${GREEN}All tests passed!${NC}"