# urls.py
from django.urls import path
from .views import RetrieveEsicDataView
from . import views

urlpatterns = [
    # path('import-data/', views.import_data_from_excel, name='import_data'),
    path('retrieve-esic-data/', RetrieveEsicDataView.as_view(), name='retrieve-esic-data'),
    path('api/insert_user_data/', views.InsertUserData.as_view(), name='insert_user_data'),
    # path('process-and-email-data/', views.process_and_email_data, name='process-and-email-data'),
]