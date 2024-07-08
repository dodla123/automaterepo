from django.http import JsonResponse
from django.views import View
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.response import Response
from datetime import datetime
from django.views.decorators.csrf import csrf_exempt
from django.core.management.base import BaseCommand
from django.core.mail import EmailMessage
from io import BytesIO
from django.http import HttpResponse
from django.utils.decorators import method_decorator
from django.core.management import call_command
from .models import esic_credentials_table, esic_temp_input_table, esic_temp_output_table
import json
import subprocess
import threading
import pandas as pd
import os


@method_decorator(csrf_exempt, name='dispatch')
class RetrieveEsicDataView(View):
    def post(self, request, *args, **kwargs):
        
        # Fetch credentials data from the table
        esic_credentials_data = esic_credentials_table.objects.all()
        credentials_data = self.prepare_credentials_data(esic_credentials_data)
        
        # Fetch and validate temp data
        esic_temp_data = esic_temp_input_table.objects.filter(status=None)
        # print("  esic_temp_data",  esic_temp_data)
        validated_temp_rows, invalid_temp_rows = self.validate_esic_temp_data(esic_temp_data)
        validated_temp_data = self.prepare_temp_data(validated_temp_rows)
        # print("validated_temp_data ",validated_temp_data )
        
        # Run the bot in a separate thread
        threading.Thread(target=self.run_bot, args=(validated_temp_data, credentials_data)).start()
        
        response_data = {
            'invalid_temp_rows': invalid_temp_rows,
        }
        return JsonResponse(response_data)

    # website credential data table
    def prepare_credentials_data(self, queryset):
        login_credentials_data = []
        for instance in queryset:
            login_credentials_data.append({
                'id': instance.id,
                'locations': instance.locations,
                'user_name': instance.user_name,
                'password': instance.password,
            })
        return login_credentials_data

    # validating user input data table
    def validate_esic_temp_data(self, queryset):
        validated_rows = []
        invalid_rows = []
        for instance in queryset:
            errors = []
            if not instance.name:
                errors.append('Name is required')
            if not instance.mobile_number:
                errors.append('Mobile Number is required')
            
            if errors:
                invalid_rows.append({'instance': instance, 'errors': errors})
            else:
                validated_rows.append(instance)
                
        return validated_rows, invalid_rows

    # user input data table
    def prepare_temp_data(self, queryset):
        user_validated_data = []
        pending_data = False
        
        # Process each instance and update the status
        for instance in queryset:
            user_validated_data.append({
                'hoppr_id': instance.hoppr_id,
                'esic_location': instance.esic_location,
                'mobile_number': instance.mobile_number,
                'name': instance.name,
                'father_name': instance.father_name,
                'gender': instance.gender,
                'marital_status': instance.marital_status,
                'birth_date': instance.birth_date.strftime('%Y-%m-%d') if instance.birth_date else None,
                'spouse_name': instance.spouse_name,
                'current_address': instance.current_address,
                'current_city': instance.current_city,
                'current_state': instance.current_state,
                'current_zipcode': instance.current_zipcode,
                'permanent_address': instance.permanent_address,
                'permanent_city': instance.permanent_city,
                'permanent_state': instance.permanent_state,
                'permanent_zipcode': instance.permanent_zipcode,
                'esic_state_dispensary': instance.esic_state_dispensary,
                'esic_district_dispensary': instance.esic_district_dispensary,
                'dispensary_employee': instance.dispensary_employee,
                'date_of_joining': instance.date_of_joining.strftime('%Y-%m-%d') if instance.date_of_joining else None,
                'sms': instance.sms,
                'nominee_name': instance.nominee_name,
                'nominee_relation': instance.nominee_relation,
                'date_of_birth_family': instance.date_of_birth_family.strftime('%Y-%m-%d') if instance.date_of_birth_family else None,
                'bank_account_number': instance.bank_account_number,
                'ifsc_code': instance.ifsc_code,
                'account_type': instance.account_type,
                'esic_no': instance.esic_no,
                # 'created_esic_no': instance.created_esic_no,
                # 'created_date': instance.created_date.strftime('%Y-%m-%d') if instance.created_date else None,
                'status': instance.status,
                # 'remarks': instance.remarks,
            })

        return user_validated_data

    # Code for running the robot code(bot)
    def run_bot(self, validated_temp_data, credentials_data):
        robot_path = "/home/buzzadmin/Desktop/Django_Esic_Temp_DB_API/ESIC/Temp_app/tasks.robot"
        
        # Create a timestamped output directory
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        output_directory = f"/home/buzzadmin/Desktop/Django_Esic_Temp_DB_API/ESIC/Temp_app/output/{timestamp}"
        
        # Create the output directory if it doesn't exist
        os.makedirs(output_directory, exist_ok=True)
        
        login_credentials_data_json = json.dumps(credentials_data)
        validated_temp_data_json = json.dumps(validated_temp_data)
        
        try:
            command = [
                'robot',
                '--exitonfailure',
                '--variable', f'login_credentials_data:{login_credentials_data_json}',
                '--variable', f'validated_temp_data:{validated_temp_data_json}',
                '--outputdir', output_directory,
                '--log', f'{output_directory}/log.html',
                '--report', f'{output_directory}/report.html',
                '--output', f'{output_directory}/output.xml',
                robot_path
            ]

            result = subprocess.run(command, capture_output=True)
            print('Result:', result)
            print('stdout:', result.stdout.decode())
            print('stderr:', result.stderr.decode())
            if result.returncode == 0:
                print("Robot Framework execution was successful.")
            else:
                print("Robot Framework execution failed.")
        except Exception as e:
            print("An error occurred during the execution:", str(e))
            print("Error occurred while processing the following data:")


# updating the fields to the database(output table)
class InsertUserData(APIView):
    def post(self, request, *args, **kwargs):
        # Extract the data sent with the POST request
        hoppr_id = request.data.get('hoppr_id')
        name = request.data.get('name')
        remarks = request.data.get('remarks')
        status_value = request.data.get('status')
        created_date = request.data.get('created_date')
        created_esic_no = request.data.get('created_esic_no')
        Temp_card_down_path = request.data.get('Temp_card_down_path')
        time = request.data.get('time')
        print('Received data:')
        print('Unique_id:', hoppr_id)
        print('name:', name)
        print('remarks:', remarks)
        print('status_value:', status_value)
        print('time:', time)
        print('Temp_card_down_path:', Temp_card_down_path)
        print('created_esic_no:', created_esic_no)
        # Check if the record already exists in Esic_temp_output_table
        try:
            output_table_entry = esic_temp_output_table.objects.get(hoppr_id=hoppr_id)
        except esic_temp_output_table.DoesNotExist:
            output_table_entry = None

        # Check if the record already exists in Esic_temp_input_table
        try:
            input_table_entry = esic_temp_input_table.objects.get(hoppr_id=hoppr_id)
        except esic_temp_input_table.DoesNotExist:
            input_table_entry = None

        # Update or create the record in Esic_temp_output_table
        if output_table_entry:
            output_table_entry.name = name
            output_table_entry.remarks = remarks
            output_table_entry.status = status_value
            output_table_entry.created_date = created_date
            output_table_entry.created_esic_no = created_esic_no
            output_table_entry.time = time
            output_table_entry.Temp_card_down_path = Temp_card_down_path
            output_table_entry.save()
        else:
            output_table_entry = esic_temp_output_table.objects.create(
                hoppr_id=hoppr_id,
                name=name,
                remarks=remarks,
                status=status_value,
                created_date=created_date,
                time=time,
                created_esic_no=created_esic_no,
                Temp_card_down_path=Temp_card_down_path
                
            )

        # Update the status in Esic_temp_input_table if it exists
        if input_table_entry:
            input_table_entry.status = status_value
            input_table_entry.save()

        return Response(status=status.HTTP_200_OK)
    
class SendAnEmail(APIView):
    def post(self,*args, **kwargs):
        current_date = datetime.now().date().strftime('%Y-%m-%d')
        print(current_date)
        # Fetching data from DB based on status==Pending
        esic_pending_data = list(esic_temp_output_table.objects.filter(status='Pending', created_date=current_date).values())              
        df = pd.DataFrame(esic_pending_data)  
        print('Pending_Data_DB',df)
        
        # Save data to Excel file
        file_path = '/home/buzzadmin/Desktop/Django_Esic_Temp_DB_API/ESIC/Temp_app/output.xlsx'
        df.to_excel(file_path, index=False)
        print("Data exported to esic_temp_output_table_data.xlsx")
        
        # Send email with attachment
        filename = os.path.basename(file_path)
        email = EmailMessage(
            subject='Tagged Cases',
            body='Hi Compliance Team,\n\nplease go through the attached Excel file for Tagged cases.\n\nThis is an automated email, please do not reply.\n\nThanks & Regards,\nAutomation Team.',
            from_email='dodla.manasa@buzzworks.com',
            to=['ravikumar@buzzworks.com']
        )
        with open(file_path, 'rb') as f:
            email.attach(filename, f.read(), 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        email.send()


        print('Email sent successfully!')
            
        return Response(status=status.HTTP_200_OK)

















# def import_data_from_excel(file_path):
#     # try:
    
#     data = pd.read_excel(file_path)
#     print(data)

#     column_mapping = {
#             'Hoppr Id': 'hoppr_id',
#             'ESIC Location': 'esic_location',
#             'Mobile Number': 'mobile_number',
#             'Name': 'name',
#             'Father Name': 'father_name',
#             'Gender': 'gender',
#             'Marital Status': 'marital_status',
#             'Birth Date': 'birth_date',
#             'Spouse Name': 'spouse_name',
#             'Current Address': 'current_address',
#             'Current City': 'current_city',
#             'Current State': 'current_state',
#             'Current Zipcode': 'current_zipcode',
#             'Permanent Address': 'permanent_address',
#             'Permanent City': 'permanent_city',
#             'Permanent State': 'permanent_state',
#             'Permanent Zipcode': 'permanent_zipcode',
#             'ESIC State Dispensary': 'esic_state_dispensary',
#             'ESIC District Dispensary': 'esic_district_dispensary',
#             'Dispensary Employee': 'dispensary_employee',
#             'Date of Joining': 'date_of_joining',
#             'SMS': 'sms',
#             'Nominee Name': 'nominee_name',
#             'Nominee Relation': 'nominee_relation',
#             'Date of Birth(Family)': 'date_of_birth_family',
#             'Bank Account Number': 'bank_account_number',
#             'IFSC Code': 'ifsc_code',
#             'Account type': 'account_type',
#             'ESIC No': 'esic_no',
#             # 'Created ESIC No': 'created_esic_no',
#             # 'Created Date': 'created_date',
#             'Status': 'status',
#             # 'Remarks': 'remarks',
#     }

#     relevant_data = data[list(column_mapping.keys())]
#     date_columns = ["Birth Date", "Date of Joining", "Date of Birth(Family)"]
#     for col in date_columns:
#         relevant_data.loc[:, col] = pd.to_datetime(
#             relevant_data[col], format="%Y-%m-%d", errors="coerce"
#         ).dt.strftime("%Y-%m-%d")
#     for index, row in relevant_data.iterrows():
#         values_dict = {
#             column_mapping[column]: row[column] if not pd.isna(row[column]) else None
#             for column in column_mapping
#         }
#         print(values_dict, "=============")

#         esic_temp_input_table.objects.create(**values_dict)

#     print("Data imported successfully")
# # Example usage:
# file_path = '/home/buzzadmin/Downloads/data_dumpping.xlsx'
# import_data_from_excel(file_path)    


# def import_data_from_excel(file_path):
#     # try:
#     #################################################################################################
#     data = pd.read_excel(file_path)
#     print(data)

#     column_mapping = {
#         'Locations': 'locations',
#         'User Name': 'user_name',
#         'PASSWORD': 'password',
#     }

#     relevant_data = data[list(column_mapping.keys())]
#     # date_columns = ["Birth Date", "Date of Joining", "Date of Birth(Family)"]
#     # for col in date_columns:
#     #     relevant_data.loc[:, col] = pd.to_datetime(
#     #         relevant_data[col], format="%Y-%m-%d", errors="coerce"
#     #     ).dt.strftime("%Y-%m-%d")
#     for index, row in relevant_data.iterrows():
#         values_dict = {
#             column_mapping[column]: row[column] if not pd.isna(row[column]) else None
#             for column in column_mapping
#         }
#         print(values_dict, "=============")

#         esic_credentials_table.objects.create(**values_dict)


#     print("Data imported successfully")




# # Example usage:
# file_path = '/home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx'
# import_data_from_excel(file_path)