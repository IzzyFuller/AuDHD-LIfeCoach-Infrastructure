package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestRabbitMQConfiguration tests the RabbitMQ Terraform configuration
func TestRabbitMQConfiguration(t *testing.T) {
	t.Parallel()

	// Root folder where Terraform code is located
	rootFolder := "../"

	// Create a temporary directory for the plan file
	tempTestFolder := t.TempDir()
	planFilePath := filepath.Join(tempTestFolder, "plan.out")

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: rootFolder,

		// Set the binary to terraform explicitly
		TerraformBinary: "terraform",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"environment":       "test",
			"rabbitmq_endpoint": "http://localhost:15672",
			"rabbitmq_username": "guest",
			"rabbitmq_password": "guest",
			"rabbitmq_insecure": true,
			"rabbitmq_vhost":    "/",
			"rabbitmq_exchanges": []map[string]interface{}{
				{
					"name":        "test.events",
					"type":        "topic",
					"durable":     true,
					"auto_delete": false,
				},
			},
		},

		// Plan, rather than apply, since we don't want to actually create resources
		NoColor:      true,
		PlanFilePath: planFilePath,
	})

	// Run `terraform init` to initialize the config
	terraform.Init(t, terraformOptions)

	// For validation, we need a separate options object without vars
	validateOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:    rootFolder,
		TerraformBinary: "terraform",
		NoColor:         true,
	})

	// Validate the terraform syntax
	terraform.Validate(t, validateOptions)
	t.Log("Configuration syntax validation passed.")

	// Skip the actual planning if we're not connected to a RabbitMQ server
	// This allows us to at least validate syntax without a running RabbitMQ
	if os.Getenv("RABBITMQ_ENDPOINT") == "" {
		t.Log("Skipping terraform plan test because RABBITMQ_ENDPOINT environment variable is not set.")
		t.Log("To run a full test, set RABBITMQ_ENDPOINT, RABBITMQ_USERNAME, and RABBITMQ_PASSWORD environment variables.")
		return
	}

	// If environment variables are available, use them for testing
	if endpoint := os.Getenv("RABBITMQ_ENDPOINT"); endpoint != "" {
		terraformOptions.Vars["rabbitmq_endpoint"] = endpoint
	}
	if username := os.Getenv("RABBITMQ_USERNAME"); username != "" {
		terraformOptions.Vars["rabbitmq_username"] = username
	}
	if password := os.Getenv("RABBITMQ_PASSWORD"); password != "" {
		terraformOptions.Vars["rabbitmq_password"] = password
	}

	// Run terraform plan
	terraform.Plan(t, terraformOptions)
	t.Log("Terraform plan succeeded.")

	// Plan passed, so the test is successful
	assert.True(t, true, "Terraform plan was successful")
}
