Param (
    [string]$gitUser, 
    [string]$gitEmail,
	[string]$gitMessage
)

Write-Host "Start build version..."
$branchNameParts = $env:BUILD_SOURCEBRANCHNAME -split "#"
$buildVersion = $branchNameParts[1] + "-" + $branchNameParts[0]
Write-Host "Build Version: " $buildVersion

$tags = @(git tag -l --sort=version:refname $buildVersion*)
Write-Host "Latest Tag: " $tags

If ($tags.Length -gt 0)
{
	$latestTag = $tags[$tags.Length - 1]
	$tagParts = $latestTag -split $branchNameParts[0]
	
	$versionNumber = ([int]$tagParts[1]) + 1
	$buildVersion = $buildVersion + $versionNumber
	Write-Host "Update Version: " $buildVersion
}
Else
{
	$buildVersion = $buildVersion + 1
	Write-Host "New Version: " $buildVersion
}

Write-Host "Git tagging"
git config --global user.email $gitEmail
git config --global user.name $gitUser
git tag -a $buildVersion -m $gitMessage
git push origin $buildVersion -q

Write-Host "Final Version: $buildVersion"
Write-Host "##vso[task.setvariable variable=BuildNewVersion;]$buildVersion"
Write-Host "##vso[build.updatebuildnumber]$buildVersion"
