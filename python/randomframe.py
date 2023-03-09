import moviepy.editor as mp
import random

# Load the video file
clip = mp.VideoFileClip("video.mp4")

# Define a function to get a random frame
def get_random_frame():
    # Get a random time within the video's duration
    random_time = random.uniform(0, clip.duration)
    # Get the frame at that time
    frame = clip.get_frame(random_time)
    return frame

# Display random frames in a video window
clip.preview(fps=30)