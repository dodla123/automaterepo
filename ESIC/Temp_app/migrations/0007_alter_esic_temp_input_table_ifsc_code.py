# Generated by Django 5.0.6 on 2024-07-01 06:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('Temp_app', '0006_alter_esic_temp_output_table_created_date'),
    ]

    operations = [
        migrations.AlterField(
            model_name='esic_temp_input_table',
            name='ifsc_code',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
    ]