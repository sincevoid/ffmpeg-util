@echo off
setlocal EnableDelayedExpansion

:: Menu de ações
echo =======================================================
echo    Selecione a acao a executar:
echo =======================================================
echo 1 - Converter para MP4
echo 2 - Extrair audio (MP3)
echo 3 - Renderizar para 1920x1080 (horizontal) [alta qualidade]
echo 4 - Renderizar para 1080x1920 (vertical) [alta qualidade]
echo 5 - Juntar todos os videos (concatenar)
echo 6 - Renderizar para 3840x2160 (4K horizontal) [qualidade maxima]
echo 7 - Renderizar para 2160x3840 (4K vertical) [qualidade maxima]
echo 8 - Silenciar todos os videos (remover audio)
echo 9 - Cortar trecho de video (de X até Y)
echo 10 - Remover audio (manter apenas video)
echo 11 - Remover video (manter apenas audio)
echo 12 - Converter para formato ProRes (MOV)
echo 13 - Alterar FPS do video
echo 14 - Criar timelapse a partir de imagens PNG
echo 15 - Ajustar cor (brilho/contraste/saturação)
echo 16 - Adicionar logotipo no canto inferior direito
echo 17 - Adicionar música de fundo ao vídeo
echo 18 - Criar GIF a partir de trecho
echo =======================================================
set /p opcao="Digite o numero da acao desejada: "

:: Cria pasta de saída
set "saida=processados"
if not exist "%saida%" mkdir "%saida%"

if "%opcao%"=="5" (
    echo Preparando lista para concatenacao...
    set "list_file=concat_list.txt"
    > "%list_file%" (
        for %%V in (*.mp4) do echo file '%%V'
    )
    echo Juntando todos os arquivos .mp4...
    ffmpeg -f concat -safe 0 -i "%list_file%" -c copy "%saida%\videos_juntos.mp4"
    del "%list_file%"
    goto :fim
)

if "%opcao%"=="9" (
    set /p inicio="Digite o tempo inicial (ex: 00:00:10): "
    set /p fim="Digite o tempo final (ex: 00:00:30): "
)

if "%opcao%"=="13" (
    set /p novo_fps="Digite o novo FPS (ex: 30): "
)

if "%opcao%"=="15" (
    set /p brilho="Brilho (-1.0 a 1.0): "
    set /p contraste="Contraste (0.5 a 2.0): "
    set /p saturacao="Saturacao (0.0 a 3.0): "
)

if "%opcao%"=="16" (
    set /p logo="Digite o nome do arquivo de logo (ex: logo.png): "
)

if "%opcao%"=="17" (
    set /p musica="Digite o nome do arquivo de musica (ex: musica.mp3): "
)

if "%opcao%"=="18" (
    set /p gif_inicio="Tempo inicial (ex: 00:00:05): "
    set /p gif_duracao="Duracao em segundos (ex: 3): "
)

for %%F in (*.mp4 *.avi *.mov *.mkv) do (
    set "arquivo=%%~nF"
    set "extensao=%%~xF"

    if "%opcao%"=="1" (
        ffmpeg -i "%%F" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 128k "%saida%\!arquivo!.mp4"
    ) else if "%opcao%"=="2" (
        ffmpeg -i "%%F" -q:a 0 -map a "%saida%\!arquivo!.mp3"
    ) else if "%opcao%"=="3" (
        ffmpeg -i "%%F" -vf scale=1920:1080 -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "%saida%\!arquivo!_1080p!extensao!"
    ) else if "%opcao%"=="4" (
        ffmpeg -i "%%F" -vf scale=1080:1920 -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "%saida%\!arquivo!_vertical1080p!extensao!"
    ) else if "%opcao%"=="6" (
        ffmpeg -i "%%F" -vf scale=3840:2160 -c:v libx264 -crf 15 -preset veryslow -c:a aac -b:a 320k "%saida%\!arquivo!_4K!extensao!"
    ) else if "%opcao%"=="7" (
        ffmpeg -i "%%F" -vf scale=2160:3840 -c:v libx264 -crf 15 -preset veryslow -c:a aac -b:a 320k "%saida%\!arquivo!_4Kvertical!extensao!"
    ) else if "%opcao%"=="8" (
        ffmpeg -i "%%F" -c:v libx264 -crf 18 -preset fast -an "%saida%\!arquivo!_sem_audio!extensao!"
    ) else if "%opcao%"=="9" (
        ffmpeg -i "%%F" -ss %inicio% -to %fim% -c copy "%saida%\!arquivo!_corte!extensao!"
    ) else if "%opcao%"=="10" (
        ffmpeg -i "%%F" -an -c:v copy "%saida%\!arquivo!_somente_video!extensao!"
    ) else if "%opcao%"=="11" (
        ffmpeg -i "%%F" -vn -acodec copy "%saida%\!arquivo!_somente_audio.aac"
    ) else if "%opcao%"=="12" (
        ffmpeg -i "%%F" -c:v prores_ks -profile:v 3 -c:a copy "%saida%\!arquivo!_prores.mov"
    ) else if "%opcao%"=="13" (
        ffmpeg -i "%%F" -filter:v "fps=%novo_fps%" "%saida%\!arquivo!_%novo_fps!fps!extensao!"
    ) else if "%opcao%"=="15" (
        ffmpeg -i "%%F" -vf eq=brightness=%brilho%:contrast=%contraste%:saturation=%saturacao% -c:a copy "%saida%\!arquivo!_cor!extensao!"
    ) else if "%opcao%"=="16" (
        ffmpeg -i "%%F" -i "%logo%" -filter_complex "overlay=W-w-10:H-h-10" "%saida%\!arquivo!_logo!extensao!"
    ) else if "%opcao%"=="17" (
        ffmpeg -i "%%F" -i "%musica%" -filter_complex "[0:a][1:a]amix=inputs=2:duration=first" -c:v copy "%saida%\!arquivo!_com_musica!extensao!"
    )
)

:: GIF separado por padrão (só 1 de cada vez)
if "%opcao%"=="18" (
    for %%F in (*.mp4 *.mov *.avi) do (
        set "arquivo=%%~nF"
        ffmpeg -i "%%F" -ss %gif_inicio% -t %gif_duracao% -vf "fps=15,scale=480:-1" "%saida%\!arquivo!.gif"
    )
)

:fim
echo.
echo Processamento concluido. Arquivos salvos em "%saida%".
pause
