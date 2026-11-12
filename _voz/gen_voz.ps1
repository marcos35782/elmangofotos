$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
try {
Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voices = $s.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo }
$voices | ForEach-Object { "$($_.Name) | $($_.Culture) | $($_.Gender)" } | Out-File "$dir\voces.txt" -Encoding utf8
$es = @($voices | Where-Object { $_.Culture.Name -like 'es*' })
$pick = $es | Where-Object { @('es-AR','es-MX','es-US') -contains $_.Culture.Name } | Select-Object -First 1
if (-not $pick) { $pick = $es | Select-Object -First 1 }
if (-not $pick) { "SIN VOZ EN ESPANOL" | Out-File "$dir\resultado.txt" -Encoding utf8; exit }
$s.SelectVoice($pick.Name)
$s.Rate = 1
$lines = @(
"¿Cobraste hace nada y ya no tenés un peso?",
"Escuchá esto.",
"Uno: el cafecito y el alfajor, porque hoy no da.",
"Parece poco, pero todos los días se vuelve un montón.",
"Dos: el delíveri que pedís solo esta vez.",
"Y el costo de envío, que nadie mira.",
"Tres: lo chiquito de la veterinaria.",
"Y se lo contás a El Mango así nomás:",
"Gasté ocho mil quinientos en el antipulgas y un esnac para el perro.",
"Listo, anotado.",
"El Mango llega muy pronto a la Plei Stor.",
"Seguí la cuenta para enterarte cuando salga."
)
$fmt = New-Object System.Speech.AudioFormat.SpeechAudioFormatInfo(44100,[System.Speech.AudioFormat.AudioBitsPerSample]::Sixteen,[System.Speech.AudioFormat.AudioChannel]::Mono)
for ($i=0; $i -lt $lines.Count; $i++) {
  $s.SetOutputToWaveFile(("{0}\v{1:d2}.wav" -f $dir,$i), $fmt)
  $s.Speak($lines[$i])
}
$s.SetOutputToNull(); $s.Dispose()
"OK | $($pick.Name) | $($pick.Culture)" | Out-File "$dir\resultado.txt" -Encoding utf8
} catch { "ERROR: $_" | Out-File "$dir\resultado.txt" -Encoding utf8 }
