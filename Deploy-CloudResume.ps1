function Deploy_Cloud {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Validateset('apply','destroy')]
        [string]$action,

        [ValidateScript({Test-Path $_})]
        [string]$path=(get-item .).fullname
    )

    function Deploy_Terraform {
        param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Backend','Front')]    
        [string]$Directory,
        $action,$Path
        )
        
        $path = Join-Path -Path $path -ChildPath ".\Env\Prod\$Directory"
        Set-Location -Path $path

        try {
            terraform $action --auto-approve    
        while (Get-Process -Name terraform -ErrorAction SilentlyContinue) {
            Start-Sleep -Seconds 5
        }
        }
        catch {
            throw "Terraform showed an Error"
        }
    }

    function Update_JSFile{
        try {
            $jsPath = Join-Path -Path $Path -ChildPath "assets\interactive.js"
            $content = Get-Content -Path $jsPath -Raw
            $currentUrl = ($content | Select-String -Pattern '\s*"([^"]+)"').Matches.Groups[1].Value
            $newUrl = terraform output -raw invoke_url
            $content -replace $currentUrl, $newUrl | Set-Content -Path $jsPath
        }
        catch {
            throw "The $path your provided doesn't contain assets directory, make sure you set your path to CRM"
        }
    }

    switch ($action) {
        "destroy" {
            $action="destroy" 
        }
        "apply" {
            $action = "apply"
        }
        Default {throw "Unknow Option"}
    }

    Deploy_Terraform -Path $path -Directory Backend -action $action

    if(-not ($action -eq 'destroy')){
        Update_JSFile
    }

    Deploy_Terraform -Path $path -Directory Front -action $action

    if($action -eq 'apply'){
        $website_url = terraform output -raw name
        return "[*] Your website is ready and here is the url: $website_url"
    }else {
        return "[*] Your Resources have been succesfully deleted."
    }
    
}