import matplotlib.pyplot as plt
import numpy as np
import time
import math
import serial

num_states = 32  # Number of states
max_distance = 100  # Maximum distance your sensor can measure
scan_speed = np.pi / num_states
scan_width = 0

# Initialize distances array
distances = []


def update_plot(ax, distances, scan_angle):
    ax.clear()
    ax.set_theta_zero_location('N')
    ax.set_theta_direction(-1)
    
    # Generate evenly spaced angles
    angles = np.linspace(0, 2 * np.pi, num_states, endpoint=False)
    
    # Convert angles and distances to numpy arrays
    angles = np.array(angles)
    distances = np.array(distances)
    
    # Adjust the length of distances to match the length of angles
    if len(distances) < len(angles):
        distances = np.concatenate([distances, [max_distance] * (len(angles) - len(distances))])
    
    # Plot distances within the current scan angle
    ax.scatter(angles[(angles <= scan_angle)], distances[(angles <= scan_angle)])
    #ax.fill(angles[(angles <= scan_angle)], distances[(angles <= scan_angle)], 'b', alpha=0.1)
    
    # Plot scanning line
    ax.plot([scan_angle, scan_angle], [0, max_distance], 'r--')  # Scan line in red
    
    ax.set_ylim(0, max_distance)  # Adjust this based on your sensor's range
    ax.set_yticks(np.arange(0, max_distance, 10))  # Adjust based on sensor range
    ax.grid(True)
    plt.pause(0.01)

# Function to read data from UART
def read_uart(ser):
    # Read data from UART
    try:
        data = ser.readline().decode().strip()
        return float(data)/10  # Assuming data is a single float number
    except Exception as e:
        print("Error reading UART:", e)
        return None

# Main function
def main():

    global distances
    # Initialize plot
    fig = plt.figure()
    ax = fig.add_subplot(111, polar=True)
    ax.set_theta_zero_location('N')
    ax.set_theta_direction(-1)
    ax.set_ylim(0, max_distance)
    ax.set_yticks(np.arange(0, max_distance, 10))
    ax.grid(True)
    
    # Open plot window
    plt.show(block=False)
    
    # Initialize scan angle
    scan_angle = 0
    global scan_width

    # Open serial connection
    try:
        ser = serial.Serial('/dev/cu.usbmodem101', 9600)  # Replace 'COM3' with your Arduino's port
    except serial.SerialException as e:
        print("Error opening serial port:", e)
        return  # Exit the pr
    try:
        while True:
            # Read data from UART
            new_distance = read_uart(ser)
            if new_distance is not None:
                # Update scan angle and plot
                scan_angle += scan_speed * 2
                if scan_angle >= 2 * np.pi:
                    scan_angle = 0
                    distances = []
                distances = np.append(distances, new_distance)
                update_plot(ax, distances, scan_angle)
                
            plt.pause(0.01)
    except KeyboardInterrupt:
        ser.close()  # Close serial connection


if __name__ == "__main__":
    main()
