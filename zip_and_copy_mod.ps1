# Name and version of your mod
$mod = "more-enemies"
$version = "0.6.0"

$versioned_mod = $mod + "_" + $version

# Path to your mod
# $dev_path = "G:/Factorio/Mods/dev/" + $mod
$dev_path = "D:/mods/_dev/Factorio/" + $mod

# Default path to Factorio mods
$destination = $env:APPDATA + "/Factorio/mods/"

$zip = ".zip"

$dev_full = $dev_path + "/" + $mod
$dev_full_versioned = $dev_full + "_" + $version

# Delete the old .zip file from the dev directory
Write-Output ("Deleteing " + ($dev_full_versioned + $zip))
del ($dev_full_versioned + $zip)

# Zip the contents of the mod folder
Write-Output ("Zipping " + ($dev_full + "/") + " to " + ($dev_full_versioned + $zip))
Compress-Archive ($dev_full + "/") ($dev_full_versioned + $zip)

# Delete the old .zip file from the Factorio/mods folder
Write-Output ("Deleteing " + ($destination + $versioned_mod + $zip))
del ($destination + $versioned_mod + $zip)

# Copy the .zip from the dev folder to the Factorio/mods folder
Write-Output ("Copying " + ($dev_full_versioned + $zip) + " to " + $destination)
Copy-Item ($dev_full_versioned + $zip) -Destination $destination