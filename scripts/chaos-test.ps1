Param(
  [string]$BaseUrl = "http://localhost:8080"
)

Write-Host "Stopping api-node-1 to simulate single-node failure..."
docker compose stop api-node-1

Write-Host "`nSending repeated GET requests via load balancer..."
for ($i = 1; $i -le 6; $i++) {
  try {
    $result = Invoke-RestMethod -Method GET -Uri "$BaseUrl/products"
    Write-Host ("Request #{0} SUCCESS processed_by={1}" -f $i, $result.processed_by)
  } catch {
    Write-Host ("Request #{0} FAILED: {1}" -f $i, $_.Exception.Message)
  }
  Start-Sleep -Milliseconds 500
}

Write-Host "`nRestarting api-node-1..."
docker compose start api-node-1

Write-Host "Chaos test complete."
