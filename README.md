
# 🎬 **ffmpeg-util - README**

This project provides a **batch script (.bat)** to automate various video editing tasks using **FFmpeg**. The script is useful for video editors who need to process large volumes of videos with common operations such as conversion, trimming, resolution changes, and more.

## 🚀 **How to Use**

1. **Prerequisites:**
   - **FFmpeg** must be installed and accessible via the command line. If you don't have FFmpeg, you can download it [here](https://ffmpeg.org/download.html).
   - Add **FFmpeg** to your system's **PATH** environment variable to run it from any directory.

2. **Download the Script:**
   - Download the **`process_videos.bat`** file.
   - Place the file in a directory with the videos you want to process.

3. **Instructions:**
   - Open the **Command Prompt** on Windows.
   - Navigate to the directory where the script is saved and run it with the command:
     ```
     process_videos.bat
     ```

4. **Choose an Action:**
   - The script will display a menu with various options to process your videos. You can choose the action by typing the corresponding number.

## 🎥 **Available Menu Options**

1. **Convert to MP4**
   Converts videos to MP4 format, using **H.264** encoding for video and **AAC** encoding for audio.

2. **Extract Audio (MP3)**
   Extracts audio from a video and saves it as an **MP3** file.

3. **Render to 1920x1080 (horizontal) [high quality]**
   Resizes the video to **Full HD** resolution (1920x1080) with high quality.

4. **Render to 1080x1920 (vertical) [high quality]**
   Resizes the video to **Full HD** resolution (1080x1920) with high quality for vertical videos.

5. **Merge All Videos (Concatenate)**
   Merges all MP4 videos found in the directory into a single file.

6. **Render to 3840x2160 (4K horizontal) [maximum quality]**
   Resizes the video to **4K** (3840x2160) with maximum quality.

7. **Render to 2160x3840 (4K vertical) [maximum quality]**
   Resizes the video to **4K** (2160x3840) with maximum quality for vertical videos.

8. **Mute All Videos (remove audio)**
   Removes the audio from all videos in the directory, keeping only the video.

9. **Trim Video (from X to Y)**
   Trims the video, keeping only the segment between the defined start and end times (e.g., from 00:00:10 to 00:01:00).

10. **Remove Audio (keep only video)**
   Removes the audio from a video, keeping only the visual part.

11. **Remove Video (keep only audio)**
   Extracts only the audio from a video, without the visual part.

12. **Convert to ProRes (MOV)**
   Converts the video to the **ProRes** format (ideal for professional editing), with a **.mov** extension.

13. **Change FPS (Frames per Second)**
   Changes the FPS of the video (ideal for slow-motion cameras or adapting to different frame rates).

14. **Create Timelapse from PNG Images**
   Creates a video from sequential PNG images (e.g., frame_0001.png, frame_0002.png, etc.), useful for timelapse.

15. **Adjust Color (Brightness/Contrast/Saturation)**
   Adjusts the color of the video by modifying brightness, contrast, and saturation.

16. **Add Logo to Lower Right Corner**
   Adds a logo image to the lower right corner of the video.

17. **Add Background Music to Video**
   Adds background music to the video, mixing the audio of the video with the provided music.

18. **Create GIF from Video Clip**
   Creates an animated **GIF** from a video clip, with customizable duration.

## 🛠️ **Example Usage**

1. **Trimming a video**:
   - When choosing option **9**, the script will ask for the start and end times of the trim. Example:
     ```
     Enter the start time (e.g., 00:00:10): 00:00:10
     Enter the end time (e.g., 00:01:00): 00:01:00
     ```

2. **Adding a logo**:
   - When choosing option **16**, the script will ask for the logo file to be added. Example:
     ```
     Enter the logo file name (e.g., logo.png): logo.png
     ```

---

## 🔧 **Customization and Extensions**

- You can easily **add new options** or modify existing ones in the **.bat** script.
- **Quality parameters** like `-crf`, `-preset`, and `-b:a` are adjustable according to your quality/speed preferences.
- FFmpeg offers many advanced options, such as **video compression**, **H.265/HEVC encoding**, **filtering**, and much more.

## ⚠️ **Warnings**

- This script is designed to work with **MP4, AVI, MOV, and MKV** videos.
- Make sure **FFmpeg** is properly set up on your system to avoid errors.

## 📄 **License**

This project is distributed under the **MIT** license.
