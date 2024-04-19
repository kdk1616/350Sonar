import matplotlib.pyplot as plt
import numpy as np
import time
import math

num_states = 32  # Number of states
max_distance = 100  # Maximum distance your sensor can measure
scan_speed = 2 * np.pi / num_states
scan_width = 0

dist = [70, 12, 48, 90, 63, 37, 82, 24, 51, 5, 92, 19, 73, 60, 84, 44, 95, 27, 11, 68, 39, 71, 8, 33, 56, 16, 88, 2, 47, 67, 3, 78]
# Function to update radar plot with scanning line
# Function to update radar plot with scanning line
def update_plot(ax, distances, scan_angle):
    ax.clear()
    ax.set_theta_zero_location('N')
    ax.set_theta_direction(-1)
    
    # Number of states
    #num_states = len(distances)

    # Generate evenly spaced angles
    angles = np.linspace(0, 2 * np.pi, num_states, endpoint=False)
    
    # Convert angles and distances to numpy arrays
    angles = np.array(angles)
    distances = np.array(distances)
    
    # Plot distances within the current scan angle
    ax.plot(angles[(angles <= scan_angle)], distances[(angles <= scan_angle)])
    ax.fill(angles[(angles <= scan_angle)], distances[(angles <= scan_angle)], 'b', alpha=0.1)
    
    # Plot scanning line
    ax.plot([scan_angle, scan_angle], [0, max_distance], 'r--')  # Scan line in red
    
    ax.set_ylim(0, max_distance)  # Adjust this based on your sensor's range
    ax.set_yticks(np.arange(0, max_distance, 10))  # Adjust based on sensor range
    ax.grid(True)
    plt.pause(0.01)

    
# Function to simulate getting distances from the sensor
def get_distances(num_states):
    # Simulate getting distances from the sensor
    # Replace this with actual sensor readings
    return dist
    
    
    
    
# Main function
def main():
    # Initialize plot
    fig = plt.figure()
    ax = fig.add_subplot(111, polar=True)

    # Initialize angles for each state
    angles = np.linspace(0, 2 * np.pi, num_states, endpoint=False)
    
    # Initialize scan angle
    scan_angle = 0
    global scan_width


    while True:
        distances = get_distances(num_states)
        scan_width += scan_speed

        # Update plot with new distances and scan line
        update_plot(ax, distances, scan_angle)

        # Rotate the angles for next iteration (clockwise)
#        angles = np.roll(angles, 1)

        # Increment scan angle
        scan_angle += scan_speed*2
        
        # Clear scan angle if it exceeds 2*pi
        if scan_angle >= 2 * np.pi:
            scan_angle = 0
        
        time.sleep(0.5)  # Adjust this delay as needed depending on your motor speed

if __name__ == "__main__":
    main()
