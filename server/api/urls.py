from django.urls import path

from . import views

urlpatterns = [
    path('get_available_texts/', views.get_available_texts, name='get_available_texts'),
    path('get_text/<str:text_name>/', views.get_text, name='get_text'),
]
