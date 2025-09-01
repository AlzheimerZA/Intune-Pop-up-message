# Registry path, name, and expected value
$regPath = "HKCU:\Software\eDisclosure"
$regName = "Acknowledged"
$regValueExpected = "Yes"

try {
    if (Test-Path $regPath) {
        $currentValue = (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop).$regName
        if ($currentValue -eq $regValueExpected) {
            # Registry exists and value matches
            Write-Output "Compliant"
            exit 0  # Detection passed
        }
        else {
            # Registry exists but value does not match
            Write-Output "Non-Compliant: Value is '$currentValue'"
            exit 1  # Detection failed
        }
    }
    else {
        # Registry path does not exist
        Write-Output "Non-Compliant: Registry path not found"
        exit 1  # Detection failed
    }
}
catch {
    Write-Output "Non-Compliant: Error accessing registry - $_"
    exit 1  # Detection failed
}
