# PowerShell test script for AuDHD LifeCoach Infrastructure

# Colors for output
$Red = 'Red'
$Green = 'Green'
$Yellow = 'Yellow'
$Default = 'White'

Write-Host "Running Terraform tests for AuDHD LifeCoach Infrastructure" -ForegroundColor $Yellow

# Test root module syntax
Write-Host "`nTesting root module syntax..." -ForegroundColor $Yellow
try {
    Set-Location -Path "C:\Users\Izzy\PycharmProjects\AuDHD-LIfeCoach-Infrastructure"
    terraform validate
    Write-Host "Root module syntax validation passed!" -ForegroundColor $Green
}
catch {
    Write-Host "Root module validation failed!" -ForegroundColor $Red
    exit 1
}

# Check if we can run the terraform plan with a RabbitMQ server
if ($env:RABBITMQ_ENDPOINT -and $env:RABBITMQ_USERNAME -and $env:RABBITMQ_PASSWORD) {
    Write-Host "`nRunning terraform plan with RabbitMQ server..." -ForegroundColor $Yellow
    try {
        Set-Location -Path "C:\Users\Izzy\PycharmProjects\AuDHD-LIfeCoach-Infrastructure"
        terraform init
        terraform plan `
            -var "rabbitmq_endpoint=$env:RABBITMQ_ENDPOINT" `
            -var "rabbitmq_username=$env:RABBITMQ_USERNAME" `
            -var "rabbitmq_password=$env:RABBITMQ_PASSWORD"
        Write-Host "Terraform plan succeeded!" -ForegroundColor $Green
    }
    catch {
        Write-Host "Terraform plan failed!" -ForegroundColor $Red
        exit 1
    }
}
else {
    Write-Host "`nSkipping terraform plan because RabbitMQ credentials are not available." -ForegroundColor $Yellow
    Write-Host "To run a full test, set RABBITMQ_ENDPOINT, RABBITMQ_USERNAME, and RABBITMQ_PASSWORD environment variables." -ForegroundColor $Yellow
}

# Navigate to the test directory
Set-Location -Path "C:\Users\Izzy\PycharmProjects\AuDHD-LIfeCoach-Infrastructure\test"

# Run Terratest tests
Write-Host "`nRunning Terratest for RabbitMQ configuration..." -ForegroundColor $Yellow
try {
    go test -v -timeout 30m
    Write-Host "Terratest tests passed!" -ForegroundColor $Green
}
catch {
    Write-Host "Terratest tests failed!" -ForegroundColor $Red
    exit 1
}

Write-Host "`nAll tests passed!" -ForegroundColor $Green

# Return to the root directory
Set-Location -Path "C:\Users\Izzy\PycharmProjects\AuDHD-LIfeCoach-Infrastructure"