# urls.py
from django.urls import path
from .views import RetrieveEsicDataView
from . import views
# from .views import export_to_excel


urlpatterns = [
    # path('import-data/', views.import_data_from_excel, name='import_data'),
    path('retrieve-esic-data/', RetrieveEsicDataView.as_view(), name='retrieve-esic-data'),
    path('api/insert_user_data/', views.InsertUserData.as_view(), name='insert_user_data'),
    path('api/send_an_email/', views.SendAnEmail.as_view(), name='send_an_email'),

    
    # path('process-and-email-data/', views.process_and_email_data, name='process-and-email-data'),
    # path('db/',export_to_excel.as_views(),name='esic-data'),
]