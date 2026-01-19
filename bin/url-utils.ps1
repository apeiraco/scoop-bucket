function Get-RedirectedUrl {
    param (
        [Parameter(Mandatory = $true)]
        [string]$url
    )
    $request = [System.Net.HttpWebRequest]::Create($url)
    $request.AllowAutoRedirect = $false
    $response = $request.GetResponse()
    $location = $response.Headers['Location']
    $response.Close()
    return $location
}
