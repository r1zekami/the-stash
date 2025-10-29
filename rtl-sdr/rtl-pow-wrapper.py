import subprocess
import os
import datetime

now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
log_filename = f"output_{now}.csv"
parsed_filename = f"output_{now}.parsed.csv"
logs_dir = "rtl-sdr-logs"
parsed_path = os.path.join(logs_dir, parsed_filename)

args = ["-f", "24M:1700M:100k", "-g", "25", "-i", "10", "-1", log_filename]
command = ["rtl_power"] + args

def parse_csv_no_header(input_file, output_file):
    """
    Parses rtl_power CSV file and saves the result without a header.
    Args:
        input_file (str): Path to the input CSV file.
        output_file (str): Path to the output file.
    """
    parsed_data = []
    with open(input_file, mode='r', encoding='utf-8') as file:
        import csv
        reader = csv.reader(file)
        for row in reader:
            if not row or len(row) < 7:
                continue
            date_str = row[0].strip()
            timestamp_str = row[1].strip()
            hz_low, hz_max, hz_step = float(row[2]), float(row[3]), float(row[4])
            steps = int((hz_max - hz_low) / hz_step)
            for i in range(steps):
                freq = hz_low + i * hz_step
                value = row[6+i]
                parsed_data.append(f"{date_str}, {timestamp_str}, {freq}, {value}")
    with open(output_file, mode='w', encoding='utf-8', newline='') as file:
        for data_line in parsed_data:
            file.write(data_line + '\n')

try:
    if not os.path.exists(logs_dir):
        try:
            os.makedirs(logs_dir)
        except Exception as e:
            print(f"Could not create directory {logs_dir}: {e}")
            parsed_path = parsed_filename  # fallback to current dir
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if process.stdout:
        for line in process.stdout:
            print(line, end='')
    process.wait()
    print(f"rtl_power  {process.returncode}")
    parse_csv_no_header(log_filename, parsed_path)
    try:
        os.remove(log_filename)
    except Exception as e:
        print(f"Something went wrong while removing {log_filename}: {e}")
    
except Exception as e:
    print(f"Error: {e}")
