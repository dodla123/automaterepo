from django.db import models
from django.utils import timezone


class esic_temp_input_table(models.Model):
    hoppr_id = models.IntegerField(unique=True)
    esic_location = models.CharField(max_length=255, blank=True, null=True)
    mobile_number = models.BigIntegerField()
    name = models.CharField(max_length=255)
    father_name = models.CharField(max_length=255)
    gender = models.CharField(max_length=10)
    marital_status = models.CharField(max_length=20)
    birth_date = models.DateField(null=True, blank=True)  # Allow NULL values
    spouse_name = models.CharField(max_length=255, null=True, blank=True)
    current_address = models.TextField(null=True, blank=True)
    current_city = models.CharField(max_length=100, null=True, blank=True)
    current_state = models.CharField(max_length=100, null=True, blank=True)
    current_zipcode = models.BigIntegerField(null=True, blank=True)
    permanent_address = models.TextField(null=True, blank=True)
    permanent_city = models.CharField(max_length=100, null=True, blank=True)
    permanent_state = models.CharField(max_length=100, null=True, blank=True)
    permanent_zipcode = models.BigIntegerField(null=True, blank=True)
    esic_state_dispensary = models.CharField(max_length=100)
    esic_district_dispensary = models.CharField(max_length=100)
    dispensary_employee = models.CharField(max_length=100)
    date_of_joining = models.DateField(null=True)
    sms = models.CharField(max_length=255)  # Ensure this is a CharField
    nominee_name = models.CharField(max_length=255, null=True, blank=True)
    nominee_relation = models.CharField(null=True, blank=True)
    date_of_birth_family = models.DateField(null=True, blank=True)
    bank_account_number = models.BigIntegerField(null=True, blank=True)
    ifsc_code = models.CharField(max_length=20, null=True, blank=True)  # Allow NULL values
    account_type = models.CharField(max_length=50, null=True, blank=True)
    esic_no = models.BigIntegerField(null=True, blank=True)
    # created_esic_no = models.BigIntegerField(null=True, blank=True)  # Allow NULL values
    # created_date = models.DateField(null=True, blank=True)
    status = models.CharField(max_length=50, null=True, blank=True)
    # remarks = models.TextField(null=True, blank=True)


class esic_credentials_table(models.Model):
    locations = models.CharField(max_length=255)
    user_name = models.BigIntegerField()
    password = models.CharField(max_length=255)
    
    
class esic_temp_output_table(models.Model):
    hoppr_id = models.IntegerField(unique=True)
    name = models.CharField(max_length=255)
    remarks = models.TextField(max_length=255, null=True, blank=True)
    status = models.CharField(max_length=255, null=True, blank=True)
    created_date = models.DateField(auto_now=True)
    # esic_no = models.BigIntegerField(null=True, blank=True)
    created_esic_no = models.BigIntegerField(null=True, blank=True)  # Allow NULL values
    time= models.CharField(default=None,blank=True,null=True,max_length=100)
    Temp_card_down_path = models.FileField(blank=True,null=True, max_length=255)    
