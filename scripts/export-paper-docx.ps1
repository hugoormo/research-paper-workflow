[CmdletBinding()]
param(
    [string]$PaperBaseName = "paper_FiBO_SysMLv2",
    [ValidateSet("en", "de", "both")]
    [string]$Language = "both",
    [string]$PaperFolder = "docs/paper-latex",
    [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-Pandoc {
    $cmd = Get-Command pandoc -ErrorAction SilentlyContinue
    if ($null -eq $cmd) {
        $wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\\WinGet\\Packages"
        if (Test-Path $wingetRoot) {
            $candidate = Get-ChildItem -Path $wingetRoot -Recurse -Filter "pandoc.exe" -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if ($null -ne $candidate) {
                return $candidate.FullName
            }
        }
        throw "Pandoc is not installed or not discoverable. Install Pandoc first: https://pandoc.org/installing.html"
    }
    return $cmd.Source
}

function Export-OneDocx {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TexPath,
        [Parameter(Mandatory = $true)]
        [string]$DocxPath,
        [Parameter(Mandatory = $true)]
        [string]$PandocPath
    )

    $texAbs = Resolve-Path $TexPath -ErrorAction Stop
    $texDir = Split-Path -Path $texAbs -Parent

    New-Item -ItemType Directory -Path (Split-Path -Path $DocxPath -Parent) -Force | Out-Null

    # Use the tex file directory as working directory so relative image paths resolve.
    Push-Location $texDir
    try {
        $texName = Split-Path -Path $texAbs -Leaf
        $docxAbs = [System.IO.Path]::GetFullPath((Join-Path $PWD $DocxPath))
        & $PandocPath $texName -o $docxAbs --from=latex --to=docx
    }
    finally {
        Pop-Location
    }
}

$pandoc = Resolve-Pandoc

$targets = @()
if ($Language -eq "both") {
    $targets += "en"
    $targets += "de"
}
else {
    $targets += $Language
}

$failed = @()
foreach ($lang in $targets) {
    $texRel = Join-Path $PaperFolder ("{0}_{1}.tex" -f $PaperBaseName, $lang)
    $docxRel = Join-Path $PaperFolder ("export/{0}_{1}.docx" -f $PaperBaseName, $lang)

    if (-not (Test-Path $texRel)) {
        $msg = "Missing source file: $texRel"
        if ($Strict) {
            throw $msg
        }
        Write-Warning $msg
        $failed += $lang
        continue
    }

    try {
        Export-OneDocx -TexPath $texRel -DocxPath $docxRel -PandocPath $pandoc
        Write-Host ("Exported: {0}" -f $docxRel)
    }
    catch {
        Write-Error ("Failed export for '{0}': {1}" -f $lang, $_.Exception.Message)
        $failed += $lang
    }
}

if ($failed.Count -gt 0) {
    throw ("DOCX export completed with failures: {0}" -f ($failed -join ", "))
}

Write-Host "DOCX export completed successfully."
