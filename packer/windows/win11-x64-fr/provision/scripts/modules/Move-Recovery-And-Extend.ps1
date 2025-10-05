# ------------------------------------------------------------
# Script : Move-Recovery-And-Extend.ps1
# Purpose: Reposition Recovery partition, extend C:, reactivate WinRE
# Usage  : Run after installation, as administrator
# ------------------------------------------------------------

# 1) Disable WinRE
try {
    Write-Host "Disabling WinRE..."
    reagentc /disable | Out-Null
} catch {
    Write-Warning "Unable to disable WinRE: $_"
}

# 2) Identify disk 0 (assumes we operate on the system disk)
$disk = Get-Disk -Number 0
if (-not $disk) {
    Write-Error "Disk 0 not found."
    exit 1
}

# 3) Identify Recovery partition (special GPT GUID type) if any
$recPart = Get-Partition -DiskNumber 0 | Where-Object {
    $_.GptType -eq '{de94bba4-06d1-4d40-a16a-bfd50179d6ac}'
}
if ($recPart) {
    Write-Host "Recovery partition found: partition #$($recPart.PartitionNumber)"
    # Delete it
    try {
        Remove-Partition -DiskNumber 0 -PartitionNumber $recPart.PartitionNumber -Confirm:$false
        Write-Host "Recovery partition deleted."
    } catch {
        Write-Warning "Unable to delete Recovery partition: $_"
        # Continue if error is not fatal
    }
} else {
    Write-Host "No Recovery partition detected. Nothing to delete."
}

# 4) Extend C: partition to all contiguous free space
$volC = Get-Volume -DriveLetter C
if (-not $volC) {
    Write-Error "Unable to find volume C:."
    exit 1
}
$partC = Get-Partition -DiskNumber 0 | Where-Object { $_.DriveLetter -eq 'C' }
if (-not $partC) {
    Write-Error "Unable to find partition corresponding to C:."
    exit 1
}

# Get maximum supported size
$sizes = Get-PartitionSupportedSize -DriveLetter C
if ($sizes.SizeMax -gt $volC.Size) {
    Write-Host "Extending C: to maximum size $($sizes.SizeMax) bytes..."
    try {
        Resize-Partition -DriveLetter C -Size $sizes.SizeMax
        Write-Host "Partition C: extended."
    } catch {
        Write-Warning "Failed to extend C: $_"
    }
} else {
    Write-Host "No extension possible. Missing or non-contiguous unallocated space."
}

# 5) Recreate Recovery partition at end of disk
# Use all remaining space for Recovery, then format and reactivate

# Calculate remaining free space on disk
$free = $disk | Get-Disk | Select-Object -ExpandProperty LargestFreeExtent
if ($free -ge 10MB) {
    Write-Host "Creating Recovery partition in remaining free space..."
    $newPart = New-Partition -DiskNumber 0 -UseMaximumSize -AssignDriveLetter `
        | ? { $_.GptType -eq 'Basic' }   # retrieve newly assigned partition
    if ($newPart) {
        # Format as NTFS, without drive letter (hide it afterwards)
        Format-Volume -Partition $newPart -FileSystem NTFS -AllocationUnitSize 4096 -Confirm:$false | Out-Null
        # For GPT, set Recovery GUID and attributes
        $pid = "de94bba4-06d1-4d40-a16a-bfd50179d6ac"
        try {
            $newPart | Set-Partition -GptType $pid
            # Hide/remove drive letter (optional)
            Remove-PartitionAccessPath -DiskNumber 0 -PartitionNumber $newPart.PartitionNumber -AccessPath ($newPart.DriveLetter + ":\")
            # Set required partition attributes
            Set-Partition -DiskNumber 0 -PartitionNumber $newPart.PartitionNumber -IsHidden $true
        } catch {
            Write-Warning "Unable to configure new Recovery partition: $_"
        }
        Write-Host "Recovery partition recreated (partition #$($newPart.PartitionNumber))."
    } else {
        Write-Warning "Unable to create new Recovery partition."
    }
} else {
    Write-Host "No free space to create Recovery partition."
}

# 6) Reactivate WinRE
try {
    Write-Host "Reactivating WinRE..."
    reagentc /enable | Out-Null
    Write-Host "WinRE enabled."
} catch {
    Write-Warning "Unable to reactivate WinRE: $_"
}

Write-Host "Move-Recovery-And-Extend script complete."