Param(
  [string]$BaseUrl = "http://localhost:8080",
  [int]$GetIterations = 8
)

Write-Host "== Health check =="
Invoke-RestMethod -Method GET -Uri "$BaseUrl/health" | ConvertTo-Json -Depth 6

Write-Host "`n== Create product (write to master) =="
$body = @{
  name = "Keyboard-" + (Get-Date -Format "HHmmss")
  price = 199.99
} | ConvertTo-Json
Invoke-RestMethod -Method POST -Uri "$BaseUrl/products" -ContentType "application/json" -Body $body | ConvertTo-Json -Depth 6

Write-Host "`n== Read products from slave through load balancer =="
for ($i = 1; $i -le $GetIterations; $i++) {
  $result = Invoke-RestMethod -Method GET -Uri "$BaseUrl/products"
  Write-Host ("Request #{0} processed_by={1}, count={2}" -f $i, $result.processed_by, $result.count)
  Start-Sleep -Milliseconds 400
}

Write-Host "`nVerification run complete."
