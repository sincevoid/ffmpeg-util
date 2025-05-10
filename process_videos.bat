@echo off
echo Welcome to the FFmpeg Video Processor
echo --------------------------------------

:: Prompt user for action
echo Choose an action:
echo 1. Convert videos to MP4
echo 2. Extract audio (MP3)
echo 3. Render to 1920x1080 (horizontal) [high quality]
echo 4. Render to 1080x1920 (vertical) [high quality]
echo 5. Merge all videos
echo 6. Render to 3840x2160 (4K horizontal) [maximum quality]
echo 7. Render to 2160x3840 (4K vertical) [maximum quality]
echo 8. Mute all videos (remove audio)
echo 9. Trim video (from X to Y)
echo 10. Remove audio (keep only video)
echo 11. Remove video (keep only audio)
echo 12. Convert to ProRes (MOV)
echo 13. Change FPS (Frames per second)
echo 14. Create Timelapse from PNG images
echo 15. Adjust color (brightness/contrast/saturation)
echo 16. Add logo to lower-right corner
echo 17. Add background music to video
echo 18. Create GIF from video clip

set /p choice="Enter your choice (1-18): "

:: Process based on user input
if "%choice%"=="1" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k "%%~nF_converted.mp4"
        echo Converted "%%F" to MP4.
    )
)

if "%choice%"=="2" (
    set /p filename="Enter video file name to extract audio from (e.g., video.mp4): "
    ffmpeg -i "%filename%" -vn -acodec libmp3lame -ar 44100 -ac 2 -ab 192k "%filename%.mp3"
    echo Extracted audio from "%filename%" to MP3.
)

if "%choice%"=="3" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -vf "scale=1920:1080" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k "%%~nF_1920x1080.mp4"
        echo Rendered "%%F" to 1920x1080.
    )
)

if "%choice%"=="4" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -vf "scale=1080:1920" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k "%%~nF_1080x1920.mp4"
        echo Rendered "%%F" to 1080x1920.
    )
)

if "%choice%"=="5" (
    echo Merging all MP4 videos in the directory...
    echo file '%%F' > filelist.txt
    for %%F in (*.mp4) do (
        echo file '%%F' >> filelist.txt
    )
    ffmpeg -f concat -safe 0 -i filelist.txt -c copy output_merged.mp4
    echo Merged all MP4 videos into output_merged.mp4.
)

if "%choice%"=="6" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -vf "scale=3840:2160" -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "%%~nF_4K.mp4"
        echo Rendered "%%F" to 4K (3840x2160).
    )
)

if "%choice%"=="7" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -vf "scale=2160:3840" -c:v libx264 -crf 18 -preset slow -c:a aac -b:a 192k "%%~nF_4K_vertical.mp4"
        echo Rendered "%%F" to 4K vertical (2160x3840).
    )
)

if "%choice%"=="8" (
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -an "%%~nF_muted.mp4"
        echo Removed audio from "%%F".
    )
)

if "%choice%"=="9" (
    set /p starttime="Enter start time (e.g., 00:00:10): "
    set /p endtime="Enter end time (e.g., 00:01:00): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -ss %starttime% -to %endtime% -c:v libx264 -c:a aac -b:a 192k "%%~nF_trimmed.mp4"
        echo Trimmed "%%F" from %starttime% to %endtime%.
    )
)

if "%choice%"=="10" (
    set /p filename="Enter video file to remove audio (e.g., video.mp4): "
    ffmpeg -i "%filename%" -an "%filename%_noaudio.mp4"
    echo Removed audio from "%filename%".
)

if "%choice%"=="11" (
    set /p filename="Enter video file to remove video (e.g., video.mp4): "
    ffmpeg -i "%filename%" -vn "%filename%_audio_only.mp3"
    echo Removed video from "%filename%", keeping audio only.
)

if "%choice%"=="12" (
    set /p filename="Enter video file to convert to ProRes (e.g., video.mp4): "
    ffmpeg -i "%filename%" -c:v prores_ks -profile:v 3 -c:a pcm_s16le "%filename%.mov"
    echo Converted "%filename%" to ProRes (MOV).
)

if "%choice%"=="13" (
    set /p fps="Enter the new FPS (e.g., 30): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -r %fps% "%%~nF_%fps%fps.mp4"
        echo Changed FPS of "%%F" to %fps%.
    )
)

if "%choice%"=="14" (
    set /p input_folder="Enter the folder containing PNG images: "
    ffmpeg -framerate 30 -i "%input_folder%\frame_%04d.png" -c:v libx264 -pix_fmt yuv420p output_timelapse.mp4
    echo Created timelapse from PNG images in "%input_folder%" to output_timelapse.mp4.
)

if "%choice%"=="15" (
    set /p brightness="Enter brightness value (-1.0 to 1.0): "
    set /p contrast="Enter contrast value (0.0 to 2.0): "
    set /p saturation="Enter saturation value (0.0 to 2.0): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -vf "eq=brightness=%brightness%:contrast=%contrast%:saturation=%saturation%" "%%~nF_colored.mp4"
        echo Adjusted color of "%%F".
    )
)

if "%choice%"=="16" (
    set /p logo="Enter the logo file name (e.g., logo.png): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -i "%logo%" -filter_complex "overlay=W-w-10:H-h-10" "%%~nF_with_logo.mp4"
        echo Added logo to "%%F".
    )
)

if "%choice%"=="17" (
    set /p audio="Enter the audio file name (e.g., background.mp3): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -i "%audio%" -c:v copy -c:a aac -b:a 192k "%%~nF_with_audio.mp4"
        echo Added background audio to "%%F".
    )
)

if "%choice%"=="18" (
    set /p starttime="Enter start time for GIF (e.g., 00:00:10): "
    set /p duration="Enter GIF duration (e.g., 5 seconds): "
    for %%F in (*.mp4 *.avi *.mov *.mkv) do (
        ffmpeg -i "%%F" -ss %starttime% -t %duration% -vf "fps=10,scale=320:-1:flags=lanczos" -c:v gif "%%~nF.gif"
        echo Created GIF from "%F".
    )
)

echo Done processing the videos.
pause
