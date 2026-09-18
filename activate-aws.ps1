# activate-aws.ps1
# Activates an ISOLATED AWS context for this project, in the CURRENT shell session only.
# It writes nothing global: close the terminal and everything reverts.
#
# Usage:
#   .\activate-aws.ps1
#
# Isolation model: by pointing AWS_CONFIG_FILE / AWS_SHARED_CREDENTIALS_FILE at
# this project's dedicated files, the AWS CLI and Terraform stop reading ~/.aws
# entirely. No other profile or SSO token cache on this machine (e.g. another
# tool's) is visible while this context is active.

# 1. Put the per-user AWS CLI on PATH for this session only.
$awsDir = Join-Path $env:LOCALAPPDATA "Programs\Amazon\AWSCLIV2"
if (Test-Path (Join-Path $awsDir "aws.exe")) {
    if ($env:PATH -notlike "*$awsDir*") { $env:PATH = "$awsDir;$env:PATH" }
} else {
    Write-Warning "aws.exe not found at $awsDir - install the AWS CLI (per-user) first."
}

# 2. Point AWS credential/config resolution at this project's dedicated files,
#    located OUTSIDE the git repository, alongside it (../../aws-watts-up-coach).
$awsHome = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\aws-watts-up-coach"))
$env:AWS_CONFIG_FILE             = Join-Path $awsHome "config"
$env:AWS_SHARED_CREDENTIALS_FILE = Join-Path $awsHome "credentials"
$env:AWS_PROFILE                 = "watts-up-coach"

Write-Host "AWS context 'watts-up-coach' activated for THIS session." -ForegroundColor Green
Write-Host "  AWS_CONFIG_FILE             = $env:AWS_CONFIG_FILE"
Write-Host "  AWS_SHARED_CREDENTIALS_FILE = $env:AWS_SHARED_CREDENTIALS_FILE"
Write-Host "  AWS_PROFILE                 = $env:AWS_PROFILE"
Write-Host ""
Write-Host "Verify with:  aws sts get-caller-identity"
