from django.urls import path

from . import views

urlpatterns = [
    path('get_available_texts/', views.get_available_texts_view, name='get_available_texts'),
    path('get_text/', views.get_text_view, name='get_text'),
    path('encode_text/', views.encode_text_view, name='encode_text'),
]
