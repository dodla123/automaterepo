from flask import Flask, render_template
from datetime import datetime
import os 
from flask import jsonify
import psycopg2

app = Flask(__name__)
base_dir = os.path.abspath(os.path.dirname(__file__))

db_params = {
    'host': 'localhost',
    'database': 'esic',
    'user': 'postgres',
    'password': 'flexydial',
}




# Function to insert file details into the database
def insert_file_details(file_details):
    try:
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()

        # Insert the file details into the database
        cursor.execute(
            "INSERT INTO esic_auto_logs (output, report, log) VALUES (%s, %s, %s)",
            (file_details['report.html'], file_details['output.xml'], file_details['log.html'])
        )

        connection.commit()

    except Exception as e:
        print(f"Error inserting file details into the database: {e}")

    finally:
        if connection:
            connection.close()




@app.route('/')
def index():
    return render_template('./main_index.html')

import subprocess

@app.route('/run_robot', methods=['POST'])
def run_robot():
    print('HIIIIIIIIIIIIII')
    try:
        # result = subprocess.run(['robot', 'tasks.robot'], capture_output=True, text=True)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        
        command = [
            'robot',
            '--outputdir', f'/home/buzzadmin/Documents/ESIC_BOT/login/output_directory/{timestamp}_output',
            '/home/buzzadmin/Documents/ESIC_BOT/login/monthlycontri.robot'
        ]
        result = subprocess.run(command, capture_output=True, text=True)
        print(timestamp)
        output_directory = os.path.join(base_dir, 'output_directory', f'{timestamp}_output')
        file_list = os.listdir(output_directory)
        relevant_files = {file:os.path.join(output_directory,file) for file in file_list if file.endswith(('.html', '.xml'))}
        insert_file_details(relevant_files)
        print(relevant_files,'resultresult')
        return jsonify({'log_paths': relevant_files})

    except Exception as e:
        print(e,'eeeeeeeeeeeeeeee')
        return str(e)
    


if __name__ == '__main__':
    app.run(debug=True)
