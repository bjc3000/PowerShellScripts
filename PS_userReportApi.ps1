﻿# Stale Accounts Script V2

# Get all AD Users into a variable and change the dates from int64 
$staleAccounts = Get-ADUser -Filter * -Properties PasswordLastSet,LastLogon |
Select-Object -Property Name, DisplayName,
@{N = "pwdlastset"; E = {[DateTime]::FromFileTime($_.pwdlastset)}},
@{N = "AccountExpires"; E = {[DateTime]::FromFileTime($_.AccountExpires)}},
@{N = "LastLogon"; E = {[DateTime]::FromFileTime($_.LastLogon)}}

# Convert the results to JSON 
$param = $staleAccounts | ConvertTo-Json

# Get the Local Domain Name
$SvrDomain = Get-AdDomain
$domainName = $SvrDomain.infrastructureMaster

# Build out API
$mainUri = "https://atlas.iptelco.com.au/api/2a4440f45471a6990f939cbcff6a03bb/"
$apiUri = "$mainUri$domainName"

# Send Results out
Invoke-WebRequest -Uri $apiUri -Method POST -Body $param