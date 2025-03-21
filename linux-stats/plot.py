import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# Load CSV file
csv_file = "output/data.csv"  # Replace with your actual file path
df = pd.read_csv(csv_file)

### PHYSICAL LINES OF CODE PER LINUX VERSIONS ###

# Extract x and y values
x_values = df.iloc[:, 0]  # First column as x-axis (categories)
y_values = df.iloc[:, 1]  # Second column as y-axis (integers)

# Create bar plot
plt.figure(figsize=(10, 6))
plt.bar(x_values, y_values, color="skyblue")

# Labels and title
plt.xlabel("Linux versions")
plt.ylabel("Physical LOC (in millions)")
plt.title("Physical Lines of Code (LOC) per Linux versions")

# Format y-axis in millions
plt.gca().yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{int(x/1e6):,}M"))

# Improve x-axis readability
plt.xticks(rotation=45, ha="right")
plt.gca().xaxis.set_major_locator(mticker.MaxNLocator(nbins=10, integer=True))  # Limit number of labels

# Save the plot as PDF
plt.savefig("output/phys-loc.pdf", format="pdf", dpi=300)

# Show the plot
#plt.show()

### NUMBER OF MAINTAINERS PER LINUX VERSIONS ###

# Extract x and y values
x_values = df.iloc[:, 0]  # First column as x-axis (categories)
y_values = df.iloc[:, 2]  # Third column as y-axis (integers)

# Create bar plot
plt.figure(figsize=(10, 6))
plt.bar(x_values, y_values, color="skyblue")

# Labels and title
plt.xlabel("Linux versions")
plt.ylabel("N⁰ Maintainers")
plt.title("Number of Maintainers per Linux versions")

# Improve x-axis readability
plt.xticks(rotation=45, ha="right")
plt.gca().xaxis.set_major_locator(mticker.MaxNLocator(nbins=10, integer=True))  # Limit number of labels

# Save the plot as PDF
plt.savefig("output/maintainers.pdf", format="pdf", dpi=300)

# Show the plot
#plt.show()

### NUMBER OF COMMITS PER LINUX VERSIONS ###

# Extract x and y values
x_values = df.iloc[:, 0]  # First column as x-axis (categories)
y_values = df.iloc[:, 3]  # Third column as y-axis (integers)

# Calculate margin
margin = (max(y_values) - min(y_values)) * 0.1  # 10% extra space

# Create bar plot
plt.figure(figsize=(10, 6))
plt.bar(x_values, y_values, color="skyblue")

# Labels and title
plt.xlabel("Linux versions")
plt.ylabel("Number of Commits (in thousands)")
plt.title("Number of Commits per Linux versions")

# Format y-axis in millions
plt.gca().yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"{x/1e3:.1f}k"))

# Adjust y-axis limits for centering effect
plt.ylim(min(y_values) - margin, max(y_values) + margin)

# Improve x-axis readability
plt.xticks(rotation=45, ha="right")
plt.gca().xaxis.set_major_locator(mticker.MaxNLocator(nbins=10, integer=True))  # Limit number of labels

# Save the plot as PDF
plt.savefig("output/commits.pdf", format="pdf", dpi=300)

# Show the plot
#plt.show()
